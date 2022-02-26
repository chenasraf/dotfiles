# .dotfiles

1. Install [Oh-My-Zsh](https://github.com/ohmyzsh/ohmyzsh)
2. Clone this repository into `~/.dotfiles`:

   ```bash
   git clone git@github.com:chenasraf/dotfiles.git ~/.dotfiles
   ```

3. Replace entire contents of `~/.zshrc` with:

   ```bash
   source "$HOME/.dotfiles/.zshrc"
   ```

4. In a new terminal, run install scripts:

   ```bash
   home install
   home reload
   ```
