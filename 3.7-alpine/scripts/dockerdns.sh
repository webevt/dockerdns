#!/bin/sh

resolvconf_file="${RESOLVCONF:-/tmp/resolv.conf}"

function update_resolvconf () {
    local container_ip=${CONTAINER_IP:-$(hostname -i)}
    local dockerdns_mark="# added by dockerdns"

    # Remove row with dockerdns mark.
    echo $(cat "${resolvconf_file}" | grep -v "${dockerdns_mark}") > "${resolvconf_file}"

    # Prepend row with dockerdns mark.
    echo -e "nameserver ${container_ip} ${dockerdns_mark}\n$(cat "${resolvconf_file}")" > ${resolvconf_file}

    echo "[$(date)] ${resolvconf_file} is updated"
}

trap 'exit 0' SIGTERM

update_resolvconf
while inotifywait -qq -emodify "${resolvconf_file}"; do update_resolvconf; done &

socat -T15 udp4-recvfrom:53,reuseaddr,fork udp:127.0.0.11:53 &

wait
