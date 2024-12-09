FROM alpine:latest
RUN apk add --no-cache curl bash \
    && curl https://get.helm.sh/helm-v3.10.0-linux-amd64.tar.gz | tar xzv \
    && mv linux-amd64/helm /usr/local/bin/helm \
    && rm -rf linux-amd64
ENTRYPOINT ["helm"]
