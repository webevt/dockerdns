FROM alpine:3.7

EXPOSE 53

RUN apk add --no-cache socat

COPY scripts/create-resolvconf.sh ./create-resolvconf.sh
RUN chmod +x ./create-resolvconf.sh

CMD ./create-resolvconf.sh && \
    socat -T15 udp4-recvfrom:53,reuseaddr,fork udp:127.0.0.11:53
