vim.opt.number = true    -- 显示行号
vim.wo.cursorline = true -- 当前行号高亮显示
-- Display tabs and trailing spaces
vim.opt.list = true
vim.opt.listchars = { tab = ">-", trail = "-" }
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true

vim.opt.scrolloff = 15
vim.opt.sidescrolloff = 10
vim.opt.startofline = false


vim.opt.conceallevel = 2

vim.wo.wrap = false

-- Tab related options
vim.opt.softtabstop = 2  -- 按 Tab 键时插入的空格数
vim.opt.shiftwidth = 2   -- 自动缩进和缩进操作（>>、<<）的空格数
vim.opt.expandtab = true -- 将 Tab 键自动转换为空格，保证跨平台一致性
vim.opt.smartindent = true

vim.opt.splitbelow = true
vim.opt.splitright = true



-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- bootstrap lazy.nvim, LazyVim and your pluginos
require("config.lazy")      -- Import './lua/confvim.opt.number = true

require("utils.keymapping") -- Import './lua/utils/keymapping.lua

-- Snacks profiler
if vim.env.PROF then
  -- example for lazy.nvim
  -- change this to the correct path for your plugin manager
  local snacks = vim.fn.stdpath("data") .. "/lazy/snacks.nvim"
  vim.opt.rtp:append(snacks)
  require("snacks.profiler").startup({
    startup = {
      event = "VimEnter", -- stop profiler on this event. Defaults to `VimEnter`
      -- event = "UIEnter",
      -- event = "VeryLazy",
    },
  })
end
