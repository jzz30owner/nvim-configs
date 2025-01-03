require("plugins")
vim.api.nvim_create_autocmd({'BufEnter','BufAdd','BufNew','BufNewFile','BufWinEnter'}, {
    group = vim.api.nvim_create_augroup('TS_FOLD_WORKAROUND', {}),
    callback = function()
    end
  })

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.softtabstop = 2
vim.wo.number = true
  
vim.api.nvim_exec([[tnoremap <Esc> <C-\><C-n>]], false)
vim.api.nvim_set_keymap("n", "<C-j>", ":m .+1<CR>==", { noremap = true})
vim.api.nvim_set_keymap("n", "<C-k>", ":m .-2<CR>==", { noremap = true})
vim.api.nvim_set_keymap("n", "<C-d>", ":co .<CR>==", { noremap = true})

require('gitsigns').setup {
  signs = {
    add          = { text = '│' },
    change       = { text = '│' },
    delete       = { text = '_' },
    topdelete    = { text = '‾' },
    changedelete = { text = '~' },
    untracked    = { text = '┆' },
  },
  signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
  numhl      = false, -- Toggle with `:Gitsigns toggle_numhl`
  linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
  word_diff  = false, -- Toggle with `:Gitsigns toggle_word_diff`
  watch_gitdir = {
    follow_files = true
  },
  attach_to_untracked = true,
  current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
    delay = 1000,
    ignore_whitespace = false,
    virt_text_priority = 100,
  },
  current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
  sign_priority = 6,
  update_debounce = 100,
  status_formatter = nil, -- Use default
  max_file_length = 40000, -- Disable if file is longer than this (in lines)
  preview_config = {
    -- Options passed to nvim_open_win
    border = 'single',
    style = 'minimal',
    relative = 'cursor',
    row = 0,
    col = 1
  },

}


-- VSCODE themr
require('vscode').load('dark')


-- Cland(lsp)
require('lspconfig').clangd.setup {
  cmd = {'clangd-18', '--background-index', '--compile-commands-dir', ''},
  init_options = {
      clangdFileStatus = true,
      clangdSemanticHighlighting = true,
  },
  filetypes = {'c', 'cpp', 'cxx', 'cc'},
  root_dir = function() return vim.fn.getcwd() end,
  settings = {
      ['clangd'] = {
          ['compilationDatabasePath'] = 'build',
          ['fallbackFlags'] = {'-std=c++20'}
      }
  }
}

-- Python (pylsp) configuration
require('lspconfig').pylsp.setup {
  settings = {
    pylsp = {
      plugins = {
        pyflakes = { enabled = true },
        pylint = { enabled = false },
        pycodestyle = { enabled = true },
        black = { enabled = true },
        pylsp_mypy = { enabled = true },
        isort = { enabled = true },
      },
    },
  },
  root_dir = function() return vim.fn.getcwd() end,
}

-- Rust (rust-analyzer) configuration
require('lspconfig').rust_analyzer.setup {
  cmd = { "rust-analyzer" },
  filetypes = { "rust" },
  root_dir = require('lspconfig.util').root_pattern("Cargo.toml"),
  settings = {
    ["rust-analyzer"] = {
      assist = {
        importGranularity = "module",
        importPrefix = "by_self",
      },
      cargo = {
        allFeatures = true,
      },
      procMacro = {
        enable = true,
      },
    },
  },
}

-- nvim-cmp configuration
local cmp = require('cmp')
cmp.setup({
  sources = {
    { name = 'nvim_lsp' },
    { name = 'nvim_lsp_signature_help' },
    { name = 'buffer' },
    { name = 'path' },
  },
  mapping = {
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  },
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body) -- LuaSnip for snippets
    end,
  },
})

-- Treesitter setup for better highlighting
require('nvim-treesitter.configs').setup {
  ensure_installed = { "python", "rust" }, -- Install required parsers
  highlight = {
    enable = true, -- Enable treesitter-based syntax highlighting
    additional_vim_regex_highlighting = false,
  },
  disable = { "c", "cpp" },
  indent = {
    enable = true, -- Use treesitter for better indentation
    disable = { "c", "cpp" }, -- Disable indentation for C and C++
  },
}