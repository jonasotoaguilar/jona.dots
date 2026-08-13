# -----------------------------------------------------
# LOCAL SECRETS
# -----------------------------------------------------

set -l local_secrets_file $HOME/.config/fish/local.secrets.fish

if test -f $local_secrets_file
    source $local_secrets_file
end
