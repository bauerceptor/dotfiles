-- bootstrap lazy.nvim, LazyVim and your plugins
-- local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
-- if not vim.loop.fs_stat(lazypath) then
--     vim.fn.system({
--     "git",
--     "clone",
--     "--filter=blob:none",
--     "https://github.com/folke/lazy.nvim.git",
--     "--branch=stable", -- optional, avoids issues with new releases
--     lazypath,
--   })
-- end
-- vim.opt.rtp:prepend(lazypath)

require("config.lazy")