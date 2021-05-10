-- THESE ARE EXAMPLE CONFIGS FEEL FREE TO CHANGE TO WHATEVER YOU WANT

-- general
lvim.format_on_save = true
lvim.lint_on_save = true
lvim.colorscheme = "onedarker"

-- keymappings [view all the defaults by pressing <leader>Lk]
lvim.leader = "space"
-- add your own keymapping
lvim.keys.normal_mode["<C-s>"] = ":w<cr>"
-- unmap a default keymapping
-- lvim.keys.normal_mode["<C-Up>"] = ""
-- edit a default keymapping
-- lvim.keys.normal_mode["<C-q>"] = ":q<cr>"

-- Change Telescope navigation to use j and k for navigation and n and p for history in both input and normal mode.
-- lvim.builtin.telescope.on_config_done = function()
--   local actions = require "telescope.actions"
--   -- for input mode
--   lvim.builtin.telescope.defaults.mappings.i["<C-j>"] = actions.move_selection_next
--   lvim.builtin.telescope.defaults.mappings.i["<C-k>"] = actions.move_selection_previous
--   lvim.builtin.telescope.defaults.mappings.i["<C-n>"] = actions.cycle_history_next
--   lvim.builtin.telescope.defaults.mappings.i["<C-p>"] = actions.cycle_history_prev
--   -- for normal mode
--   lvim.builtin.telescope.defaults.mappings.n["<C-j>"] = actions.move_selection_next
--   lvim.builtin.telescope.defaults.mappings.n["<C-k>"] = actions.move_selection_previous
-- end

-- Use which-key to add extra bindings with the leader-key prefix
-- lvim.builtin.which_key.mappings["P"] = { "<cmd>Telescope projects<CR>", "Projects" }
-- lvim.builtin.which_key.mappings["t"] = {
--   name = "+Trouble",
--   r = { "<cmd>Trouble lsp_references<cr>", "References" },
--   f = { "<cmd>Trouble lsp_definitions<cr>", "Definitions" },
--   d = { "<cmd>Trouble lsp_document_diagnostics<cr>", "Diagnosticss" },
--   q = { "<cmd>Trouble quickfix<cr>", "QuickFix" },
--   l = { "<cmd>Trouble loclist<cr>", "LocationList" },
--   w = { "<cmd>Trouble lsp_workspace_diagnostics<cr>", "Diagnosticss" },
-- }

-- TODO: User Config for predefined plugins
-- After changing plugin config exit and reopen LunarVim, Run :PackerInstall :PackerCompile
lvim.builtin.dashboard.active = true
lvim.builtin.terminal.active = true
lvim.builtin.nvimtree.side = "left"
lvim.builtin.nvimtree.show_icons.git = 0

-- if you don't want all the parsers change this to a table of the ones you want
lvim.builtin.treesitter.ensure_installed = {}
lvim.builtin.treesitter.ignore_install = { "haskell" }
lvim.builtin.treesitter.highlight.enabled = true

-- generic LSP settings
-- you can set a custom on_attach function that will be used for all the language servers
-- See <https://github.com/neovim/nvim-lspconfig#keybindings-and-completion>
-- lvim.lsp.on_attach_callback = function(client, bufnr)
--   local function buf_set_option(...)
--     vim.api.nvim_buf_set_option(bufnr, ...)
--   end
--   --Enable completion triggered by <c-x><c-o>
--   buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
-- end
-- you can overwrite the null_ls setup table (useful for setting the root_dir function)
-- lvim.lsp.null_ls.setup = {
--   root_dir = require("lspconfig").util.root_pattern("Makefile", ".git", "node_modules"),
-- }
-- or if you need something more advanced
-- lvim.lsp.null_ls.setup.root_dir = function(fname)
--   if vim.bo.filetype == "javascript" then
--     return require("lspconfig/util").root_pattern("Makefile", ".git", "node_modules")(fname)
--       or require("lspconfig/util").path.dirname(fname)
--   elseif vim.bo.filetype == "php" then
--     return require("lspconfig/util").root_pattern("Makefile", ".git", "composer.json")(fname) or vim.fn.getcwd()
--   else
--     return require("lspconfig/util").root_pattern("Makefile", ".git")(fname) or require("lspconfig/util").path.dirname(fname)
--   end
-- end

-- set a formatter if you want to override the default lsp one (if it exists)
-- lvim.lang.python.formatters = {
--   {
--     exe = "black",
--     args = {}
--   }
-- }
-- set an additional linter
-- lvim.lang.python.linters = {
--   {
--     exe = "flake8",
--     args = {}
--   }
-- }


------------
--Mappings--

M = {}
cmd = vim.cmd

local function map(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

local opt = {}

function split (inputstr, sep)
  local t={}
  if inputstr == nil or inputstr == '' then
    t[0] = ''
    return t
  end
  if sep == nil then
    sep = "%s"
  end
  local i = 0
  for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
    t[i] = str
    i = i+1
  end
  return t
end

-- dont copy any deleted text , this is disabled by default so uncomment the below mappings if you want them
--[[ remove this line

map("n", "dd", [=[ "_dd ]=], opt)
map("v", "dd", [=[ "_dd ]=], opt)
map("v", "x", [=[ "_x ]=], opt)

this line too ]]
--
-- Don't copy the replaced text after pasting in visual mode
map("v", "p", '"_dP', opt)

-- ---------
-- Trouble--
-- ---------

vim.api.nvim_set_keymap("n", "<leader>xx", "<cmd>Trouble<cr>",
{silent = true, noremap = true}
)
vim.api.nvim_set_keymap("n", "<leader>xw", "<cmd>Trouble lsp_workspace_diagnostics<cr>",
{silent = true, noremap = true}
)
vim.api.nvim_set_keymap("n", "<leader>xd", "<cmd>Trouble lsp_document_diagnostics<cr>",
{silent = true, noremap = true}
)
vim.api.nvim_set_keymap("n", "<leader>xl", "<cmd>Trouble loclist<cr>",
{silent = true, noremap = true}
)
vim.api.nvim_set_keymap("n", "<leader>xq", "<cmd>Trouble quickfix<cr>",
{silent = true, noremap = true}
)
vim.api.nvim_set_keymap("n", "gR", "<cmd>Trouble lsp_references<cr>",
{silent = true, noremap = true}
)
-- OPEN TERMINALS --
map("n", "<C-l>", [[<Cmd>vnew term://bash <CR>]], opt) -- term over right
map("n", "<C-x>", [[<Cmd> split term://bash | resize 10 <CR>]], opt) --  term bottom
-- map("n", "<C-t>t", [[<Cmd> tabnew | term <CR>]], opt) -- term newtab
-- Don't copy the replaced text after pasting in visual mode
map("v", "p", '"_dP', opt)

-- Allow moving the cursor through wrapped lines with j, k, <Up> and <Down>
-- http://www.reddit.com/r/vim/comments/2k4cbr/problem_with_gj_and_gk/
-- empty mode is same as using :map
map("", "j", 'v:count ? "j" : "gj"', { expr = true })
map("", "k", 'v:count ? "k" : "gk"', { expr = true })
map("", "<Down>", 'v:count ? "j" : "gj"', { expr = true })
map("", "<Up>", 'v:count ? "k" : "gk"', { expr = true })

-- copy whole file content
map("n",  "<C-a>", ":%y+<CR>", opt)

-- toggle numbers
map("n",  "<leader>n", ":set nu!<CR>", opt)

-- open a new buffer as a Terminal
-- get out of terminal with jk
map("t",  "jk", "<C-\\><C-n>", opt)

-- close current focused buffer, terminal or normal
-- todo: don't close if non-terminal buffer is saved
map("n",  "<S-x>", ":bd!<CR>", opt)

M.toggleterm = function()
  local m = {
    toggle_window = "<leader>tw",
    toggle_vert = "<leader>tv",
    toggle_hori = "<leader>th",
    toggle_lazygit = "<leader>tl",
    toggle_float = "<leader>tf",
    hide_term = "JK",
  },
  -- Open terminals
  map("n", m.toggle_window, ":lua termW:toggle() <CR>", opt)
  map("n", m.toggle_vert, ":lua termV:toggle() <CR>", opt)
  map("n", m.toggle_hori, ":lua termH:toggle() <CR>", opt)
  map("n", m.toggle_lazygit, ":lua termL:toggle() <CR>", opt)
  map("n", m.toggle_float, ":lua termF:toggle() <CR>", opt)

  -- toggle(HIDE) a term from within terminal edit mode
  map("t", m.hide_term, "<C-\\><C-n> :ToggleTerm <CR>", opt)
  map("t", m.hide_term, "<C-\\><C-n> :ToggleTerm <CR>", opt)
  map("t", m.hide_term, "<C-\\><C-n> :ToggleTerm <CR>", opt)
end

M.truezen = function()

  map("n",  "<leader>zz", ":TZAtaraxis<CR>", opt)
  map("n",  "<leader>zm", ":TZMinimalist<CR>", opt)
  map("n",  "<leader>zf", ":TZFocus<CR>", opt)
end

map("n", "<C-s>", ":w <CR>", opt)

M.comment_nvim = function()
  local comment_nvim = {
    comment_toggle = "<leader>/",
  }
  local m = comment_nvim.comment_toggle
  map("n", m, ":CommentToggle<CR>", opt)
  map("v", m, ":CommentToggle<CR>", opt)
end

M.nvimtree = function()
  map("n", "<C-n>", ":NvimTreeToggle<CR>", opt)
end

M.neoformat = function()
  map("n",  "<leader>fm", ":Neoformat<CR>", opt)
end

M.dashboard = function()
  local m ={
    open = "<leader>db",
    newfile = "<leader>fn",
    bookmarks = "<leader>bm",
    sessionload = "<leader>sl",
    sessionsave = "<leader>ss",
  },
  map("n", m.open, ":Dashboard<CR>", opt)
  map("n", m.newfile, ":DashboardNewFile<CR>", opt)
  map("n", m.bookmarks, ":DashboardJumpMarks<CR>", opt)
  map("n", m.sessionload, ":SessionLoad<CR>", opt)
  map("n", m.sessionsave, ":SessionSave<CR>", opt)
end

M.telescope = function()
  -- Telescope
  map("n", "<Leader>fw", ":Telescope live_grep<CR>", opt)
  map("n", "<Leader>gt", ":Telescope git_status <CR>", opt)
  map("n", "<Leader>cm", ":Telescope git_commits <CR>", opt)
  map("n", "<Leader>ff", ":Telescope find_files <CR>", opt)
  map("n", "<Leader>fp", ":Telescope media_files <CR>", opt)
  map("n", "<Leader>fb", ":Telescope buffers<CR>", opt)
  map("n", "<Leader>fh", ":Telescope help_tags<CR>", opt)
  map("n", "<Leader>fo", ":Telescope oldfiles<CR>", opt)
  map("n", "<Leader>th", ":Telescope themes<CR>", opt)
end

M.telescope_media = function()
  map("n",  "<leader>fp", ":Telescope media_files <CR>", opt)
end

M.chadsheet = function()
  map("n",  "<leader>dk", ":lua require('cheatsheet').show_cheatsheet_telescope()<CR>", opt)
  map(
  "n",
  "<leader>uk",
  ":lua require('cheatsheet').show_cheatsheet_telescope{bundled_cheatsheets = false, bundled_plugin_cheatsheets = false }<CR>",
  opt
  )
end

M.bufferline = function()
  local m ={
    new_buffer = "<S-t>",
    newtab = "<C-t>b",
    cycleNext = "<TAB>", -- next buffer
    cyclePrev = "<S-Tab>", -- previous buffer
  }
  map("n", m.new_buffer, ":enew<CR>", opt) -- new buffer
  map("n", m.newtab, ":tabnew<CR>", opt) -- new tab

  -- move between tabs
  map("n", m.cycleNext, ":BufferLineCycleNext<CR>", opt)
  map("n", m.cyclePrev, ":BufferLineCyclePrev<CR>", opt)
end

-- use ESC to turn off search highlighting
map("n", "<Esc>", ":noh<CR>", opt)

-- Packer commands till because we are not loading it at startup
cmd "silent! command PackerCompile lua require 'pluginList' require('packer').compile()"
cmd "silent! command PackerInstall lua require 'pluginList' require('packer').install()"
cmd "silent! command PackerStatus lua require 'pluginList' require('packer').status()"
cmd "silent! command PackerSync lua require 'pluginList' require('packer').sync()"
cmd "silent! command PackerUpdate lua require 'pluginList' require('packer').update()"

M.fugitive = function()
  local m ={
    Git = "<leader>gs",
    diffget_2 = "<leader>gh",
    diffget_3 = "<leader>gl",
    git_blame = "<leader>gb",
  }
  map("n", m.Git, ":Git<CR>", opt)
  map("n", m.diffget_2, ":diffget //2<CR>", opt)
  map("n", m.diffget_3, ":diffget //3<CR>", opt)
  map("n", m.git_blame, ":Git blame<CR>", opt)
end

-- navigation within insert mode
local check_insertNav = true
if check_insertNav == true then
  local m ={
    forward = "<C-l>",
    backward = "<C-h>",
    top_of_line = "<C-a>",
    end_of_line = "<C-e>",
    prev_line = "<C-j>",
    next_line = "<C-k>",
  }

  map("i", m.forward, "<Right>", opt)
  map("i", m.backward, "<Left>", opt)
  map("i", m.top_of_line, "<ESC>^i", opt)
  map("i", m.end_of_line, "<End>", opt)
  map("i", m.next_line, "<Up>", opt)
  map("i", m.prev_line, "<Down>", opt)
end

--  compe mappings
map("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
map("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
map("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
map("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
map("i", "<CR>", "v:lua.completions()", {expr = true})

map("n", "<leader>bd", [[<Cmd>:BufDel<CR>]], opt) -- close current tab
--------------------
--------pmap--------
--------------------
--switch window
map("n", "<C-h>" , "<C-w>h")
map("n", "<C-l>" , "<C-w>l")
map("n", "<C-j>" , "<C-w>j")
map("n", "<C-k>" , "<C-w>k")


--------------
map("i", "<C-w>", "<C-[>diwi")

------------
--hop.nvim--
------------
vim.api.nvim_set_keymap("n", "<leader>lw", "<cmd>:HopWord<CR>", {})
vim.api.nvim_set_keymap("n", "<leader>lwk", "<cmd>:HopWordBC<CR>", {})
vim.api.nvim_set_keymap("n", "<leader>lwj", "<cmd>:HopWordAC<CR>", {})
vim.api.nvim_set_keymap("n", "<leader>lp", "<cmd>:HopPattern<CR>", {})
vim.api.nvim_set_keymap("n", "<leader>lc1", "<cmd>:HopChar1<CR>", {})
vim.api.nvim_set_keymap("n", "<leader>lc2", "<cmd>:HopChar2<CR>", {})
vim.api.nvim_set_keymap("n", "<leader>ll", "<cmd>:HopLine<CR>", {})
vim.api.nvim_set_keymap("n", "<leader>llk", "<cmd>:HopLineBC<CR>", {})
vim.api.nvim_set_keymap("n", "<leader>llj", "<cmd>:HopLineAC<CR>", {})

------------------------
--rhysd/accelerated-jk--
------------------------
vim.api.nvim_set_keymap("n", "j", "<Plug>(accelerated_jk_gj)", {})
vim.api.nvim_set_keymap("n", "k", "<Plug>(accelerated_jk_gk)", {})

---------------------------
---junegunn/Limelight.vim--
---------------------------
vim.api.nvim_set_keymap('n', '<Leader>L', ':Limelight!!<CR>', {})
-- for selected
vim.api.nvim_set_keymap('n', '<Leader>l', '<Plug>(Limelight)', {})
vim.api.nvim_set_keymap('x', '<Leader>l', '<Plug>(Limelight)', {})

vim.g.limelight_conceal_ctermfg = 'gray'
vim.g.limelight_conceal_ctermfg = 240
vim.g.limelight_conceal_guifg = 'DarkGray'
vim.g.limelight_conceal_guifg = '#777777'
-----------
--rainbow--
-----------
vim.g.rainbow_active = 1

----------------
--far.vim----
------------
vim.g.lazyredraw = true        --improve scrolling performance when navigating through large results
vim.g.regexpengine=1       --use old regexp engine
--set ignorecase smartcase  " ignore case only when the pattern contains no capital letters
vim.g.ignore = 'smartcase'
vim.g.far = {
  source = 'rg',
  window_width = 50,
  preview_window_width = 50,
}
vim.api.nvim_set_var('prompt_mapping',
{
  quit           = { key = '<esc>', prompt = 'Esc' },
  regex          = { key = '<C-x>', prompt = '^X'  },
  case_sensitive = { key = '<C-a>', prompt = '^A'  },
  word           = { key = '<C-w>', prompt = "^W"  },
  substitute     = { key = '<C-f>', prompt = '^F'  },
}
)
--shortcut for far.vim find
vim.api.nvim_set_keymap('n', '<localleader>f', ':Farf<cr>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('x', '<localleader>f', ':Farf<cr>', { noremap = true, silent = true })

-- shortcut for far.vim replace
vim.api.nvim_set_keymap('n', '<localleader>r', ':Farr<cr>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('x', '<localleader>r', ':Farr<cr>', { noremap = true, silent = true })

------------------------
--liuchengxu/vista.vim--
------------------------
vim.api.nvim_set_keymap('n', '<Leader>i', ':<C-u>Vista!!<CR>', {silent = true})

-----------------------------
--AndrewRadev/splitjoin.vim--
-----------------------------
vim.g.splitjoin_join_mapping = ''
vim.g.splitjoin_split_mapping = ''
vim.api.nvim_set_keymap('n', 'sj', ':SplitjoinJoin<CR>', {})
vim.api.nvim_set_keymap('n', 'sk', ':SplitjoinSplit<CR>', {})

----------------------
--jpalardy/vim-slime--
----------------------
vim.g.slime_target = 'tmux'
vim.g.slime_python_ipython = 1
vim.g.slime_default_config = {
  socket_name= split(os.getenv('TMUX'), ',')[0],
  target_pane= '{top-right}'
}
vim.g.slime_dont_ask_default = 1
-- socket_name= "get(split($TMUX, ','), 0)",
-- target_pane= '{top-right}'

------------------------------
--hanschen/vim-ipython-cell--
------------------------------
vim.api.nvim_set_keymap('n', '<leader>as', ':SlimeSend1 ipython --matplotlib<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>ar', ':IPythonCellRun<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>aR', ':IPythonCellRunTime<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>ac', ':IPythonCellExecuteCell<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>aC', ':IPythonCellExecuteCellJump<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>ae', ':IPythonCellExecuteCellVerbose<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>aE', ':IPythonCellExecuteCellVerboseJump<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>al', ':IPythonCellClear<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>ax', ':IPythonCellClose<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', '[c', ':IPythonCellPrevCell<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', ']c', ':IPythonCellNextCell<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>ah', '<Plug>SlimeLineSend', {})
vim.api.nvim_set_keymap('x', '<leader>ah', '<Plug>SlimeRegionSend', {})
vim.api.nvim_set_keymap('n', '<leader>aj', '<Plug>SlimeParagraphSend', {})
vim.api.nvim_set_keymap('n', '<leader>ap', ':IPythonCellPrevCommand<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>aQ', ':IPythonCellRestart<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>ad', ':SlimeSend1 %debug<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>aq', ':SlimeSend1 exit<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', '<F2>', ':SlimeSend1 python % <CR>', {noremap = true})
--let g:ipython_cell_tag = ['# %%', '#%%', '# <codecell>', '##']


-------------------------
--pechorin/any-jump.vim--
-------------------------
-- Normal mode: Jump to definition under cursore
vim.api.nvim_set_keymap('n', '<leader>j', ':AnyJump<CR>', {noremap = true})
-- Visual mode: jump to selected text in visual mode
vim.api.nvim_set_keymap('x', '<leader>j', ':AnyJumpVisual<CR>', {noremap = true})
-- Normal mode: open previous opened file (after jump)
vim.api.nvim_set_keymap('n', '<leader>ab', ':AnyJumpBack<CR>', {noremap = true})
-- Normal mode: open last closed search window again
vim.api.nvim_set_keymap('n', '<leader>al', ':AnyJumpLastResults<CR>', {noremap = true})

---------------------
--simeji/winresizer--
---------------------
vim.g.winresizer_start_key="<Nop>"
map("n", "<C-e>r", ":WinResizerStartResize<CR>")
map("n", "<C-e>m", ":WinResizerStartMove<CR>")
map("n", "<C-e>f", ":WinResizerStartFocus<CR>")


----------
--OTHERS--
----------

M.signature = function()
   local present, lspsignature = pcall(require, "lsp_signature")
   if present then
      lspsignature.setup {
         bind = true,
         doc_lines = 2,
         floating_window = true,
         fix_pos = true,
         hint_enable = true,
         hint_prefix = " ",
         hint_scheme = "String",
         use_lspsaga = false,
         hi_parameter = "Search",
         max_height = 22,
         max_width = 120, -- max_width of signature floating_window, line will be wrapped if exceed max_width
         handler_opts = {
            border = "single", -- double, single, shadow, none
         },
         zindex = 50, -- by default it will be on top of all floating windows, set to 50 send it to bottom
         padding = "", -- character to pad on left and right of signature can be ' ', or '|'  etc
      }
   end
end
-- lvim.builtin.terminal
-----------------------
-- Additional Plugins--
-----------------------
lvim.plugins = {
    {"folke/tokyonight.nvim"}, 
-- {
--     "nvim-treesitter/nvim-treesitter",
--     event = "BufRead",
--     config = function()
--       require "plugins.treesitter"
--     end
--   },
{
    "nvim-treesitter/nvim-treesitter-textobjects",
    after="nvim-treesitter"
  },
{
    "glepnir/lspsaga.nvim",
    config = function()
      require("lspsaga").init_lsp_saga()
    end
  },
{
    "ahmedkhalf/lsp-rooter.nvim",
    config = function()
      require("lsp-rooter").setup {
      }
    end
  },
{
    "onsails/lspkind-nvim",
    event = "BufEnter",
    config = function()
      require("lspkind").init()
    end
  },
{
    "ray-x/lsp_signature.nvim",
    after = "nvim-lspconfig",
    config = function()
      M.signature()
    end,
  },
{
    "Chiel92/vim-autoformat",
    config = function()
      vim.g.python3_host_prog="/bin/python3"
      vim.g.formatterpath="$HOME/.local/bin/black"
    end
  },
-- {
--     "nvim-lua/plenary.nvim",
--     after = "nvim-bufferline.lua",
--   },
{
    "folke/todo-comments.nvim",
    requires = "nvim-lua/plenary.nvim",
    config = function()
      require("todo-comments").setup {
        keywords = {
          FIX = {
            icon = " ", -- icon used for the sign, and in search results
            color = "error", -- can be a hex color, or a named color (see below)
            alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, -- a set of other keywords that all map to this FIX keywords
            -- signs = false, -- configure signs for some keywords individually
          },
          TODO = { icon = " ", color = "info" },
          HACK = { icon = " ", color = "warning" },
          WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
          PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
          NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
        }
      }
    end
  },
{
    "hrsh7th/nvim-compe",
    event = "InsertEnter",
    config = function()
      require("plugins.compe").setup{
   enabled = true,
   autocomplete = true,
   debug = false,
   min_length = 1,
   preselect = "enable",
   throttle_time = 80,
   source_timeout = 200,
   incomplete_delay = 400,
   max_abbr_width = 100,
   max_kind_width = 100,
   max_menu_width = 100,
   documentation = true,
   source = {
      buffer = { kind = "﬘", true },
      luasnip = { kind = "﬌", true },
      nvim_lsp = true,
      nvim_lua = true,
   },
}
    end,
    wants = "LuaSnip",
    requires = {
      {
        "L3MON4D3/LuaSnip",
        wants = "friendly-snippets",
        event = "InsertCharPre",
        config = function()
local t = function(str)
   return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
   local col = vim.fn.col "." - 1
   if col == 0 or vim.fn.getline("."):sub(col, col):match "%s" then
      return true
   else
      return false
   end
end

_G.tab_complete = function()
   if vim.fn.pumvisible() == 1 then
      return t "<C-n>"
   elseif luasnip and luasnip.expand_or_jumpable() then
      return t "<Plug>luasnip-expand-or-jump"
   elseif check_back_space() then
      return t "<Tab>"
   else
      return vim.fn["compe#complete"]()
   end
end
_G.s_tab_complete = function()
   if vim.fn.pumvisible() == 1 then
      return t "<C-p>"
   elseif luasnip and luasnip.jumpable(-1) then
      return t "<Plug>luasnip-jump-prev"
   else
      return t "<S-Tab>"
   end
end

_G.completions = function()
   local npairs
   if not pcall(function()
      npairs = require "nvim-autopairs"
   end) then
      return
   end

   if vim.fn.pumvisible() == 1 then
      if vim.fn.complete_info()["selected"] ~= -1 then
         return vim.fn["compe#confirm"] "<CR>"
      end
   end
   return npairs.check_break_line_char()
end

vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", { expr = true })
vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", { expr = true })
vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", { expr = true })
vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", { expr = true })
vim.api.nvim_set_keymap("i", "<CR>", "v:lua.completions()", { expr = true })

luasnip.config.set_config {
   history = true,
   updateevents = "TextChanged,TextChangedI",
}
require("luasnip/loaders/from_vscode").load()
        end
      },
      {
        "rafamadriz/friendly-snippets",
        event = "InsertCharPre"
      }
    }
  },
  {"hrsh7th/vim-vsnip"}, -- VSCode(LSP)'s snippet feature in vim
   {
    "kevinhwang91/nvim-bqf",
    config=function()
      require("bqf").setup({
    auto_enable = true,
    preview = {
        win_height = 12,
        win_vheight = 12,
        delay_syntax = 80,
        border_chars = {'┃', '┃', '━', '━', '┏', '┓', '┗', '┛', '█'}
    },
    func_map = {
        vsplit = '',
        ptogglemode = 'z,',
        stoggleup = ''
    },
    filter = {
        fzf = {
            action_for = {['ctrl-s'] = 'split'},
            extra_opts = {'--bind', 'ctrl-o:toggle-all', '--prompt', '> '}
        }
    }
})

cmd "hi BqfPreviewBorder guifg=#50a14f ctermfg=71"
cmd "hi link BqfPreviewRange Search"
cmd "hi default link BqfPreviewFloat Normal"
cmd "hi default link BqfPreviewBorder Normal"
cmd "hi default link BqfPreviewCursor Cursor"
cmd "hi default link BqfPreviewRange IncSearch"
cmd "hi default BqfSign ctermfg=14 guifg=Cyan"
    end
  },
{
    "Pocco81/TrueZen.nvim",
    cmd = {
      "TZAtaraxis",
      "TZMinimalist",
      "TZFocus",
    },
    config = function()
      require("true-zen").setup{
   ui = {
      bottom = {
         laststatus = 0,
         ruler = false,
         showmode = false,
         showcmd = false,
         cmdheight = 1,
      },
      top = {
         showtabline = 0,
      },
      left = {
         number = false,
         relativenumber = false,
         signcolumn = "no",
      },
   },
   modes = {
      ataraxis = {
         left_padding = 32,
         right_padding = 32,
         top_padding = 1,
         bottom_padding = 1,
         ideal_writing_area_width = { 0 },
         auto_padding = true,
         keep_default_fold_fillchars = true,
         custome_bg = "",
         bg_configuration = true,
         affected_higroups = {
            NonText = {},
            FoldColumn = {},
            ColorColumn = {},
            VertSplit = {},
            StatusLine = {},
            StatusLineNC = {},
            SignColumn = {},
         },
      },
      focus = {
         margin_of_error = 5,
         focus_method = "experimental",
      },
   },
   integrations = {
      vim_gitgutter = false,
      galaxyline = true,
      tmux = false,
      gitsigns = false,
      nvim_bufferline = true,
      limelight = false,
      vim_airline = false,
      vim_powerline = false,
      vim_signify = false,
      express_line = false,
      lualine = false,
   },
   misc = {
      on_off_commands = false,
      ui_elements_commands = false,
      cursor_by_mode = false,
   },
      }
    end,
    setup = function()
      M.truezen()
    end,
  },
{
    "tpope/vim-fugitive",
    cmd = {
      "Git",
    },
    setup = function()
      M.fugitive()
    end,
  },
  {"rhysd/accelerated-jk"},
   {
    "t9md/vim-choosewin",
    config = function()
      vim.api.nvim_set_keymap("n", "<leader>-", "<Plug>(choosewin)", {})
      vim.g.choosewin_overlay_enable = 1
    end
  },
{'junegunn/Limelight.vim',
  cmd = 'Limelight'},
{'simeji/winresizer'},
{
    "luochen1990/rainbow",
    ft = { 'html', 'css', 'javascript', 'javascriptreact', 'go', 'python', 'lua', 'rust', 'vim', 'less', 'stylus', 'sass', 'scss', 'json', 'ruby', 'toml' }
  },
{
    "blackCauldron7/surround.nvim",
    config = function()
      require "surround".setup {
      }
    end
  },
{'brooth/far.vim'},
{
    'simrat39/symbols-outline.nvim',
    config = function()
      vim.api.nvim_set_keymap("n", "<leader>i", "<cmd>SymbolsOutline<CR>", {})
    end
  },
{'AndrewRadev/splitjoin.vim'},
{
    "jpalardy/vim-slime",
    ft = {'python', 'javascript'}
  },
{
    'hanschen/vim-ipython-cell',
    ft = {'python', 'javascript'},
    requires={'jpalardy/vim-slime',}
  },
{
    'sakhnik/nvim-gdb',
    ft = {'python'}
  },
{
    "darrikonn/vim-isort",
    ft = {"python"}
  },
{
    "sbdchd/neoformat",
    cmd="Neoformat"
  },
{
    "dense-analysis/ale",
    after="nvim-lspconfig",
    config = function()
-- Run ale only when saving files 
-- vim.g.ale_lint_on_text_changed = 'never'
-- vim.g.ale_lint_on_insert_leave = 0
--
-- Dont run ale on opening files
-- vim.g.ale_lint_on_enter = 0
vim.g.ale_echo_msg_error_str = 'E'
vim.g.ale_echo_msg_warning_str = 'W'
vim.g.ale_echo_msg_format = '[%linter%] %s [%severity%]'
vim.g.ale_completion_enabled=0
    end
  },
{
    "iamcco/markdown-preview.nvim",
    ft={'markdown', 'pandoc.markdown', 'rmd'},
    run = 'cd app && npm install',
    cmd = 'MarkdownPreview',
    config=function()
      vim.g.mkdp_echo_preview_url=1
    end
  },
  {
    "glepnir/galaxyline.nvim",
    after = "nvim-web-devicons",
    config = function()
      require "plugins.statusline"
    end,
  }
}

-- Autocommands (https://neovim.io/doc/user/autocmd.html)
-- lvim.autocommands.custom_groups = {
--   { "BufWinEnter", "*.lua", "setlocal ts=8 sw=8" },
-- }
--

