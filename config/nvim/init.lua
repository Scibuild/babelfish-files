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
vim.opt.guicursor = vim.opt.guicursor._value .. ",a:blinkon0"
vim.opt.autoread = true


vim.g.c_syntax_for_h = 1


vim.g.seoul256_background = 234
vim.cmd.colorscheme("seoul256")

vim.cmd('hi clear SpellBad')
vim.cmd('hi clear SpellCap')
vim.cmd('hi clear SpellLocal')
vim.cmd('hi clear SpellRare')

vim.cmd('hi SpellBad   gui=undercurl guisp=#d75f87')
vim.cmd('hi SpellCap   gui=undercurl guisp=#87afd7')
vim.cmd('hi SpellLocal gui=undercurl guisp=#afd7ff')
vim.cmd('hi SpellRare  gui=undercurl guisp=#ffafd7')


vim.g.mapleader = ","
vim.g.maplocalleader = "\\"

local function mk_map(mode) 
  return function(shortcut, command) 
    vim.api.nvim_set_keymap(mode, shortcut, command, {noremap = true, silent = true})
  end
end

local function mk_mapc(mode) 
  return function(shortcut, command, desc) 
    vim.keymap.set(mode, shortcut, command, { noremap = true, silent = true, desc = desc}) 
  end
end

local nmap = mk_map('n')
local imap = mk_map('i')
local vmap = mk_map('v')

local nmap_c = mk_mapc('n')
local imap_c = mk_mapc('i')
local vmap_c = mk_mapc('v')

nmap_c("<C-S>", vim.cmd.nohlsearch, "clear search")
imap_c("<C-S>", vim.cmd.nohlsearch, "clear search")
nmap("j", "gj")
nmap("k", "gk")
vmap("j", "gj")
vmap("k", "gk")

for k, v in ipairs({'J', 'K', 'L', 'H'}) do
  nmap("<C-" .. v .. ">", "<C-W><C-" .. v .. ">")
end

nmap("Y", "y$")
nmap("<C-Y>", "\"+y")
vmap("<C-Y>", "\"+y")
nmap("<C-P>", "\"+p")
nmap("<C-S-P>", "\"+P")

vim.filetype.add({extension = { typ = 'typst', vert = 'glsl', frag = 'glsl' }})

vim.api.nvim_create_autocmd("BufWritePre", {
    callback = function()
        local mode = vim.api.nvim_get_mode().mode
        local filetype = vim.bo.filetype
        if vim.bo.modified == true and mode == 'n' and filetype ~= "oil" then
            vim.cmd('lua vim.lsp.buf.format()')
        else
        end
    end
})


-- PLUGINS

require('nu').setup({ use_lsp_features = false })

require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true
  }
}

local cmp = require('cmp')
cmp.setup({
  snippet = {
    expand = function(args) end,
  },
  window = { },
  mapping = cmp.mapping.preset.insert({
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
  }, {})
})

cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- cmp.setup.cmdline(':', {
--   mapping = cmp.mapping.preset.cmdline(),
--   sources = cmp.config.sources({
--     { name = 'path' }
--   }, {
--     { name = 'cmdline' }
--   }),
--   matching = { disallow_symbol_nonprefix_matching = false },
-- })

local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()

local lsp_setup = {
  on_attach = function(client, buf_number) 
    vim.api.nvim_buf_set_option(buf_number, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
    local opts = { noremap = true, silent = true, buffer = buf_number }
    local nmap = function(key, cmd) vim.keymap.set('n', key, cmd, opts) end
    nmap('K', vim.lsp.buf.hover)
    print(buf_number)
    nmap('gd', vim.lsp.buf.definition)
    nmap('gi', vim.lsp.buf.implementation)
    nmap('gr', vim.lsp.buf.references)
    nmap('gD', vim.lsp.buf.declaration)
    nmap('gt', vim.lsp.buf.type_definition)
    nmap('<space>r', vim.lsp.buf.rename)
    nmap('<space>a', vim.lsp.buf.code_action)
    nmap('<space>f', vim.lsp.buf.format)
    nmap('<space>e', vim.diagnostic.open_float)

    nmap('<space>d', vim.diagnostic.open_float)
    nmap('gn', vim.diagnostic.goto_next)
    nmap('gN', vim.diagnostic.goto_prev)

    vim.diagnostic.config({
      virtual_text = false
    })

  end,
  flags = { debounce_changes = 150 },
  capabilities = capabilities,
  offset_encoding = "utf-8",
  settings = {
    merlinDiagnostics = { enable = true },
  },
}


local lspconfig = require('lspconfig')
lspconfig.zls.setup(lsp_setup)
lspconfig.rust_analyzer.setup(lsp_setup)
lspconfig.nil_ls.setup(lsp_setup)
lspconfig.tinymist.setup(lsp_setup)
lspconfig.ocamllsp.setup(lsp_setup)
lspconfig.pylsp.setup(lsp_setup)
require('coq-lsp').setup({lsp = lsp_setup})

-- vim.g.loaded_coqtail = 1
-- vim.g.coqtail.supported = 0

require('lspconfig').glslls.setup(vim.tbl_deep_extend('force', lsp_setup, { 
    cmd = { 'glslls', '--stdin', '--target-env', 'opengl' },
}))
if vim.fn.executable('clangd') == 1 then
  require('lspconfig').clangd.setup(lsp_setup)
end
if vim.fn.executable('erlang_ls') == 1 then
  require('lspconfig').erlangls.setup(lsp_setup)
end

require('nvim-lastplace').setup({
    lastplace_ignore_buftype = {"quickfix", "nofile", "help"},
    lastplace_ignore_filetype = {"gitcommit", "gitrebase", "svn", "hgcommit"},
    lastplace_open_folds = true
})

-- Disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("nvim-tree").setup {
  on_attach = function(buf_number)
    local api = require "nvim-tree.api"

    local function opts(desc)
      return { desc = "nvim-tree: " .. desc, buffer = buf_number, noremap = true, silent = true, nowait = true }
    end

    local function nmap_b(key, cmd, desc) 
      vim.keymap.set('n', key, cmd, opts(desc)) 
    end

    nmap_b('<CR>',    api.node.open.edit,                  'Open')
    nmap_b('q',       api.tree.close,                      'Close')
    nmap_b('r',       api.fs.rename,                       'Rename')
    nmap_b('R',       api.tree.reload,                     'Refresh')
    nmap_b('s',       api.node.open.vertical,              'Open: Vertical Split')
    nmap_b('S',       api.node.open.horizontal,            'Open: Horizontal Split')
    nmap_b('<2-LeftMouse>',  api.node.open.edit,           'Open')
    nmap_b('x',         api.node.navigate.parent_close,      'Close Directory')

    -- nmap('<C-t>',   api.tree.change_root_to_parent,      'Up')
    -- nmap('?',       api.tree.toggle_help,                'Help')
    -- nmap('<C-]>',   api.tree.change_root_to_node,        'CD')
    -- nmap('<C-e>',   api.node.open.replace_tree_buffer,   'Open: In Place')
    -- nmap('<C-k>',   api.node.show_info_popup,            'Info')
    -- nmap('<C-r>',   api.fs.rename_sub,                   'Rename: Omit Filename')
    -- nmap('<C-t>',   api.node.open.tab,                   'Open: New Tab')
    -- nmap('<C-v>',   api.node.open.vertical,              'Open: Vertical Split')
    -- nmap('<C-x>',   api.node.open.horizontal,            'Open: Horizontal Split')
    -- nmap('<BS>',    api.node.navigate.parent_close,      'Close Directory')
    -- nmap('<Tab>',   api.node.open.preview,               'Open Preview')
    -- nmap('>',       api.node.navigate.sibling.next,      'Next Sibling')
    -- nmap('<',       api.node.navigate.sibling.prev,      'Previous Sibling')
    -- nmap('.',       api.node.run.cmd,                    'Run Command')
    -- nmap('-',       api.tree.change_root_to_parent,      'Up')
    -- nmap('a',       api.fs.create,                       'Create File Or Directory')
    -- nmap('bd',      api.marks.bulk.delete,               'Delete Bookmarked')
    -- nmap('bt',      api.marks.bulk.trash,                'Trash Bookmarked')
    -- nmap('bmv',     api.marks.bulk.move,                 'Move Bookmarked')
    -- nmap('B',       api.tree.toggle_no_buffer_filter,    'Toggle Filter: No Buffer')
    -- nmap('c',       api.fs.copy.node,                    'Copy')
    -- nmap('C',       api.tree.toggle_git_clean_filter,    'Toggle Filter: Git Clean')
    -- nmap('[c',      api.node.navigate.git.prev,          'Prev Git')
    -- nmap(']c',      api.node.navigate.git.next,          'Next Git')
    -- nmap('d',       api.fs.remove,                       'Delete')
    -- nmap('D',       api.fs.trash,                        'Trash')
    -- nmap('E',       api.tree.expand_all,                 'Expand All')
    -- nmap('e',       api.fs.rename_basename,              'Rename: Basename')
    -- nmap(']e',      api.node.navigate.diagnostics.next,  'Next Diagnostic')
    -- nmap('[e',      api.node.navigate.diagnostics.prev,  'Prev Diagnostic')
    -- nmap('F',       api.live_filter.clear,               'Live Filter: Clear')
    -- nmap('f',       api.live_filter.start,               'Live Filter: Start')
    -- nmap('g?',      api.tree.toggle_help,                'Help')
    -- nmap('gy',      api.fs.copy.absolute_path,           'Copy Absolute Path')
    -- nmap('ge',      api.fs.copy.basename,                'Copy Basename')
    -- nmap('H',       api.tree.toggle_hidden_filter,       'Toggle Filter: Dotfiles')
    -- nmap('I',       api.tree.toggle_gitignore_filter,    'Toggle Filter: Git Ignore')
    -- nmap('J',       api.node.navigate.sibling.last,      'Last Sibling')
    -- nmap('K',       api.node.navigate.sibling.first,     'First Sibling')
    -- nmap('L',       api.node.open.toggle_group_empty,    'Toggle Group Empty')
    -- nmap('M',       api.tree.toggle_no_bookmark_filter,  'Toggle Filter: No Bookmark')
    -- nmap('m',       api.marks.toggle,                    'Toggle Bookmark')
    -- nmap('o',       api.node.open.edit,                  'Open')
    -- nmap('O',       api.node.open.no_window_picker,      'Open: No Window Picker')
    -- nmap('p',       api.fs.paste,                        'Paste')
    -- nmap('P',       api.node.navigate.parent,            'Parent Directory')
    -- nmap('q',       api.tree.close,                      'Close')
    -- nmap('r',       api.fs.rename,                       'Rename')
    -- nmap('R',       api.tree.reload,                     'Refresh')
    -- nmap('s',       api.node.run.system,                 'Run System')
    -- nmap('S',       api.tree.search_node,                'Search')
    -- nmap('u',       api.fs.rename_full,                  'Rename: Full Path')
    -- nmap('U',       api.tree.toggle_custom_filter,       'Toggle Filter: Hidden')
    -- nmap('W',       api.tree.collapse_all,               'Collapse')
    -- nmap('x',       api.fs.cut,                          'Cut')
    -- nmap('y',       api.fs.copy.filename,                'Copy Name')
    -- nmap('Y',       api.fs.copy.relative_path,           'Copy Relative Path')
    -- nmap('<2-LeftMouse>',  api.node.open.edit,           'Open')
    -- nmap('<2-RightMouse>', api.tree.change_root_to_node, 'CD')
    

    -- In all buffers
  end,
  actions = {
    open_file = {
      window_picker = {
        exclude = {
          filetype = { "notify", "packer", "qf", "fugitive", "fugitiveblame" },
          buftype = { "nofile", "terminal", "help" },
        }
      }
    }
  }
}
local nvim_tree_api = require("nvim-tree.api")
nmap_c('<C-n>', function() nvim_tree_api.tree.toggle({}) end, "toggle nvim tree")

require("nvim-surround").setup({})
