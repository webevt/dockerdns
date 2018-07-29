#!/bin/sh

container_ip=${CONTAINER_IP:-$(hostname -i)}
dockerdns_mark="# added by dockerdns"
resolvconf_file="/tmp/resolv.conf"

echo $(cat "${resolvconf_file}" | grep -v "${dockerdns_mark}") > "${resolvconf_file}"
old_contents=$(cat "${resolvconf_file}")
echo -e "nameserver ${container_ip} ${dockerdns_mark}\n${old_contents}" > ${resolvconf_file}
