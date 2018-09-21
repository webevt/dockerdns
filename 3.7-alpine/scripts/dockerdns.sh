#!/bin/sh

resolvconf_file="/tmp/resolv.conf";
dockerdns_mark="# added by dockerdns";

function cleanup () {
    while cat "${resolvconf_file}" | grep -q "${dockerdns_mark}"; do
        echo -e "/${dockerdns_mark}/d\nw" | ed "${resolvconf_file}" > /dev/null;
    done
}

function update_resolvconf () {
    local container_ip=${CONTAINER_IP:-$(hostname -i)};

    # Remove rows with dockerdns mark.
    cleanup || \
        echo "Failed to cleanup ${resolvconf_file}" 1>&2;

    # Prepend row with dockerdns mark.
    echo -e "0a\nnameserver ${container_ip} ${dockerdns_mark}\n.\n,\nw" | ed "${resolvconf_file}" > /dev/null;

    echo "[$(date)] ${resolvconf_file} is updated";
}

trap 'cleanup; exit 0' SIGTERM EXIT;

update_resolvconf;

# It is assumed that container restarts when inotify event occurs. This is done so because we cannot be sure that
# resolv.conf is still properly mounted, because it can be broken when file is moved or deleted.
while inotifywait -qq -emodify -edelete_self -emove_self -eunmount -eattrib "${resolvconf_file}"; do kill $$; done &

socat -T15 udp4-recvfrom:53,reuseaddr,fork udp:127.0.0.11:53 &

wait;
