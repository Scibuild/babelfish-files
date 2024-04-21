vim.opt.number = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.scrolloff = 3
vim.opt.sidescrolloff = 3
vim.opt.cursorline = true
vim.opt.linebreak = true
vim.opt.showmode = false
vim.opt.showcmd = false
vim.opt.mouse = 'a'
vim.opt.termguicolors = true
vim.opt.colorcolumn = { 80 }

vim.g.mapleader = ","
vim.g.maplocalleader = "\\"

function map(mode, shortcut, command)
  vim.api.nvim_set_keymap(mode, shortcut, command, {noremap = true, silent = true})
end

function nmap(shortcut, command)
  map('n', shortcut, command)
end

function imap(shortcut, command)
  map('i', shortcut, command)
end

nmap("<C-S>", ":nohlsearch<C-R>")
imap("<C-S>", "<ESC>:nohlsearch<C-R>i")
nmap("j", "gj")
nmap("k", "gk")

for k, v in ipairs({'J', 'K', 'L', 'H'}) do
  nmap("<C-" .. v .. ">", "<C-W><C-" .. v .. ">")
end

nmap("Y", "y$")
nmap("<C-Y>", "\"+y")
nmap("<C-P>", "\"+p")



