DockerDNS
=========

The simplest ever Docker container providing name resolving of containers by their hostname.

In other words, containers can communicate with each other using their name/hostname within same network, but you cannot
do the same thing on your host machine. DockerDNS container exposes Docker internal DNS so you can resolve container IP
by its hostname from host machine as well.

Docker Usage Example
--------------------

```
docker run --name dockerdns --rm -d -v"/etc/resolv.conf:/tmp/resolv.conf" webevt/dockerdns
```

Docker Compose Usage Example
----------------------------

```
version: "2.3"

services:
    dockerdns:
        container_name: "dockerdns"
        hostname:       "dockerdns"
        image:          "webevt/dockerdns"
        volumes:
            - "/etc/resolv.conf:/tmp/resolv.conf"
```
