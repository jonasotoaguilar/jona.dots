if status is-interactive
    if not functions -q fisher
        set -l fisher_init (curl -sL https://git.io/fisher)
        if test -n "$fisher_init"
            eval "$fisher_init"
        end
        fisher install jorgebucaran/fisher
    end
end
