# Tmux Pane Idle Detection Design

Date: 2026-04-15

## Goal
Create a tmux helper script that detects when a pane becomes idle by combining:
1. Stable displayed text hash over time, and
2. Pane process activity observation.

The script is intended for agent automation. It must print a final payload before exiting on all terminal paths.

## Scope
Add one new script:
- `scripts/wait-for-idle.sh`

No changes to existing `wait-for-text.sh` behavior.

## CLI Contract

### Command
`./scripts/wait-for-idle.sh -t <target> [options]`

### Target forms
`--target` (`-t`) accepts:
- Full tmux target: `session:window.pane`
- Pane ID form: `%<pane_id>` (example: `%12`)

### Options
- `-t, --target <target>`: required
- `-i, --interval <seconds>`: poll interval, default `1`
- `-n, --stable-count <int>`: required unchanged hash checks, default `5`
- `-s, --idle-seconds <int>`: required unchanged elapsed seconds, default `10`
- `-l, --lines <int>`: tail lines to capture/hash/print, default `200`
- `-T, --timeout <int>`: hard timeout seconds, default `0` (`0` means no timeout)
- `--status-only`: print `idle` only on success
- `-S, --socket-path <path>`: pass to tmux as `-S`
- `-L, --socket <name>`: pass to tmux as `-L`
- `-h, --help`: usage

### Output and exit codes
The script must print exactly one final payload before exiting.

- Idle detected:
  - Default: print pane tail text (last `--lines` lines), then exit `0`
  - `--status-only`: print `idle`, then exit `0`
- Timeout:
  - Print timeout payload with last pane tail, exit `1`
- Error (invalid args/target/tool failure):
  - Print error payload, exit `2`

### Message prefixes
Machine-parseable first token on final payload:
- `IDLE:`
- `TIMEOUT:`
- `ERROR:`

Note: In default mode, payload includes pane tail content after the `IDLE:` header.
In `--status-only` mode, success payload is exactly `IDLE: idle`.

## Detection Algorithm

Each poll iteration:
1. Resolve pane metadata
   - Query pane info via `tmux display-message -p -t "$target"` using format containing `#{pane_id}` and `#{pane_pid}`.
   - Validate target exists.
2. Capture pane text
   - `tmux capture-pane -p -J -t "$target" -S "-$lines"`
   - Hash with SHA-256 (`shasum -a 256`, fallback `sha256sum`).
3. Capture pane activity
   - Start from `pane_pid`.
   - Recursively collect descendant PIDs (`pgrep -P`).
   - Read CPU time for all collected PIDs via `ps`, convert to seconds, and sum.
4. Update stable window
   - If hash changed: reset stable window baseline:
     - baseline hash
     - baseline timestamp
     - baseline CPU total
     - stable count reset to `1`
   - If hash unchanged:
     - increment stable count
     - update unchanged elapsed as `now - baseline timestamp`
5. Evaluate idle (all required)
   - `stable_count >= stable_count_threshold`
   - `unchanged_elapsed >= idle_seconds_threshold`
   - `cpu_total_delta <= 0` versus stable-window baseline
6. On first idle hit
   - Print final payload
   - Exit immediately `0`

## Activity Signal Details
Use pane process tree CPU aggregation to improve accuracy for pane-only activity:
- Include `pane_pid` and all descendants.
- If CPU total increases during unchanged text window, pane is treated as active.
- This catches compute activity with unchanged visible text.

## Error Handling

Validation errors (`ERROR`, exit `2`):
- missing required `--target`
- invalid numeric options
- mutually exclusive socket args conflict (`-S` and `-L` both provided)
- tmux binary unavailable
- no SHA-256 tool available
- target pane not found

Runtime errors (`ERROR`, exit `2`):
- cannot capture pane text
- cannot resolve pane metadata
- process sampling failures that prevent reliable activity determination

Timeout (`TIMEOUT`, exit `1`):
- timeout exceeded with no idle detection
- include last pane capture in payload

## Test Cases

### A. CLI/validation
1. Help output
   - Command: `./scripts/wait-for-idle.sh -h`
   - Expect: usage text, exit `0`
2. Missing target
   - Command: `./scripts/wait-for-idle.sh`
   - Expect: `ERROR:` payload, exit `2`
3. Invalid numeric arg
   - Command: `./scripts/wait-for-idle.sh -t %1 -n x`
   - Expect: `ERROR:` payload, exit `2`
4. Unknown target
   - Command: `./scripts/wait-for-idle.sh -t %999999 -T 2`
   - Expect: `ERROR:` payload, exit `2`

### B. Target forms
5. Full target form works
   - Command: `./scripts/wait-for-idle.sh -t mysession:0.0 --status-only -T 30`
   - Expect: `IDLE: idle` payload, exit `0`
6. `%pane_id` form works
   - Command: `./scripts/wait-for-idle.sh -t %12 --status-only -T 30`
   - Expect: idle detection, exit `0`

### C. Idle semantics
7. Quiet pane reaches idle
   - Setup: pane shell at prompt, no output changes, no CPU work
   - Command: `./scripts/wait-for-idle.sh -t <target> -n 5 -s 10 -T 30 --status-only`
   - Expect: idle payload before timeout, exit `0`
8. Active text changes do not idle
   - Setup: pane running command that continuously prints changing output
   - Command: `./scripts/wait-for-idle.sh -t <target> -n 5 -s 10 -T 8 --status-only`
   - Expect: `TIMEOUT:` payload, exit `1`
9. Silent compute does not idle
   - Setup: pane running CPU-bound command with minimal/no text updates
   - Command: `./scripts/wait-for-idle.sh -t <target> -n 5 -s 10 -T 15 --status-only`
   - Expect: no false idle while CPU increases; likely timeout `1`

### D. Output behavior for agents
10. Default output mode
    - Command: `./scripts/wait-for-idle.sh -t <target> -T 30 -l 50`
    - Expect: final payload includes pane tail text, then exit `0`
11. Status-only output mode
    - Command: `./scripts/wait-for-idle.sh -t <target> --status-only -T 30`
    - Expect: final payload contains idle status only, then exit `0`
12. Timeout prints before exit
    - Command: `./scripts/wait-for-idle.sh -t <busy_target> -T 3`
    - Expect: `TIMEOUT:` payload printed before process exits `1`
13. Error prints before exit
    - Command: invalid target/tooling case
    - Expect: `ERROR:` payload printed before process exits `2`

## Non-Goals
- Perfect OS-independent process accounting for every shell/job-control edge case.
- Modifying existing helper scripts unless required by future implementation plan.

## Risks and Mitigations
- Process-tree sampling overhead:
  - Mitigation: keep interval default at 1s and limit process traversal to descendants.
- PID churn/races:
  - Mitigation: tolerate missing child samples in a cycle only if aggregate remains reliable; otherwise error out.
- Cross-platform `ps` format differences:
  - Mitigation: implement parser paths for macOS/Linux formats in script.

## Implementation Notes (for planning phase)
- Reuse parsing/validation style from existing scripts.
- Keep all messages deterministic and concise for agent consumption.
- Preserve ASCII-only script content.
