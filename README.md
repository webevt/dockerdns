DockerDNS
=========

The simplest ever Docker container providing name resolving of containers by their hostname.

In other words, containers can communicate with each other using their name/hostname within same network, but you cannot
do the same thing on your host machine. DockerDNS container exposes Docker internal DNS so you can resolve container IP
by its hostname from host machine as well.

Docker Usage Example
--------------------

```
docker run --name dockerdns -d -v"/etc/resolv.conf:/tmp/resolv.conf" --restart=unless-stopped --dns=8.8.8.8 webevt/dockerdns:3.7-alpine
```

Docker Compose Usage Example
----------------------------

```
version: "2.3"

services:
    dockerdns:
        container_name: "dockerdns"
        hostname:       "dockerdns"
        image:          "webevt/dockerdns:3.7-alpine"
        volumes:
            - "/etc/resolv.conf:/tmp/resolv.conf"
        # Restarts container if a change occurs in resolv.conf.
        restart: unless-stopped
        # Internal DNS server address which must be used by container to avoid recursive connections, because docker
        # uses DNS server addresses from host machine by default.
        dns: 8.8.8.8
```
