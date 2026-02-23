| shortcut                          | explanation                                                                                                                       |
|-----------------------------------|-----------------------------------------------------------------------------------------------------------------------------------|
| gd                                | move to local declaration                                                                                                         |
| gD                                | move to global declaration                                                                                                        |
| 0                                 | Start of line                                                                                                                     |
| <C-o>————<C-i>                    | go to older position in jump list ———— go to newer position in jump list                                                          |
| [( ; [{ ; [< ————]) ; ]} ; ]>     | Previous ( or { or < ————— Next ) or } or >                                                                                       |
| [[ ————]]                         | move to the beginning of the previous section ———— move to the beginning of the next section                                      |
| zo ; zc ; zR ————zO ; zC ; zM     | Open single sub level/recurrent sub level/entire file folder ———— Close single sub level/recurrent sub level/entire file  folder  |
| ]s ; [s                           | Move to next/previous misspelled word after the cursor                                                                            |
| [m ; ]m ———— [M ; ]M              | Previous/Next method start ————— Previous/Next method end                                                                         |
| <C-r>0                            | insert the contents of last time yank                                                                                             |
| <C-r>a                            | insert the contents of register a                                                                                                 |
| <C-x><C-f>                        | Auto-completion of path in insert mode                                                                                            |
| <C-x><C-l>                        | Auto-completion of line                                                                                                           |
| Ctrl + n ; Ctrl + p               | insert (auto-complete) Ctrl + p match before the cursor during insert mode                                                        |
| {<CR>                             | 自動補齊}並將}換行，然後將遊標插入{}之間                                                                                          |
| {{                                | 自動補齊}並將遊標插入{}之間                                                                                                       |
| [                                 | Automatically inserts [] and places the cursor inside when [ is typed in insert mode.                                             |
| (                                 | Automatically inserts () and places the cursor inside when ( is typed in insert mode.                                             |
| "                                 | Automatically inserts "" and places the cursor inside when " is typed in insert mode.                                             |
| '                                 | Automatically inserts '' and places the cursor inside when ' is typed in insert mode.                                             |
| <C-w>                             | delete word before cursor                                                                                                         |
| <C-u>                             | delete line before cursor                                                                                                         |
| ]p 〔command mode〕               | Paste under the current indentation level                                                                                         |
| <C-r>=128/2                       | Calculate— Shows the result of the division : ‘64’                                                                                |
| jj                                | leave insert mode                                                                                                                 |
| gt                                | move to the next tab                                                                                                              |
| gT                                | move to the previous tab                                                                                                          |
| #gt                               | move to tab number #                                                                                                              |
| <C-w>=                            | resize all window to equal size                                                                                                   |
| C-w>J ; <C-w>K ; <C-w>H ; <C-w>L  | move current window to the above/below/left/right split                                                                           |
| <C-w>+ ; <C-w>- ; <C-w>< ; <C-w>> | Increase/decrease current window height/width                                                                                     |
| <C-j> ; <C-k> ; <C-h> ; <C-l>     | move to and maximize the above/below/left/right split                                                                             |
| v                                 | start visual mode, mark lines, then do a command (like y-yank)                                                                    |
| V                                 | start linewise visual mode                                                                                                        |
| o                                 | move to other end of marked area                                                                                                  |
| Ctrl + v                          | start visual block mode                                                                                                           |
| O                                 | move to other corner of block                                                                                                     |
| ]s ; [s                           | Move to next/previous misspelled word after the cursor                                                                            |
| z=                                | Suggest spellings for the word under/after the cursor                                                                             |
| zg                                | Add word to spell list                                                                                                            |
| zw                                | Mark word as bad/mispelling                                                                                                       |
| zu / C-X (Insert Mode)            | Suggest words for bad word under cursor from spellfile                                                                            |
| ~                                 | Toggle case (Case => cASE)                                                                                                        |
| gU                                | Uppercase                                                                                                                         |
| gu                                | Lowercase                                                                                                                         |
| gUU                               | Uppercase current line (also gUgU)                                                                                                |
| guu                               | Lowercase current line (also gugu)                                                                                                |
| <leader>/                         | turn off search highlighting                                                                                                      |
| <F8>                              | open tagbar                                                                                                                       |
| <leader>d                         | Echoes the JSON path (for JSON files).                                                                                            |
| <leader>c                         | save files and execute .py                                                                                                        |
| <leader>g                         | Goes to the JSON path (for JSON files).                                                                                           |
| <C-]>                             | Jump to definition                                                                                                                |
| g]                                | See all definitions                                                                                                               |
| <C-t>                             | Go back to last tag                                                                                                               |
| <leader>cc                        | Opens a new Copilot Chat window.                                                                                                  |
| <leader>a                         | Adds visual selection to the Copilot window.                                                                                      |
| gs                                | Performs a document symbol serach via LSP                                                                                         |
| gS                                | Performs a workspace symbol search via LSP.                                                                                       |
| gr                                | Finds references via LSP.                                                                                                         |
| gi                                | Finds implementations via LSP.                                                                                                    |
| lgt                               | Jumps to type definition via LSP.                                                                                                 |
| <leader>rn                        | Initiates a rename via LSP.                                                                                                       |
| [g                                | Navigates to the previous diagnostic message via LSP.                                                                             |
| ]g                                | Navigates to the next diagnostic message via LSP.                                                                                 |
| K                                 | Shows hover information via LSP.                                                                                                  |
| <c-f>                             | Scrolls forward within LSP popups/windows.                                                                                        |
| <c-d>                             | Scrolls backward within LSP popups/windows.                                                                                       |
