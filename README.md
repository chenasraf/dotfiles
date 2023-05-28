# .dotfiles

## How to install

1. Install zsh
2. Clone this repository into `~/.dotfiles`:

   ```bash
   git clone git@github.com:chenasraf/dotfiles.git ~/.dotfiles
   ```

3. Replace entire contents of `~/.zshrc` to the new version using (`ln -s` does **not** work):

   ```bash
   echo 'source "$HOME/.dotfiles/.zshrc"' > ~/.zshrc
   ```

4. In a new terminal, run install scripts:

   ```bash
   home install
   home reload-terminal
   ```
