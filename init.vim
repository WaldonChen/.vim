set nocompatible | filetype indent plugin on | syn on | let mapleader=' '

fun! SetupVAM()
  let c = get(g:, 'vim_addon_manager', {})
  let g:vim_addon_manager = c
  let c.plugin_root_dir = expand('$HOME', 1) . '/.vim/vim-addons'

  " Force your ~/.vim/after directory to be last in &rtp always:
  " let g:vim_addon_manager.rtp_list_hook = 'vam#ForceUsersAfterDirectoriesToBeLast'

  " most used options you may want to use:
  " let c.log_to_buf = 1
  " let c.auto_install = 0
  let &rtp.=(empty(&rtp)?'':',').c.plugin_root_dir.'/vim-addon-manager'
  if !isdirectory(c.plugin_root_dir.'/vim-addon-manager/autoload')
    execute '!git clone --depth=1 git://github.com/MarcWeber/vim-addon-manager '
        \       shellescape(c.plugin_root_dir.'/vim-addon-manager', 1)
  endif

  " This provides the VAMActivate command, you could be passing plugin names, too
  call vam#ActivateAddons([], {})
endfun
call SetupVAM()

" ACTIVATING PLUGINS

" OPTION 1, use VAMActivate
" VAMActivate PLUGIN_NAME PLUGIN_NAME ..

" OPTION 2: use call vam#ActivateAddons
" call vam#ActivateAddons([PLUGIN_NAME], {})
" use <c-x><c-p> to complete plugin names

" OPTION 3: Create a file ~/.vim-scripts putting a PLUGIN_NAME into each line
" See lazy loading plugins section in README.md for details
" call vam#Scripts("~/.vim-scripts", {'tag_regex': '.*'})

call vam#ActivateAddons(['github:WaldonChen/vim-addon-WaldonChen'], {})

"-----------------------------------------------
" Basic plugins
"-----------------------------------------------
VAMActivate EasyMotion FastFold indentLine matchit.zip ShowTrailingWhitespace repeat surround
VAMActivate vim-airline
let g:airline_left_sep=''
let g:airline_right_sep=''

"-----------------------------------------------
" Enhanced plugins
"-----------------------------------------------
VAMActivate fugitive
VAMActivate Tabular
inoremap <silent> <Bar>  <Bar><Esc>:call <SID>align()<CR>a
" 绘制文本表格时，自动对齐
function! s:align()
  let p = '^\s*|\s.*\s|\s*$'
  if exists(':Tabularize') && getline('.') =~# '^\s*|' && (getline(line('.')-1) =~# p || getline(line('.')+1) =~# p)
    let column = strlen(substitute(getline('.')[0:col('.')],'[^|]','','g'))
    let position = strlen(matchstr(getline('.')[0:col('.')],'.*|\s*\zs.*'))
    Tabularize/|/l1
    normal! 0
    call search(repeat('[^|]*|',column).'\s\{-\}'.repeat('.',position),'ce',line('.'))
  endif
endfunction

" :Tab /=       按=对齐
" :Tab /:\zs    按:后的空格对齐
VAMActivate Tagbar
let g:tagbar_autoclose	= 1
let g:tagbar_compact	= 1
map <silent> tl :TagbarToggle<CR>

VAMActivate The_NERD_Commenter
let NERDSpaceDelims = 1

VAMActivate The_NERD_tree
" 从NERDTree中打开文件后关闭窗口
let g:NERDTreeQuitOnOpen = 1
nmap wm :NERDTreeToggle<CR>

VAMActivate xptemplate
let g:xptemplate_key="<M-/>"

VAMActivate vim-multiple-cursors
" disable deoplete when using vim-multiple-cursors
function g:Multiple_cursors_before()
    let g:deoplete#disable_auto_complete = 1
endfunction
function g:Multiple_cursors_after()
    let g:deoplete#disable_auto_complete = 0
endfunction
" Fix conflict with neocomplete
function! Multiple_cursors_before()
    if exists(':NeoCompleteLock') == 2
        exe 'NeoCompleteLock'
    endif
endfunction
function! Multiple_cursors_after()
    if exists(':NeoCompleteUnlock') == 2
        exe 'NeoCompleteUnlock'
    endif
endfunction

"-----------------------------------------------
" C/C++ development plugins
"-----------------------------------------------
VAMActivate DoxygenToolkit
VAMActivate github:Shougo/deoplete.nvim
let g:deoplete#enable_at_startup = 1
" see the typed word in the completion menu
call deoplete#custom#set('_', 'matchers', ['matcher_fuzzy'])
" prevent auto bracket completion
call deoplete#custom#set('_', 'converters', ['converter_remove_paren'])

VAMActivate Syntastic
let g:syntastic_ignore_files = [".*\.py$"]

VAMActivate vim-clang-format operator-user
let g:clang_format#style_options = {
            \ "AccessModifierOffset" : -2,
            \ "IndentWidth" : 4}
" map to <Leader>cf in C++ code
autocmd FileType c,cpp,objc nnoremap <buffer> <Leader>cf :<C-u>ClangFormat<CR>
autocmd FileType c,cpp,objc vnoremap <buffer> <Leader>cf :ClangFormat<CR>
" if you install vim-operator-user
autocmd FileType c,cpp,objc map <buffer> <Leader>x <Plug>(operator-clang-format)
" Toggle auto formatting:
nmap <Leader>C :ClangFormatAutoToggle<CR>

"-----------------------------------------------
" Python development plugins
"-----------------------------------------------
VAMActivate jedi-vim github:orenhe/pylint.vim
let g:jedi#goto_assignments_command = "<leader>g"
let g:jedi#goto_definitions_command = "<leader>d"
let g:jedi#documentation_command    = "K"
let g:jedi#usages_command           = "<leader>n"
let g:jedi#completions_command      = "<C-Space>"
let g:jedi#rename_command           = "<leader>r"
let g:jedi#show_call_signatures     = "1"
let g:jedi#popup_on_dot             = 0
let g:jedi#popup_select_first       = 0

"-----------------------------------------------
" Other plugins
"-----------------------------------------------
VAMActivate vim-pandoc github:vim-pandoc/vim-pandoc-syntax matrix%1189

finish
Vim is ignoring this text after finish.
