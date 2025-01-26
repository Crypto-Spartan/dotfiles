#
# ~/.bash_logout
#

if [[ -n "$SSH_AGENT_PID" || -n "$SSH_AUTH_SOCK" ]]; then
    eval "$(ssh-agent -k)"
fi
