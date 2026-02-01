#!/bin/bash
# Download a folder from GitHub using curl/wget or svn

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Help message
show_help() {
    cat << EOF
Usage: $(basename "$0") [OPTIONS] <github-url>

Download a folder from a GitHub repository.

Arguments:
    github-url    GitHub folder URL (e.g., https://github.com/owner/repo/tree/branch/path)

Options:
    -o, --output DIR    Output directory (default: folder name from URL)
    -t, --token TOKEN   GitHub personal access token for higher rate limits
    -h, --help          Show this help message

Examples:
    $(basename "$0") https://github.com/vllm-project/production-stack/tree/main/docs/source/use_cases
    $(basename "$0") -o my_folder https://github.com/owner/repo/tree/main/folder/path
    $(basename "$0") --token ghp_xxx https://github.com/owner/repo/tree/main/folder

Methods (tried in order):
    1. SVN export (fastest, cleanest - requires svn)
    2. GitHub API + curl/wget (requires curl or wget)
    3. Git sparse-checkout (requires git)

EOF
}

# Parse GitHub URL
parse_github_url() {
    local url="$1"

    # Extract components using regex
    if [[ $url =~ github\.com/([^/]+)/([^/]+)/tree/([^/]+)/(.+) ]]; then
        OWNER="${BASH_REMATCH[1]}"
        REPO="${BASH_REMATCH[2]}"
        BRANCH="${BASH_REMATCH[3]}"
        FOLDER_PATH="${BASH_REMATCH[4]}"
    else
        echo -e "${RED}Error: Invalid GitHub URL format${NC}" >&2
        echo "Expected: https://github.com/owner/repo/tree/branch/path" >&2
        exit 1
    fi
}

# Method 1: Use SVN export (cleanest method)
download_with_svn() {
    if ! command -v svn &> /dev/null; then
        return 1
    fi

    echo -e "${YELLOW}Using SVN export method...${NC}"

    # Convert GitHub URL to SVN URL
    # https://github.com/owner/repo/tree/branch/path -> https://github.com/owner/repo/trunk/path
    local svn_url="https://github.com/${OWNER}/${REPO}"

    if [ "$BRANCH" = "main" ] || [ "$BRANCH" = "master" ]; then
        svn_url="${svn_url}/trunk/${FOLDER_PATH}"
    else
        svn_url="${svn_url}/branches/${BRANCH}/${FOLDER_PATH}"
    fi

    svn export "$svn_url" "$OUTPUT_DIR" --force
    return $?
}

# Method 2: Use GitHub API with curl/wget
download_with_api() {
    if ! command -v jq &> /dev/null; then
        echo -e "${YELLOW}Warning: jq not found, trying alternative method...${NC}" >&2
        return 1
    fi

    if command -v curl &> /dev/null; then
        FETCH_CMD="curl -s"
    elif command -v wget &> /dev/null; then
        FETCH_CMD="wget -qO-"
    else
        return 1
    fi

    echo -e "${YELLOW}Using GitHub API method...${NC}"

    download_folder_api "$FOLDER_PATH" "$OUTPUT_DIR"
    return $?
}

download_folder_api() {
    local path="$1"
    local output="$2"

    local api_url="https://api.github.com/repos/${OWNER}/${REPO}/contents/${path}?ref=${BRANCH}"

    # Set up auth header if token provided
    local auth_header=""
    if [ -n "$GITHUB_TOKEN" ]; then
        auth_header="-H \"Authorization: token $GITHUB_TOKEN\""
    fi

    # Fetch directory contents
    local response
    if command -v curl &> /dev/null; then
        if [ -n "$GITHUB_TOKEN" ]; then
            response=$(curl -s -H "Authorization: token $GITHUB_TOKEN" "$api_url")
        else
            response=$(curl -s "$api_url")
        fi
    else
        if [ -n "$GITHUB_TOKEN" ]; then
            response=$(wget -qO- --header="Authorization: token $GITHUB_TOKEN" "$api_url")
        else
            response=$(wget -qO- "$api_url")
        fi
    fi

    # Check for API errors
    if echo "$response" | jq -e '.message' &> /dev/null; then
        local error_msg=$(echo "$response" | jq -r '.message')
        echo -e "${RED}API Error: $error_msg${NC}" >&2
        return 1
    fi

    # Create output directory
    mkdir -p "$output"

    # Process each item
    echo "$response" | jq -c '.[]' | while read -r item; do
        local name=$(echo "$item" | jq -r '.name')
        local type=$(echo "$item" | jq -r '.type')
        local item_path=$(echo "$item" | jq -r '.path')

        if [ "$type" = "file" ]; then
            local download_url=$(echo "$item" | jq -r '.download_url')
            echo "Downloading: $item_path"

            if command -v curl &> /dev/null; then
                curl -sL "$download_url" -o "$output/$name"
            else
                wget -qO "$output/$name" "$download_url"
            fi
        elif [ "$type" = "dir" ]; then
            echo "Entering directory: $item_path"
            download_folder_api "$item_path" "$output/$name"
        fi
    done

    return 0
}

# Method 3: Use git sparse-checkout
download_with_git() {
    if ! command -v git &> /dev/null; then
        return 1
    fi

    echo -e "${YELLOW}Using git sparse-checkout method...${NC}"

    local temp_dir=$(mktemp -d)
    local repo_url="https://github.com/${OWNER}/${REPO}.git"

    (
        cd "$temp_dir"
        git init -q
        git remote add origin "$repo_url"
        git config core.sparseCheckout true
        echo "$FOLDER_PATH/*" > .git/info/sparse-checkout
        git pull -q --depth=1 origin "$BRANCH"

        # Move the folder to output directory
        if [ -d "$FOLDER_PATH" ]; then
            mkdir -p "$(dirname "$OUTPUT_DIR")"
            mv "$FOLDER_PATH" "$OUTPUT_DIR"
        else
            echo -e "${RED}Error: Folder not found in repository${NC}" >&2
            exit 1
        fi
    )

    local result=$?
    rm -rf "$temp_dir"
    return $result
}

# Main function
main() {
    local OUTPUT_DIR=""
    local GITHUB_URL=""

    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_help
                exit 0
                ;;
            -o|--output)
                OUTPUT_DIR="$2"
                shift 2
                ;;
            -t|--token)
                GITHUB_TOKEN="$2"
                shift 2
                ;;
            -*)
                echo -e "${RED}Error: Unknown option $1${NC}" >&2
                show_help
                exit 1
                ;;
            *)
                GITHUB_URL="$1"
                shift
                ;;
        esac
    done

    # Check if URL provided
    if [ -z "$GITHUB_URL" ]; then
        echo -e "${RED}Error: GitHub URL is required${NC}" >&2
        show_help
        exit 1
    fi

    # Check for GITHUB_TOKEN env var
    if [ -z "$GITHUB_TOKEN" ]; then
        GITHUB_TOKEN="${GITHUB_TOKEN:-}"
    fi

    # Parse GitHub URL
    parse_github_url "$GITHUB_URL"

    # Set default output directory if not specified
    if [ -z "$OUTPUT_DIR" ]; then
        OUTPUT_DIR=$(basename "$FOLDER_PATH")
    fi

    echo "Repository: ${OWNER}/${REPO}"
    echo "Branch: ${BRANCH}"
    echo "Folder: ${FOLDER_PATH}"
    echo "Output directory: ${OUTPUT_DIR}"
    echo ""

    # Try different methods in order of preference
    if download_with_svn; then
        echo ""
        echo -e "${GREEN}✓ Successfully downloaded to: ${OUTPUT_DIR}${NC}"
        exit 0
    fi

    if download_with_api; then
        echo ""
        echo -e "${GREEN}✓ Successfully downloaded to: ${OUTPUT_DIR}${NC}"
        exit 0
    fi

    if download_with_git; then
        echo ""
        echo -e "${GREEN}✓ Successfully downloaded to: ${OUTPUT_DIR}${NC}"
        exit 0
    fi

    # If all methods failed
    echo -e "${RED}Error: All download methods failed${NC}" >&2
    echo "Please ensure you have one of the following installed:" >&2
    echo "  - svn (recommended)" >&2
    echo "  - curl/wget + jq" >&2
    echo "  - git" >&2
    exit 1
}

main "$@"
