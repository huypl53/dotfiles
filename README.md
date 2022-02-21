# Dotfiles for programming environment

## Neovim

- [nvim](./nvim): [jarvim](https://github.com/glepnir/jarvim)

```bash
sudo snap install universal-ctags
sudo apt install xclip
sudo apt install ripgrep
```
## Oh-my-zhs
chsh -s $(which zsh)
- [shell](./shell)

## Oh-my-tmux

- [tmux-plug](./tmux-plug)

## OH-my-zsh
### Nerd fonts
Download font https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Meslo.zip
```bash
sudo mkdir /usr/local/share/fonts/sample
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Meslo.zip
sudo unzip -q Meslo.zip -d /usr/local/share/fonts/sample/
```

### Themes
```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
ln -s `readlink -f ./shell/zsh/.zshrc` ~/
git clone https://github.com/agkozak/zsh-z $ZSH_CUSTOM/plugins/zsh-z
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
ln -s `readlink -f ./shell/zsh/powerlevel10k` ~/.oh-my-zsh/themes/
ln -s `readlink -f ./shell/zsh/.p10k.zsh` ~/
ln -s `readlink -f ./shell/zsh/.p10k-lean-8colors.zsh` ~/
```

## Easy tools
- ranger
- tldr

## GUI
```bash
mv ~/.config/gtk-3.0/gtk.css ~/.config/gtk-3.0/gtk.css.bak
ln -sf ./shell/gnome/.config/gtk-3.0/gtk.css ~/.config/gtk-3.0/

## Lvim
```
