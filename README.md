# .dotfiles

1. Install [Oh-My-Zsh](https://github.com/ohmyzsh/ohmyzsh)
2. Clone this repository into `~/.dotfiles`:

   ```bash
   git clone git@github.com:chenasraf/dotfiles.git ~/.dotfiles
   ```

3. Install plugins:
   1. [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions/blob/master/INSTALL.md#oh-my-zsh)
   2. [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/INSTALL.md#oh-my-zsh)
4. Install fzf:

   ```bash
   brew install fzf
   ```

5. Replace entire contents of `~/.zshrc` with:

   ```bash
   source "$HOME/.dotfiles/.zshrc"
   ```

6. Reload zsh:

   ```bash
   source ~/.zshrc
   ```
