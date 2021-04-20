#!/bin/sh

export PROPOSE_HELP=$(cat <<HELP_MESSAGE
You can invoke various commands by specifying keywords.

h | help        -> this message
q | quit | exit -> exit
HELP_MESSAGE
)

propose_main(){
    local pwd_dir
    local keyword

    propose_pwd_dir

    echo "(load Proposer scripts...)"
    echo
    propose_load_rc

    echo "This is the Proposer's environment."
    echo "You can invoke various commands by typing keywords."
    echo
    echo "To show help message, type '?', 'h' or 'help'."
    echo

    trap : INT
    while [ true ]; do
        read -p "${pwd_dir} > " keyword

        if [ -z "${keyword}" ]; then
            continue
        fi

        case "${keyword}" in
            \?|h|help)
                propose_help
                ;;
            q|quit|exit)
                break
                ;;
            *)
                propose_invoke
                ;;
        esac
    done
}

propose_pwd_dir(){
    if [ -n "$APP_ROOT" ]; then
        pwd_dir=$(basename $APP_ROOT)
    else
        pwd_dir=$(basename $(pwd))
    fi
}

propose_load_rc(){
    local rc_file
    rc_file=.config/proposer/rc.sh

    if [ -f "$HOME/${rc_file}" ]; then
        source "$HOME/${rc_file}"
    fi
    if [ -n "$APP_ROOT" ]; then
        if [ -f "$APP_ROOT/${rc_file}" ]; then
            source "$APP_ROOT/${rc_file}"
        fi
    fi
    if [ -f "./${rc_file}" ]; then
        source "./${rc_file}"
    fi
}
propose_help(){
    echo "${PROPOSE_HELP}"
    echo
}

propose_invoke(){
    local invoke_func
    invoke_func="propose_cmd_${keyword}"

    if [ "$(type -t "${invoke_func}")" = "function" ]; then
        ${invoke_func}
    else
        echo "invoke function '${invoke_func}' is not defined."
    fi

    echo
}
propose_read_and_run(){
    local cmd
    read -p "$1 > " cmd
    sh -c "$1" -- "${cmd}"
}

propose_cmd_hello(){
    propose_read_and_run 'echo $1'
}

propose_main
