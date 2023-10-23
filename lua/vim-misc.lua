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

local trouble = require("trouble.providers.telescope")

local telescope = require("telescope")

telescope.setup {
  defaults = {
    mappings = {
      i = { ["<c-t>"] = trouble.open_with_trouble },
      n = { ["<c-t>"] = trouble.open_with_trouble },
    },
  },
}

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
-- Completion
---------------------------------------------------------------------
local cmp = require'cmp'
local lspkind = require('lspkind')
local d = { behavior = cmp.SelectBehavior.Select }
local mapping = {
    ['<C-k>'] = cmp.mapping.select_prev_item(d),
    ['<C-p>'] = cmp.mapping.select_prev_item(d),
    ['<C-j>'] = {
        i = function()
            if cmp.visible() then
                cmp.select_next_item(d)
            else cmp.complete()
            end
        end,
    },
    ['<C-n>'] = cmp.mapping.select_next_item(d),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<C-l>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    }),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Insert,
      select = false,
    }),
  }
cmp.setup({
   snippet = { expand = function() end },
   experimental = {
       native_menu = false,
   },
  mapping = mapping,
  sources = {
    { name = 'nvim_lsp' },
    { name = 'path' },
    { name = 'buffer', keyword_length = 5, max_item_count = 5 },
    { name = 'nvim_lua', max_item_count = 5 },
  },
  formatting = {
    format = function(entry, vim_item)
      vim_item.kind = lspkind.presets.default[vim_item.kind] .. ' ' .. vim_item.kind
      vim_item.menu = ({
        buffer = '[Buffer]',
        nvim_lsp = '[LSP]',
        nvim_lua = '[Lua]',
        path = '[Path]',
        cmdline = '[Cmd]',
      })[entry.source.name]
      return vim_item
    end,
  },
})
cmp.setup.cmdline(':', {
  mapping = mapping,
  sources = cmp.config.sources({
    { name = 'path' },
    { name = 'cmdline' },
  })
})
cmp.setup.cmdline({'/','?'}, {
  mapping = mapping,
  sources = cmp.config.sources({
    { name = 'buffer' },
  })
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

---------------------------------------------------------------------
-- Trouble
---------------------------------------------------------------------

vim.keymap.set("n", "<leader>xx", function() require("trouble").toggle() end)
vim.keymap.set("n", "<leader>xw", function() require("trouble").toggle("workspace_diagnostics") end)
vim.keymap.set("n", "<leader>xd", function() require("trouble").toggle("document_diagnostics") end)
vim.keymap.set("n", "<leader>xq", function() require("trouble").toggle("quickfix") end)
vim.keymap.set("n", "<leader>xl", function() require("trouble").toggle("loclist") end)
vim.keymap.set("n", "gR", function() require("trouble").toggle("lsp_references") end)

---------------------------------------------------------------------
-- Debugging DAP keybindings
---------------------------------------------------------------------

vim.keymap.set("n", "<leader>dc", function() require("dap").continue() end)
vim.keymap.set("n", "<leader>dn", function() require("dap").step_over() end)
vim.keymap.set("n", "<leader>di", function() require("dap").step_into() end)
vim.keymap.set("n", "<leader>do", function() require("dap").step_out() end)
vim.keymap.set("n", "<leader>db", function() require("dap").toggle_breakpoint() end)
vim.keymap.set("n", "<leader>B", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end)
vim.keymap.set("n", "<leader>dl", function() require("dap").set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end)
vim.keymap.set("n", "<leader>dr", function() require("dap").repl.open() end)
vim.keymap.set("n", "<leader>dk", function() require("dap").run_last() end)

