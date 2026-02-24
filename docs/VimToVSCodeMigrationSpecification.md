# Specification: Vim to VS Code Migration Tool

## 1. Introduction

This document outlines the specification for a tool designed to facilitate the migration of Vim-specific keybindings and settings from a user's existing Vim configuration (`VimSettings_YWT/.vimrc` and `VimSettings_YWT/vim_shortcuts.md`) to VS Code. The primary goal is to enable a seamless transition for users accustomed to Vim's modal editing and shortcut ecosystem, allowing them to retain their muscle memory and productivity within the VS Code environment.

## 2. Tool Purpose

The tool will analyze a user's Vim configuration and propose equivalent or similar keybindings and settings for VS Code. It will prioritize using VS Code's native functionalities and settings, resorting to recommendations for commonly used VS Code extensions only when native capabilities are insufficient to replicate a specific Vim behavior.

## 3. Scope

The migration tool will focus on the following aspects of Vim configuration:

*   **Keybindings/Shortcuts**: Mapping Vim normal, visual, and insert mode commands to VS Code keybindings. This includes basic navigation, text manipulation, search, and more advanced features.
*   **Editor Settings**: Identifying and translating core Vim editor behaviors (e.g., auto-indentation, line numbering, search highlighting) to VS Code settings.
*   **Plugin Equivalents**: For functionalities typically provided by Vim plugins, the tool will suggest equivalent VS Code extensions or built-in features.

The primary source files for analysis are:
*   `VimSettings_YWT/.vimrc`
*   `VimSettings_YWT/vim_shortcuts.md`

## 4. Migration Strategy

The migration process will adhere to the following priority:

1.  **VS Code Built-in Features**: First, attempt to map Vim functionalities to existing VS Code keybindings, commands, and settings. This ensures the leanest possible configuration and avoids external dependencies where unnecessary.
2.  **VS Code Extensions (Recommended)**: If a Vim feature cannot be adequately replicated with built-in VS Code functionalities, the tool will suggest popular and well-maintained VS Code extensions that provide the desired behavior. The tool should provide clear instructions on how to install and configure these extensions.

## 5. Keybinding Categories and Examples

The tool should categorize Vim shortcuts and provide migration paths based on common use cases. Below are examples extracted from `VimSettings_YWT/vim_shortcuts.md` to illustrate the desired mapping:

### 5.1. Navigation and Jumps

| Vim Shortcut                      | Explanation                                              | Proposed VS Code Mapping (Built-in/Extension)                               | Notes                                                                           |
| :-------------------------------- | :------------------------------------------------------- | :-------------------------------------------------------------------------- | :------------------------------------------------------------------------------ |
| `gd`                              | Move to local declaration                                | VS Code: `Go to Definition` (often `F12` or `Ctrl+Click`)                  | Needs to be mapped to a custom keybinding if `gd` is desired.                  |
| `gD`                              | Move to global declaration                               | VS Code: `Go to Definition` (similar to `gd` but context-dependent)         | Same as `gd`, context might vary for global vs local.                          |
| `0`                               | Start of line                                            | VS Code: `Home` key                                                         | Already a standard VS Code keybinding.                                         |
| `<C-o>` / `<C-i>`                 | Go to older/newer position in jump list                  | VS Code: `Go Back` (`Alt+Left Arrow`) / `Go Forward` (`Alt+Right Arrow`)    | Needs custom keybinding for direct mapping.                                    |
| `[[` / `]]`                      | Move to beginning of previous/next section               | VS Code: Likely requires an extension or complex macro/multiple commands.     | Requires analysis of "section" context in VS Code.                             |
| `gt`                              | Move to the next tab                                     | VS Code: `Ctrl+PgDn` / `Ctrl+Tab`                                           | Custom keybinding for direct mapping.                                          |
| `gT`                              | Move to the previous tab                                 | VS Code: `Ctrl+PgUp` / `Ctrl+Shift+Tab`                                     | Custom keybinding for direct mapping.                                          |
| `#gt`                             | Move to tab number `#`                                   | VS Code: `Ctrl+<number>` (e.g., `Ctrl+1` for first tab)                     | Custom keybinding for direct mapping.                                          |
| `<C-]>`                           | Jump to definition                                       | VS Code: `F12` or `Ctrl+Click`                                              | Needs custom keybinding for direct mapping.                                    |
| `<C-t>`                           | Go back to last tag                                      | VS Code: `Go Back` (`Alt+Left Arrow`)                                       | Needs custom keybinding for direct mapping.                                    |

### 5.2. Text Manipulation and Insertion

| Vim Shortcut                      | Explanation                                                                 | Proposed VS Code Mapping (Built-in/Extension)                               | Notes                                                                           |
| :-------------------------------- | :-------------------------------------------------------------------------- | :-------------------------------------------------------------------------- | :------------------------------------------------------------------------------ |
| `<C-x><C-f>`                      | Auto-completion of path in insert mode                                      | VS Code: Built-in path completion or relevant extension (e.g., Path Intellisense) | If built-in is not sufficient, recommend an extension. User's example.       |
| `<C-x><C-l>`                      | Auto-completion of line                                                     | VS Code: Built-in line completion (often context-dependent)                   |                                                                                 |
| `Ctrl + n` / `Ctrl + p`           | Insert (auto-complete) match before the cursor during insert mode           | VS Code: Built-in IntelliSense (`Ctrl+Space`)                               | Needs custom keybinding to match `Ctrl+n`/`Ctrl+p` for navigation in completion list. |
| `{<CR>`                           | Auto-completes `}` and inserts newline, cursor between `{}`                 | VS Code: Snippets or extension for auto-pairing/auto-closing features.        | Requires intelligent text insertion.                                            |
| `{{`                              | Auto-completes `}` and places cursor between `{}`                           | VS Code: Snippets or extension for auto-pairing/auto-closing features.        |                                                                                 |
| `[`                               | Automatically inserts `[]` and places cursor inside when `[` is typed       | VS Code: Built-in auto-pairing or extension.                                  | Similar for `(`, `"`, `'`.                                                      |
| `<C-w>`                           | Delete word before cursor                                                   | VS Code: `Ctrl+Backspace` (Windows/Linux) / `Alt+Backspace` (macOS)         | Needs custom keybinding for `Ctrl+w` if desired.                               |
| `<C-u>`                           | Delete line before cursor                                                   | VS Code: `Ctrl+Shift+K` (delete line) or custom keybinding.                 | Vim's `<C-u>` is more nuanced (delete from cursor to beginning of line).       |
| `]p`                              | Paste under the current indentation level                                   | VS Code: `Shift+Alt+V` (paste and reindent) or custom extension.            | Requires smart paste functionality.                                             |
| `<C-r>0`                          | Insert contents of last yank                                                | VS Code: Not directly equivalent to Vim's registers; clipboard (`Ctrl+V`).    | Requires an extension like "Vim" for VS Code to manage registers.              |
| `<C-r>a`                          | Insert contents of register `a`                                             | VS Code: Not directly equivalent; see `<C-r>0`.                               | Requires an extension like "Vim" for VS Code to manage registers.              |
| `jj`                              | Leave insert mode                                                           | VS Code: Requires the "Vim" extension to enable `jj` for `Esc`.               | A common Vim emulator feature.                                                  |
| `v`                               | Start visual mode, mark lines, then do a command (like y-yank)              | VS Code: Built-in selection (Shift + Arrow keys) or "Vim" extension.        |                                                                                 |
| `V`                               | Start linewise visual mode                                                  | VS Code: Built-in line selection (Shift + Home/End, or triple click) or "Vim" extension. |                                                                                 |
| `o`                               | Move to other end of marked area                                            | VS Code: "Vim" extension feature for visual mode.                           |                                                                                 |
| `Ctrl + v`                        | Start visual block mode                                                     | VS Code: Built-in column selection (Shift + Alt + Arrow keys) or "Vim" extension. |                                                                                 |
| `O`                               | Move to other corner of block                                               | VS Code: "Vim" extension feature for visual block mode.                     |                                                                                 |
| `~`                               | Toggle case (Case => cASE)                                                  | VS Code: `Ctrl+Shift+U` (toggle case) or extensions.                        |                                                                                 |
| `gU` / `gu`                       | Uppercase / Lowercase                                                       | VS Code: `Ctrl+Shift+U` (uppercase/lowercase transform).                    | Needs custom keybinding for direct `gU`/`gu` commands.                         |
| `gUU` / `guu`                     | Uppercase/Lowercase current line                                            | VS Code: `Ctrl+Shift+U` (uppercase/lowercase transform).                    | Needs custom keybinding for direct `gUU`/`guu` commands.                       |

### 5.3. Window Management

| Vim Shortcut                      | Explanation                                   | Proposed VS Code Mapping (Built-in/Extension)                               | Notes                                                                           |
| :-------------------------------- | :-------------------------------------------- | :-------------------------------------------------------------------------- | :------------------------------------------------------------------------------ |
| `<C-w>=`                          | Resize all windows to equal size              | VS Code: `View: Reset Editor Group Sizes`                                   | Needs custom keybinding.                                                        |
| `C-w>J` / `C-w>K` / `C-w>H` / `C-w>L` | Move current window to above/below/left/right split | VS Code: `View: Move Editor into Group Above/Below/Left/Right`              | Needs custom keybinding.                                                        |
| `<C-w>+` / `<C-w>-`               | Increase/decrease current window height       | VS Code: `View: Increase Editor Width/Height` / `View: Decrease Editor Width/Height` | Needs custom keybinding.                                                        |
| `<C-w><` / `<C-w>>`               | Increase/decrease current window width        | VS Code: `View: Increase Editor Width/Height` / `View: Decrease Editor Width/Height` | Needs custom keybinding.                                                        |
| `<C-j>` / `<C-k>` / `<C-h>` / `<C-l>` | Move to and maximize split                  | VS Code: `View: Maximize Editor Group` or specific navigation commands.     | Requires a combination of commands or extension.                                |

### 5.4. Language Server Protocol (LSP) and Diagnostics

| Vim Shortcut                      | Explanation                                         | Proposed VS Code Mapping (Built-in/Extension)                               | Notes                                                                           |
| :-------------------------------- | :-------------------------------------------------- | :-------------------------------------------------------------------------- | :------------------------------------------------------------------------------ |
| `gs`                              | Performs a document symbol search via LSP           | VS Code: `Go to Symbol in File` (`Ctrl+Shift+O`)                            | Needs custom keybinding.                                                        |
| `gS`                              | Performs a workspace symbol search via LSP          | VS Code: `Go to Symbol in Workspace` (`Ctrl+T`)                             | Needs custom keybinding.                                                        |
| `gr`                              | Finds references via LSP                            | VS Code: `Find All References` (`Shift+F12`)                                | Needs custom keybinding.                                                        |
| `gi`                              | Finds implementations via LSP                       | VS Code: `Go to Implementation` (`Ctrl+F12` or `Ctrl+Alt+F12`)              | Needs custom keybinding.                                                        |
| `lgt`                             | Jumps to type definition via LSP                    | VS Code: `Go to Type Definition` (`Ctrl+F12` or `Ctrl+Shift+F12`)           | Needs custom keybinding.                                                        |
| `<leader>rn`                      | Initiates a rename via LSP                          | VS Code: `Rename Symbol` (`F2`)                                             | Needs custom keybinding.                                                        |
| `[g`                              | Navigates to previous diagnostic message via LSP    | VS Code: `Go to Previous Problem (Error, Warning, Info)` (`Shift+F8`)        | Needs custom keybinding.                                                        |
| `]g`                              | Navigates to next diagnostic message via LSP        | VS Code: `Go to Next Problem (Error, Warning, Info)` (`F8`)                 | Needs custom keybinding.                                                        |
| `K`                               | Shows hover information via LSP                     | VS Code: Built-in hover on mouse-over or `Ctrl+K Ctrl+I`                    | Needs custom keybinding.                                                        |
| `<c-f>`                           | Scrolls forward within LSP popups/windows           | VS Code: Page Down (`PgDn`) or custom keybinding.                           |                                                                                 |
| `<c-d>`                           | Scrolls backward within LSP popups/windows          | VS Code: Page Up (`PgUp`) or custom keybinding.                             |                                                                                 |

### 5.5. Other Features

| Vim Shortcut      | Explanation                                            | Proposed VS Code Mapping (Built-in/Extension)                       | Notes                                                               |
| :---------------- | :----------------------------------------------------- | :------------------------------------------------------------------ | :------------------------------------------------------------------ |
| `<leader>/`       | Turn off search highlighting                           | VS Code: `Remove Highlights` command (requires custom keybinding)     |                                                                     |
| `<F8>`            | Open tagbar                                            | VS Code: `Outline` view or extension for symbol navigation.         | Requires an extension to mimic `tagbar` functionality.              |
| `<leader>c`       | Save files and execute `.py`                           | VS Code: Combination of `workbench.action.files.save` and task runner/extension. | Requires a custom task or extension for "execute".                  |
| `<leader>cc`      | Opens a new Copilot Chat window.                       | VS Code: `Copilot Chat: Open Chat View`                             | This is specific to Copilot Chat.                                   |
| `<leader>a`       | Adds visual selection to the Copilot window.           | VS Code: `Copilot Chat: Accept inline suggestion` or other Copilot commands. | Specific to Copilot Chat.                                           |
| `[m` / `]m`      | Previous/Next method start                             | VS Code: `Go to Previous/Next Member` (requires custom keybinding). |                                                                     |
| `[M` / `]M`      | Previous/Next method end                               | VS Code: `Go to Previous/Next Member` (requires custom keybinding). |                                                                     |
| `z=`, `zg`, `zw`, `zu` | Spell check related commands                      | VS Code: Extensions like "Code Spell Checker" or similar.           | These are complex; recommend extensions.                            |
| `<C-r>=128/2`     | Calculate                                              | VS Code: Integrated Terminal + custom command or extension.         |                                                                     |

## 6. Output Format

The tool's output should be a clear, human-readable guide or a `.json` file suitable for direct import into VS Code's `keybindings.json` and `settings.json`. For suggestions requiring extensions, the output should list the extension ID and provide example `settings.json` entries.

## 7. User Interaction

The tool should ideally be interactive, allowing the user to confirm or modify proposed mappings. This could involve:

*   Displaying a diff of current VS Code settings vs. proposed changes.
*   Allowing selection of preferred alternatives for ambiguous Vim commands.
*   Providing options to install recommended extensions.

## 8. Development Considerations

*   **Idempotency**: Running the tool multiple times should produce the same result if the input Vim configuration and user choices remain constant.
*   **Reversibility**: The tool should ideally provide a way to revert changes made to VS Code settings.
*   **Extensibility**: The architecture should allow for easy addition of new Vim-to-VS Code mappings or rules as new features or extensions emerge.
*   **Error Handling**: Gracefully handle missing configuration files, malformed entries, or unmappable Vim commands.

## 9. Future Enhancements

*   Integration with `.vimrc` parsing for a more comprehensive analysis of Vim script settings.
*   Support for different VS Code profiles or workspaces.
*   More intelligent mapping of complex Vim macros or functions.
