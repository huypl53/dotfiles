require('auto-session').setup {
    log_level = 'info',
    auto_session_enable_last_session = false,
    auto_session_root_dir = vim.fn.stdpath('data').."/sessions/",
    auto_session_enabled = true,
    auto_save_enabled = true,
    auto_restore_enabled = true,
    auto_session_suppress_dirs = {},
    post_restore_cmds = {"tabdo NERDTreeToggle"},
    pre_save_cmds = {"tabdo NERDTreeClose"},

}