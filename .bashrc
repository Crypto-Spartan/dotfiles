#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

PS1='[\u@\h \W]\$ '

# relative path links
ln -sf .dotfiles/.bash_logout
ln -sf .dotfiles/.bash_profile
ln -sf .dotfiles/.bashrc
ln -sf .dotfiles/.zsh_logout
ln -sf .dotfiles/.zshrc
# renamed
ln -sf .dotfiles/.gitattributes_global ./.gitattributes
ln -sf .dotfiles/.gitconfig_global ./.gitconfig

# full path links
ln -sf ~/.dotfiles/cargo_config.toml ~/.cargo/config.toml
ln -sf ~/.dotfiles/nvim ~/.config/
ln -sf ~/.dotfiles/.ssh_config ~/.ssh/config

for file in ~/.dotfiles/.{aliases,exports,}; do
    [ -r $file ] && [ -f $file ] && source $file;
done;
unset file;

exit_session() {
    . "$HOME/.bash_logout"
}
trap exit_session EXIT SIGHUP SIGINT SIGQUIT SIGABRT SIGKILL SIGALRM SIGTERM
eval "$(zoxide init bash)"
