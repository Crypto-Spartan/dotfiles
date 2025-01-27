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
ln -sf .dotfiles/.gitattributes_global ./.gitattributes
ln -sf .dotfiles/.gitconfig_global ./.gitconfig

# full path links
ln -sf ~/.dotfiles/cargo_config.toml ./.cargo/config.toml
ln -sf ~/.dotfiles/nvim ./.config/
ln -sf ~/.dotfiles/ssh_config ./.ssh/config

for file in ~/.dotfiles/.{aliases,exports,}; do
    [ -r $file ] && [ -f $file ] && source $file;
done;
unset file;

if [ ! -S ~/.ssh/ssh_auth_sock ]; then
    eval $(ssh-agent -t 30m -s)
    ln -sf "$SSH_AUTH_SOCK" ~/.ssh/ssh_auth_sock
fi
export SSH_AUTH_SOCK=~/.ssh/ssh_auth_sock
export SSH_AGENT_PID="$(pgrep ssh-agent)"

exit_session() {
    . "$HOME/.bash_logout"
}
trap exit_session EXIT
trap exit_session SIGHUP

eval "$(zoxide init bash)"
