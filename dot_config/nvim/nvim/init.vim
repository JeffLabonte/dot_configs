set rtp+=~/tree.nvim/
call plug#begin('~/.vim/plugged')

Plug 'junegunn/vim-easy-align'
Plug 'https://github.com/junegunn/vim-github-dashboard.git'
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }

Plug 'dense-analysis/ale', {'do': 'pip install \"python-lsp-server[all]\"'}

Plug 'tpope/vim-sensible'
Plug 'folke/tokyonight.nvim', { 'branch': 'main' }
Plug 'easymotion/vim-easymotion'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

Plug 'tpope/vim-fugitive'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/nvim-cmp'

Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }
Plug 'vim-test/vim-test'
call plug#end()

filetype plugin indent on
syntax on

set number
set laststatus=2
set t_Co=256
set t_ut=
set noshowmode

" sane editing
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set colorcolumn=80
set viminfo='25,\"50,n~/.viminfo
set tw=160
set autoindent
set smartindent

colorscheme tokyonight

map <Space> <Leader>

" Using Lua functions
nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>

nnoremap <leader>ec <cmd>:e ~/.config/nvim/init.vim<cr>
nnoremap <Tab> <cmd>:bnext<cr>
nnoremap <S-Tab> <cmd>:bprevious<cr>

" s{char}{char} to move to {char}{char}
nmap s <Plug>(easymotion-overwin-f2

" Move to line
map <Leader>L <Plug>(easymotion-bd-jk)
nmap <Leader>L <Plug>(easymotion-overwin-line)

" Move to word
map  <Leader>w <Plug>(easymotion-bd-w)
nmap <Leader>w <Plug>(easymotion-overwin-w)

nmap <Leader>t :terminal<CR>

" Hightlight on yank
" From https://neovim.io/news/2021/07
au TextYankPost * lua vim.highlight.on_yank {higroup="IncSearch", timeout=150, on_visual=true}

let g:ale_completion_enabled = 1
set omnifunc=ale#completion#OmniFunc

if executable('pyls')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'pyls',
        \ 'cmd': {server_info->['pyls']},
        \ 'whitelist': ['python'],
        \ })
endif


set completeopt=menu,menuone,noselect

lua <<EOF
  -- Setup nvim-cmp.
  local cmp = require'cmp'

  cmp.setup({
    snippet = {
      expand = function(args)
        -- For `vsnip` user.
        vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` user.

        -- For `luasnip` user.
        -- require('luasnip').lsp_expand(args.body)

        -- For `ultisnips` user.
        -- vim.fn["UltiSnips#Anon"](args.body)
      end,
    },
    mapping = {
      ['<C-d>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.close(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
    },
    sources = {
      { name = 'nvim_lsp' },

      -- For vsnip user.
      { name = 'vsnip' },

      -- For luasnip user.
      -- { name = 'luasnip' },

      -- For ultisnips user.
      -- { name = 'ultisnips' },

      { name = 'buffer' },
    }
  })

  -- Setup lspconfig.
  require('lspconfig')["pyright"].setup {
    capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
  }
EOF


lua <<EOF
    vim.o.termguicolors = true
    vim.api.nvim_set_keymap('n', '<Space>z',
        ":<C-u>Tree -columns=mark:indent:git:icon:filename:size:time"..
        " -split=vertical -direction=topleft -winwidth=40 -listed `expand('%:p:h')`<CR>",
        {noremap=true, silent=true})
    local custom = require 'tree/custom'
    custom.option('_', {root_marker='[in]:'})
    custom.column('filename', {
      root_marker_highlight='Ignore',
      max_width=60,
    })
    custom.column('time', {
      format="%d-%M-%Y",
    })
    custom.column('mark', {
      readonly_icon="X",
      selected_icon="*",
    })
    local tree = require('tree')
    -- keymap(keys, action1, action2, ...)  action can be `vim action` or `tree action`
    tree.keymap('cp', 'copy')
    tree.keymap('m', 'move')
    tree.keymap('p', 'paste')
    tree.keymap('a', 'view')
    tree.keymap('o', 'open_or_close_tree')
    tree.keymap('R', 'open_tree_recursive')
    tree.keymap('r', 'rename')
    tree.keymap('x', 'execute_system')
    tree.keymap('<CR>', 'drop')
    tree.keymap('<C-l>', 'redraw')
    tree.keymap('<C-g>', 'print')
    tree.keymap('>', 'toggle_ignored_files')
    tree.keymap('*', 'toggle_select_all')
    tree.keymap('s', {'drop', 'split'}, 'quit')
    tree.keymap('N', 'new_file')
    tree.keymap('cd', {'cd', '.'})
    tree.keymap('~', 'cd')
    tree.keymap('<Tab>', 'toggle_select', 'j')  -- tree action and vim action
    tree.keymap('\\', {'cd', vim.fn.getcwd})
    tree.keymap('cD', {'call', function(context) print(vim.inspect(context)) end})
    tree.keymap('l', 'open')
    tree.keymap('yy', 'yank_path')
    tree.keymap('D', 'debug')
    tree.keymap('d', 'remove')
    tree.keymap('E', {'open', 'vsplit'})
    tree.keymap('h', {'cd', '..'})
    tree.keymap('gk', {'goto', 'parent'})
EOF

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'


nmap <silent> t<C-n> :TestNearest<CR>
nmap <silent> t<C-f> :TestFile<CR>
nmap <silent> t<C-s> :TestSuite<CR>
nmap <silent> t<C-l> :TestLast<CR>
nmap <silent> t<C-g> :TestVisit<CR>
