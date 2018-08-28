function log_ts() {
    while read -r line; do
        now="$(date '+%F %T')"

        echo "[$now] $line"
    done
}

function log_prefix() {
    while read -r line; do
        prefix="$1"
        [ -t 1 ] && prefix=$(printf "\e[33m$1\e[0m")

        echo "$prefix| $line"
    done
}

function checkpid() {
    ps | cut -d" " -f1 | grep $(printf "%d" $1)
}

function waitpid() {
    wait_on_pid=$1
    message="$2"
    prefix="$3"
    done_msg="$4"
    start_seconds=$SECONDS


    [ -z "$done_msg" ] && done_msg="done"
    [ -t 1 ] && done_msg="$(printf "\e[32m$done_msg\e[0m")"

    exec 3>&2
    exec 2>/dev/null

    printf "[$prefix...] $message"
    trap exit SIGINT

    sample_line="$(printf "[%s%3s] %s" "$prefix" "${spinner[$i]}" "$message")"
    linelen=$((${#sample_line} + 10))

    i=0
    spinner=('   ' '•  ' '•• ' '•••')
    #spinner=('   ' '.  ' '.. ' '...')
    while [ ! -z $(checkpid $wait_on_pid) ]; do
        if [ -t 1 ]; then
            printf "\r[%s\e[33m%3s\e[0m]($(($SECONDS-$start_seconds))s) %s" "$prefix" "${spinner[$i]}" "$message"
            i=$(($i+1))
            i=$(($i % ${#spinner[@]}))
            sleep 0.33
        fi
    done

    trap - SIGINT

    [ -t 1 ] && printf "\r%${linelen}s\r" || printf "\n"
    printf "[%s]($(($SECONDS-$start_seconds))s) %s\n" "$done_msg" "$message"

    exec 2>&3

}
