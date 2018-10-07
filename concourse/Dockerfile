FROM alpine:latest

RUN apk --update --no-cache add curl jq

COPY scripts/check.sh /opt/resource/check
COPY scripts/in.sh /opt/resource/in
COPY scripts/out.sh /opt/resource/out
