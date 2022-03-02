" Moving lines using vscode style
nnoremap [B :m .+1<CR>==
nnoremap [A :m .-2<CR>==
inoremap [B <Esc>:m .+1<CR>==gi
inoremap [A <Esc>:m .-2<CR>==gi
vnoremap [B :m '>+1<CR>gv=gv
vnoremap [A :m '<-2<CR>gv=gv


" Turn on color syntax and allow custom Git commit message messages 
syntax on

" Spell check git commit messages and wrap text at column 72 
autocmd Filetype gitcommit setlocal spell textwidth=72

" In Git commit messages, also colour the 51st column (for titles)
autocmd FileType gitcommit set colorcolumn+=51
autocmd FileType gitcommit set colorcolumn+=73

" Capital W also saves
command! W  write

