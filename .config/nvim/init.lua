-- Appearance {{{
vim.opt.termguicolors = true
vim.opt.background = 'dark'

-- vim.g['gruvbox_bold'] = 0
-- vim.cmd('colorscheme gruvbox')

vim.cmd('packadd! gruvbox-material')
vim.g['gruvbox_material_background'] = 'medium'
vim.g['gruvbox_material_better_performance'] = 1
vim.cmd('colorscheme gruvbox-material')

require('catppuccin').setup({
  flavour = "mocha",
  custom_highlights = function(colors)
    return {
      WinSeparator = { fg = colors.surface1 },
    }
  end
})
-- vim.cmd.colorscheme 'catppuccin'
-- }}}

-- Options {{{
vim.opt.laststatus = 3
vim.opt.hidden = true
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.wrap = false
vim.opt.numberwidth = 1
vim.opt.number = true
vim.opt.autoread = true
vim.opt.ruler = true
vim.opt.cursorline = true
vim.opt.mouse = 'a'
vim.opt.clipboard = 'unnamedplus'
vim.opt.inccommand = 'split'
vim.opt.incsearch = true
vim.opt.hlsearch = false
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.scrolloff = 3
vim.opt.expandtab = true
vim.opt.smarttab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 8
vim.opt.softtabstop = 4
vim.opt.list = true
vim.opt.listchars = { tab = '› ', trail = '·' }
vim.opt.cmdheight = 1 -- cmdheight = 0 possible on neovim nightly but somewhat buggy
vim.opt.updatetime = 300
vim.opt.shortmess:append({ c = true })
vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }
vim.opt.signcolumn = 'number'
vim.opt.diffopt:append('vertical')
-- }}}

-- Keybindings {{{
vim.g.mapleader = ' '
vim.keymap.set('i', 'jk', '<Esc>')
vim.keymap.set('n', '<leader>ve', ':edit $MYVIMRC<CR>')
vim.keymap.set('n', '<leader>vs', ':source $MYVIMRC<CR>')
vim.keymap.set('n', 'gp', ':bp<CR>', { silent=true })
vim.keymap.set('n', 'gn', ':bn<CR>', { silent=true })
vim.keymap.set('n', 'gh', '0', { silent=true })
vim.keymap.set('n', 'gl', '$', { silent=true })
-- vim.keymap.set('n', 'gs', '^', { silent=true })
vim.keymap.set('n', 'ga', '<C-^>', { silent=true })
vim.keymap.set('n', '<leader>p', ':echo "use gp instead"<CR>', { silent=true })
vim.keymap.set('n', '<leader>n', ':echo "use gn instead"<CR>', { silent=true })
-- vim.keymap.set('n', '<leader>d', ':bp <BAR> bd #<CR>', { silent=true })
vim.keymap.set('n', '<leader>ws', ':split<CR>', { silent=true })
vim.keymap.set('n', '<leader>wv', ':vsplit<CR>', { silent=true })

vim.keymap.set({'n', 'v'}, '<leader>=', ':Tabularize /=<CR>')
vim.keymap.set({'n', 'v'}, '<leader>&', ':Tabularize /&<CR>')
vim.keymap.set({'n', 'v'}, '<leader>>', ':Tabularize /=><CR>')

-- Emulate US keyboard. Dead keys must be disabled for this to work properly.
local map = {
  {'¤', '$'},
  {'å', '['},
  {'¨', ']'},
  {'Å', '{'},
  {'^', '}'},
}

for _, v in ipairs(map) do
  vim.keymap.set({'n', 'o', 'v'}, v[1], v[2], { remap=true })
end
vim.keymap.set('n', '<C-¨>', '<C-]>')
-- }}}

-- Filetype Settings {{{
local ftaugroup = vim.api.nvim_create_augroup('ft_settings', { clear = true })

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'lua,vim',
  group = ftaugroup,
  callback = function()
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
  end
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'python',
  group = ftaugroup,
  callback = function()
    vim.opt_local.formatoptions = { c = true, q = true, r = true, j = true }
  end
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'c,cpp',
  group = ftaugroup,
  callback = function()
    vim.opt_local.commentstring = '// %s'
    vim.opt_local.comments:prepend(':///')
    vim.opt_local.comments:prepend('://!')
    vim.opt_local.formatoptions = { c = true, q = true, r = true, j = true }
    vim.opt_local.cinoptions = { 'g0', ':0', 'l1', '(0', 'Ws' }
  end
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'gitconfig',
  group = ftaugroup,
  callback = function()
    vim.opt_local.expandtab = false
    vim.opt_local.shiftwidth = 8
  end
})

vim.api.nvim_create_autocmd('BufEnter', {
  pattern = '*.do',
  group = ftaugroup,
  callback = function()
    vim.opt_local.filetype = 'tcl'
  end
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'vhdl',
  group = ftaugroup,
  callback = function()
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.commentstring = '-- %s'
    vim.opt_local.comments:append({ ':--', 'b:--' })
    vim.opt_local.formatoptions = { c = true, q = true, r = true, j = true }
    vim.keymap.set({ 'n', 'v' }, '<leader>:', ':Tabularize /:<CR>', { buffer = true })
    vim.keymap.set({ 'n', 'v' }, '<leader>>', ':Tabularize /=><CR>', { buffer = true })
    vim.keymap.set({ 'n', 'v' }, '<leader><', ':Tabularize /<=<CR>', { buffer = true })
  end
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'spade',
  group = ftaugroup,
  callback = function()
    vim.opt_local.commentstring = '// %s'
    vim.opt_local.formatoptions = { c = true, q = true, r = true, j = true }
  end
})

vim.api.nvim_create_autocmd('FileType', {
  pattern= 'nim',
  group = ftaugroup,
  callback = function()
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
  end
})

-- Misc Options
vim.g['vhdl_indent_genportmap'] = false
vim.g['c_no_curly_error'] = true
vim.g['zig_fmt_autosave'] = false
-- }}}

-- nvim-lsp {{{
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { silent=true })
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { silent=true })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { silent=true })

vim.diagnostic.config({
  underline = false,
  float = { border = 'single' }
})

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'single' })
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = 'single' })

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', 'gy', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<leader>k', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', '<leader>a', vim.lsp.buf.code_action, opts)
  end,
})

local capabilities = require'cmp_nvim_lsp'.default_capabilities()

local lspconfig = require('lspconfig')
lspconfig.pylsp.setup {
  capabilities = capabilities,
  settings = {
    pylsp = {
      plugins = {
        ["black"] = {
          enabled = true,
        },
      },
    },
  },
}
lspconfig.clangd.setup { capabilities = capabilities, }
lspconfig.vhdl_ls.setup { capabilities = capabilities, }
-- lspconfig.metals.setup { capabilities = capabilities, }
lspconfig.zls.setup {
  capabilities = capabilities,
  cmd = { '/home/mattias/src/github.com/zls/zig-out/bin/zls' },
}
lspconfig.nimls.setup { capabilities = capabilities, }
lspconfig.rust_analyzer.setup {
  capabilities = capabilities,
  settings = {
    ["rust-analyzer"] = {
      checkOnSave = { allTargets = false },
      assist = {
        importGranularity = "item",
      },
    },
  },
}
-- }}}

-- nvim-cmp {{{
local luasnip = require'luasnip'

-- https://github.com/L3MON4D3/LuaSnip/issues/525
luasnip.config.setup({
  region_check_events = "CursorHold,InsertLeave,InsertEnter",
  delete_check_events = "TextChanged,InsertEnter",
})

local cmp = require'cmp'
cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  preselect = cmp.PreselectMode.None,
  mapping = cmp.mapping.preset.insert({
    ['<CR>'] = cmp.mapping.confirm({ select = false, }),
    ['<Tab>'] = cmp.mapping(function(fallback)
      if luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'path' },
  }, {
    { name = 'buffer' },
  }),
})
-- }}}

-- Telescope {{{
local telescope = require'telescope'
telescope.setup({
  defaults = {
    mappings = {
      i = {
        ["<ESC>"] = 'close',
      },
    },
  },
  pickers = {
    buffers = {
      mappings = {
        i = {
          ["<Del>"] = "delete_buffer",
        },
      },
    },
  },
  extensions = {
    fzf_native = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = 'smart_case',
    }
  }
})

telescope.load_extension('fzf')

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>f', builtin.find_files, {})
vim.keymap.set('n', '<leader>b', builtin.buffers, {})
vim.keymap.set('n', '<leader>s', builtin.lsp_document_symbols, {})
vim.keymap.set('n', '<leader>S', builtin.lsp_workspace_symbols, {})
vim.keymap.set('n', '<leader>d', function() return builtin.diagnostics({bufnr=0}) end)
vim.keymap.set('n', '<leader>D', builtin.diagnostics, {})
vim.keymap.set('n', 'gr', builtin.lsp_references, {})
-- }}}

-- Treesitter {{{
require'nvim-treesitter.configs'.setup {
  ensure_installed = { "c", "rust" },

  highlight = {
    enable = true,
    -- enable = false,
    additional_vim_regex_highlighting = false,
  },
}
-- }}}

-- leap.nvim {{{
require'leap'.create_default_mappings()
-- }}}
