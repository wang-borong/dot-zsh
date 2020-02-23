# If lantern is installed, use its proxy in terminal
if (( $+commands[lantern] )); then
    function proxy() {
        if [[ $1 == "on" ]]; then
            local proxy=$(lsof -i -P -n | grep LISTEN | grep lantern | sed -n 2p | awk '{print $9}')
            local proxy_ip=$(echo $proxy | awk -F':' '{print $1}')
            local proxy_port=$(echo $proxy | awk -F':' '{print $2}')

            export http_proxy="$proxy" \
                https_proxy="$proxy" \
                ftp_proxy="$proxy" \
                rsync_proxy="$proxy"

            export JAVA_OPTS="$JAVA_OPTS -Dhttp.proxyHost=$proxy_ip -Dhttp.proxyPort=$proxy_port"
        elif [[ $1 == "off" ]]; then
            unset http_proxy https_proxy ftp_proxy rsync_proxy JAVA_OPTS
        else
            print "Usage: proxy [on|off]"
        fi
    }
fi
