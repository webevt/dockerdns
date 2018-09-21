#!/bin/sh

resolvconf_file="${RESOLVCONF:-/tmp/resolv.conf}";
dockerdns_mark="# added by dockerdns";

function cleanup () {
    while cat "${resolvconf_file}" | grep -q "${dockerdns_mark}"; do
        echo -e "/${dockerdns_mark}/d\nw" | ed "${resolvconf_file}" > /dev/null;
    done
echo
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
while inotifywait -qq -emodify "${resolvconf_file}"; do update_resolvconf; done &

socat -T15 udp4-recvfrom:53,reuseaddr,fork udp:127.0.0.11:53 &

wait;
