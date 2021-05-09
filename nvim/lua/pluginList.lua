local packer = require("packer")
local use = packer.use

-- using { } for using different branch , loading plugin with certain commands etc
return require("packer").startup(
    function()
        use "wbthomason/packer.nvim"

        -- color related stuff
        use "siduck76/nvim-base16.lua"
        use "norcalli/nvim-colorizer.lua"
        -- use "ollykel/v-vim" -- v syntax highlighter

        -- lsp stuff
        use "nvim-treesitter/nvim-treesitter"
        use "neovim/nvim-lspconfig"
        use "hrsh7th/nvim-compe"
        use "onsails/lspkind-nvim"
        use "sbdchd/neoformat"
        use "nvim-lua/plenary.nvim"
        use "ray-x/lsp_signature.nvim"

        use "lewis6991/gitsigns.nvim"
        use "akinsho/nvim-bufferline.lua"
        use "glepnir/galaxyline.nvim"
        use "windwp/nvim-autopairs"
        use "alvan/vim-closetag"
        
        -- snippet support
        use "hrsh7th/vim-vsnip"
        use "rafamadriz/friendly-snippets"

        -- file managing , picker etc
        use "kyazdani42/nvim-tree.lua"
        use "kyazdani42/nvim-web-devicons"
        use "ryanoasis/vim-devicons"
        use "nvim-telescope/telescope.nvim"
        use "nvim-telescope/telescope-media-files.nvim"
        use "nvim-lua/popup.nvim"
            -- nerdTree
            use {"preservim/nerdtree"}


        -- misc
        use "tweekmonster/startuptime.vim"
        use "907th/vim-auto-save"
        use "karb94/neoscroll.nvim"
        use "kdav5758/TrueZen.nvim"

        -- discord rich presence
        --use "andweeb/presence.nvim"

        use {"lukas-reineke/indent-blankline.nvim", branch = "lua"}


        -- neovim session
        -- session manager
        -- use {'rmagatti/auto-session'}
        -- vim.g.auto_session_root_dir = os.getenv("HOME") .. "/.vim-session/"



        -- Searching
        -- nvim-hlslens helps you better glance searched information, seamlessly jump matched instances.
        -- 3 ways to start hlslens
        --[[ Press / or ? to search text
        Press n or N to jump to the instance matched by last pattern
        Press *, #, g* or g# to search word nearest to the cursor ]]
        use {'kevinhwang91/nvim-hlslens'}


        -- buffer manager
        -- use {"romgrk/barbar.nvim", 
        --     require = {"kyazdani42/nvim-web-devicons"}}
        -- vim.api.nvim_set_var("bufferline.animation", false)


        -- TODO:
        -- use {"907th/vim-auto-save"}
        use {"chriskempson/base16-vim"}

        use "DanilaMihailov/beacon.nvim"
        use "editorconfig/editorconfig-vim"
        use "ray-x/aurora"
            -- Highlight current words
        use {'lfv89/vim-interestingwords'}
        use "tanvirtin/monokai.nvim"
        use "easymotion/vim-easymotion"
        use "rhysd/accelerated-jk"


          -- Assign mark, rename
        use {'Yilin-Yang/vim-markbar'}
        -- width of a vertical split markbar
	vim.g.markbar_width = 40
	vim.g.markbar_enable_peekaboo = false
	--let g:markbar_peekaboo_backtick_mapping = ''

-- Version Control
        use {"simnalamburt/vim-mundo",
          cmd = 'MundoToggle'}
        use {"sindrets/diffview.nvim"}

-- Check missing parentheses
        use {"Yggdroot/hiPairs"}

        -- Focus reading
        use {"junegunn/goyo.vim", 
          cmd = 'Goyo'}

        use {'junegunn/Limelight.vim',
          cmd = 'Limelight'}
          -- Auto close parentheses
        use {'jiangmiao/auto-pairs'}
        
        -- Resize windows by Ctrl-e
        use {'simeji/winresizer'}



-- clever-f.vim extends f, F, t and T mappings for more convenience. 
-- Instead of ;, f is available to repeat after you type f{char} or F{char}. 
--F after f{char} and F{char} is also available to undo a jump. t{char} and T{char} are ditto. 
--This extension makes a repeat easier and makes you forget the existence of ;
        use {'rhysd/clever-f.vim'}

-- help you read complex code by showing diff level of parentheses in diff color !!
        use {'luochen1990/rainbow',
        ft = { 'html', 'css', 'javascript', 'javascriptreact', 'go', 'python', 'lua', 'rust', 'vim', 'less', 'stylus', 'sass', 'scss', 'json', 'ruby', 'toml' }
        }

-- Float terminal
        use {'voldikss/vim-floaterm'}

        --sandwich.vim is a set of operator and textobject plugins to add/delete/replace 
        --surroundings of a sandwiched textobject, like (foo), "bar".
        --use {'machakann/vim-sandwich'}
        use {'blackcauldron7/surround.nvim'}
        use { 'brooth/far.vim'}

-- Outline
        use {'liuchengxu/vista.vim'}

-- Prettier splits and joins patterns inside (), {}, [],...
        use {'AndrewRadev/splitjoin.vim'}
-- Python coding
        use {'jpalardy/vim-slime',
          ft = {'python'}}
        use {'hanschen/vim-ipython-cell',
          ft = {'python'},
          requires={'jpalardy/vim-slime',
          ft = {'python'}}}
        use {'sakhnik/nvim-gdb',
          ft = {'python'}}

        
      --[[ zo: Open a fold
      zc: Close a fold
      zk: Jump to the previous fold.
      zj: Jump to the next fold.
      zR: Open every fold.
      zM: Close every fold. ]]
        use {'kalekundert/vim-coiled-snake',
          ft = {'python'},
          requires={'Konfekt/FastFold'}}

        -- Vim code inspection plugin for finding defitinitionshammer_and_pick and references/usagesmicroscope
        use {'pechorin/any-jump.vim'}
	vim.g.any_jump_disable_default_keybindings = 1
	--Custom ignore files
	--default is: ['*.tmp', '*.temp']
	vim.g.any_jump_ignored_files = {'*.tmp', '*.temp', '*.toml', '*.lua', '*.txt', '*.json'}
	--Prefered search engine: rg or ag
	vim.g.any_jump_search_prefered_engine = 'rg'

        
        -- Easy code navigation through LSP and Treesitter symbols, diagnostic errors.
        -- use {"ray-x/navigator.lua"}

  -- Generate docstring
        use {'kkoomen/vim-doge',
          ft = {'python'}}
        vim.g.doge_doc_standard_python = 'numpy'
-- Neovim plugin to comment text in and out, written in lua. Supports commenting out the current line, a visual selection and a motion.
        use {'b3nj5m1n/kommentary'}



        -- 
        use {'thiagoalessio/rainbow_levels.vim'}

        --vim-which-key is vim port of emacs-which-key that displays available keybindings in popup.
        use {'liuchengxu/vim-which-key'}
    end,
    {
        display = {
            border = { "┌", "─", "┐", "│", "┘", "─", "└", "│" }
        }
    }
)
