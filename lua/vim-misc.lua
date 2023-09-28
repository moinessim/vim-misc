-- Set leader key
vim.g.mapleader = ' '
vim.o.number = true
vim.o.relativenumber = true

-- Yanks go on clipboard
vim.opt.clipboard = 'unnamedplus'

-- Cd into directory of current buffer
vim.keymap.set('n', '<leader>cd','%:p:h<CR>:pwd<CR>', {} )

-- Clear highlighted search
vim.keymap.set('n', '<C-N>', ':nohlsearch<CR>', {} )

-- vifm plugin keybindings
vim.keymap.set('n', '<leader>s', ':SplitVifm<CR>', {} )
vim.keymap.set('n', '<leader>v', ':VsplitVifm<CR>', {} )
vim.keymap.set('n', '<leader>d', ':DiffVifm<CR>', {} )


-- Terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-N>', {})

-- Escape from terminal into buffer
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-N>', {})

-- Split terminal
vim.keymap.set('n', '<leader>t', ':sp | :term<CR>', {})

require("toggleterm").setup{open_mapping = [[<space>']]}

-- Configure keybindings for Telescope

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

-- Git keybindings

vim.keymap.set('n', '<leader>gs', ':G<CR>', {})
vim.keymap.set('n', '<leader>gp', ':G push<CR>', {})
vim.keymap.set('n', '<leader>gpF', ':G push --force<CR>', {})
vim.keymap.set('n', '<leader>gf', ':G fetch<CR>', {})
vim.keymap.set('n', '<leader>gP', ':G pull<CR>', {})


-- Use only a single global status line. When using this, make sure to
-- also set WinSeparator in your color theme so that the splits aren't
-- chonky.
vim.opt.laststatus = 3

--[[
-- Notes:
--
-- When updating TreeSitter, you'll want to update the parsers using
-- :TSUpdate manually. Or, you can call :TSInstall to install new parsers.
-- Run :checkhealth nvim_treesitter to see what parsers are setup.
--]]
---------------------------------------------------------------------
-- LSP Clients
---------------------------------------------------------------------


-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<space>k', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<space>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})


---------------------------------------------------------------------
-- Treesitter
---------------------------------------------------------------------
require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
  },
}

---------------------------------------------------------------------
-- Comment.nvim
---------------------------------------------------------------------
require('Comment').setup()
