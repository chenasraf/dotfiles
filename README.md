# .dotfiles

## How to install

1. Install [Oh-My-Zsh](https://github.com/ohmyzsh/ohmyzsh)
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
   home reload
   ```

## TO DO

- [x] Make next template incremental (`yarn create next-app` + copy rest of tpl)
- [x] Make CRA template (same)
- [ ] Improve generic user store/api login flow in template
