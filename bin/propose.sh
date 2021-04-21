#!/bin/zsh

PROPOSE_HELP=$(cat <<HELP_MESSAGE
You can invoke various commands by specifying keywords.

help    -> this message
propose -> load proposer rc
HELP_MESSAGE
)

propose_load_home_rc(){
    local rc_file
    rc_file=.config/proposer/rc.sh

    if [ -f "$HOME/${rc_file}" ]; then
        source "$HOME/${rc_file}"
    fi
}
propose_load_rc(){
    local rc_file
    rc_file=.config/proposer/rc.sh

    if [ -n "$APP_ROOT" ]; then
        if [ -f "$APP_ROOT/${rc_file}" ]; then
            source "$APP_ROOT/${rc_file}"
        fi
    fi
    if [ -f "./.proposerrc" ]; then
        source "./.proposerrc"
    fi
}

propose_invoke(){
    local invoke_func
    invoke_func="propose_cmd_${BUFFER}"

    if [ "$(which "${invoke_func}")" != "${invoke_func} not found" ]; then
        ${invoke_func}
    fi
}

propose_cmd_help(){
    propose_zle_clear
    echo "${PROPOSE_HELP}"
}
propose_cmd_propose(){
    propose_zle_clear
    propose_load_rc
    echo "propose rc loaded."
}

propose_zle_register(){
    local key
    key="^j"

    zle -N propose_invoke
    bindkey "${key}" propose_invoke

    propose_load_home_rc

    echo "the Propose widget registered."
    echo "To invoke action, type ${key}."
}
propose_zle_clear(){
    BUFFER=
    zle redisplay
    echo
}
