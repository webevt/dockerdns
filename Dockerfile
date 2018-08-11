FROM alpine:3.7

EXPOSE 53

RUN apk add --no-cache socat inotify-tools

COPY scripts/dockerdns.sh ./dockerdns.sh
RUN chmod +x ./dockerdns.sh

CMD ["./dockerdns.sh"]
