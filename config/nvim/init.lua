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
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.g.seoul256_background = 234
vim.cmd("colorscheme seoul256")

vim.g.mapleader = ","
vim.g.maplocalleader = "\\"

function map(mode, shortcut, command)
  vim.api.nvim_set_keymap(mode, shortcut, command, {noremap = true, silent = true})
end

function mk_map(mode) 
  return function(shortcut, command) map(mode, shortcut, command) end
end

nmap = mk_map('n')
imap = mk_map('i')
vmap = mk_map('v')

nmap("<C-S>", ":nohlsearch<CR>")
imap("<C-S>", "<ESC>:nohlsearch<CR>a")
nmap("j", "gj")
nmap("k", "gk")

for k, v in ipairs({'J', 'K', 'L', 'H'}) do
  nmap("<C-" .. v .. ">", "<C-W><C-" .. v .. ">")
end

nmap("Y", "y$")
nmap("<C-Y>", "\"+y")
vmap("<C-Y>", "\"+y")
nmap("<C-P>", "\"+p")



