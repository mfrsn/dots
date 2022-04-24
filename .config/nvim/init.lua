--
-- Appearance
--

vim.opt.termguicolors = true
vim.opt.background = 'dark'
vim.g['gruvbox_bold'] = 0
vim.cmd('colorscheme gruvbox')

--
-- Options
--

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
vim.opt.cmdheight = 1
vim.opt.updatetime = 300
vim.opt.shortmess:append({ c = true })
vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }
vim.opt.signcolumn = 'number'

--
-- Keybindings
--

vim.g.mapleader = ' '
vim.keymap.set('i', 'jk', '<Esc>')
vim.keymap.set('n', '<leader>ev', ':edit $MYVIMRC<CR>')
vim.keymap.set('n', '<leader>sv', ':source $MYVIMRC<CR>')
vim.keymap.set('n', '<leader>p', ':bp<CR>', { silent=true })
vim.keymap.set('n', '<leader>n', ':bn<CR>', { silent=true })
vim.keymap.set('n', '<leader>d', ':bp <BAR> bd #<CR>', { silent=true })

vim.keymap.set({'n', 'v'}, '<leader>=', ':Tabularize /=<CR>')
vim.keymap.set({'n', 'v'}, '<leader>&', ':Tabularize /&<CR>')

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

--
-- Filetype Settings
--

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
  pattern = 'c,cpp',
  group = ftaugroup,
  callback = function()
    vim.opt_local.commentstring = '// %s'
    vim.opt_local.comments:prepend(':///')
    vim.opt_local.formatoptions = { c = true, q = true, r = true, j = true }
    vim.opt_local.cinoptions = { 'g0', ':0', 'l1', '(0', 'Ws' }
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
    vim.opt_local.commentstring = '// %s'
    vim.opt_local.comments:append({ ':--', 'b:--' })
    vim.opt_local.formatoptions = { c = true, q = true, r = true, j = true }
    vim.keymap.set({ 'n', 'v' }, '<leader>:', ':Tabularize /:<CR>', { buffer = true })
    vim.keymap.set({ 'n', 'v' }, '<leader>>', ':Tabularize /=><CR>', { buffer = true })
    vim.keymap.set({ 'n', 'v' }, '<leader><', ':Tabularize /<=<CR>', { buffer = true })
  end
})

-- Misc Options
vim.g['vhdl_indent_genportmap'] = false
vim.g['c_no_curly_error'] = true

--
-- Nvim LSP
--

vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { silent=true })
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { silent=true })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { silent=true })

local on_attach = function(_, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  local opts = { buffer = bufnr, silent = true }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
  -- vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
  -- vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
end

local lspconfig = require'lspconfig'

local capabilities = require'cmp_nvim_lsp'.update_capabilities(vim.lsp.protocol.make_client_capabilities())

local servers = {}
servers.rust_analyzer = {}
servers.ccls = {}
servers.pylsp = {}

local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, 'lua/?.lua')
table.insert(runtime_path, 'lua/?/init.lua')
servers.sumneko_lua = {
  Lua = {
    runtime = { version = 'LuaJIT', path = runtime_path, },
    diagnostics = { globals = { 'vim' }, },
    workspace = { library = vim.api.nvim_get_runtime_file("", true), },
    telemetry = { enable = false, },
  },
}

for lsp, settings in pairs(servers) do
  lspconfig[lsp].setup({
    on_attach = on_attach,
    capabilities = capabilities,
    settings = settings,
  })
end

--
-- nvim-cmp autocompletion
--

local cmp = require'cmp'

cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["UltiSnips#Anon"](args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<CR>'] = cmp.mapping.confirm({ select = false }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'ultisnips' },
  }, {
    { name = 'buffer' },
    { name = 'path' },
  })
})

--
-- Telescope
--

local telescope = require'telescope'
telescope.setup({
  defaults = {
    mappings = {
      i = {
        ["<ESC>"] = 'close',
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

vim.keymap.set('n', '<leader>f', function() return require'telescope.builtin'.find_files() end)
vim.keymap.set('n', '<leader>b', function() return require'telescope.builtin'.buffers() end)
vim.keymap.set('n', '<leader>g', function() return require'telescope.builtin'.live_grep() end)
vim.keymap.set('n', '<leader>t', function() return require'telescope.builtin'.lsp_document_symbols() end)
vim.keymap.set('n', '<leader>ca', function() return require'telescope.builtin'.lsp_code_actions() end)
vim.keymap.set('n', 'gr', function() return require'telescope.builtin'.lsp_references() end)
