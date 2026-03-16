-- Saturn profile Neovim bootstrap
local o = vim.opt
local g = vim.g

-- UI tweaks
o.number = true
o.relativenumber = true
o.signcolumn = "yes"
o.termguicolors = true
o.cursorline = true
o.expandtab = true
o.shiftwidth = 2
o.tabstop = 2
o.smartindent = true

-- Search behaviour
o.ignorecase = true
o.smartcase = true
o.incsearch = true
o.hlsearch = false

-- Clipboard + splits
o.clipboard = "unnamedplus"
o.splitbelow = true
o.splitright = true

-- Leader key for Saturn shortcuts
g.mapleader = "space"

-- Simple autocmds
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 250 })
  end,
})

-- Basic keymaps
local map = vim.keymap.set
map("n", "<leader>w", ":w<CR>", { desc = "Save buffer" })
map("n", "<leader>q", ":q<CR>", { desc = "Quit window" })
map("n", "<leader>e", ":Ex<CR>", { desc = "Open netrw" })
map("n", "<leader>t", ":terminal<CR>", { desc = "Open terminal" })

-- Diagnostics helper
map("n", "<leader>dn", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
map("n", "<leader>dp", vim.diagnostic.goto_prev, { desc = "Prev diagnostic" })
map("n", "<leader>dl", vim.diagnostic.setloclist, { desc = "Populate loclist" })

-- Lightweight statusline
o.laststatus = 3
vim.api.nvim_create_autocmd("WinEnter", {
  callback = function()
    local mode = vim.api.nvim_get_mode().mode
    local file = vim.fn.expand("%:t")
    vim.o.statusline = string.format(" %%#StatusLine#Saturn %%#StatusLine#%s %%#StatusLineNC#%s ", mode, file)
  end,
})

-- Optional Lua modules
local ok, _ = pcall(require, "saturn")
if not ok then
  vim.notify("Saturn plugins not yet installed - using minimal config", vim.log.levels.INFO)
end
