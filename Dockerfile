FROM golang:1.24-alpine AS build
ARG TARGETARCH
ARG RELEASE
ENV GOPATH=/go CGO_ENABLED=0
WORKDIR /build
RUN apk add -U --no-cache ca-certificates curl bash && \
    go install aead.dev/minisign/cmd/minisign@v0.2.1

# minio
RUN curl -s https://dl.min.io/server/minio/release/linux-${TARGETARCH}/archive/minio.${RELEASE} -o /go/bin/minio && \
    curl -s https://dl.min.io/server/minio/release/linux-${TARGETARCH}/archive/minio.${RELEASE}.minisig -o /go/bin/minio.minisig && \
    curl -s https://dl.min.io/server/minio/release/linux-${TARGETARCH}/archive/minio.${RELEASE}.sha256sum -o /go/bin/minio.sha256sum && \
    chmod 0755 /go/bin/minio

# mc
RUN curl -s https://dl.min.io/client/mc/release/linux-${TARGETARCH}/mc -o /go/bin/mc && \
    curl -s https://dl.min.io/client/mc/release/linux-${TARGETARCH}/mc.minisig -o /go/bin/mc.minisig && \
    curl -s https://dl.min.io/client/mc/release/linux-${TARGETARCH}/mc.sha256sum -o /go/bin/mc.sha256sum && \
    chmod 0755 /go/bin/mc

# firmas
RUN minisign -Vqm /go/bin/minio -x /go/bin/minio.minisig -P RWTx5Zr1tiHQLwG9keckT0c45M3AGeHD6IvimQHpyRywVWGbP1aVSGav && \
    minisign -Vqm /go/bin/mc    -x /go/bin/mc.minisig    -P RWTx5Zr1tiHQLwG9keckT0c45M3AGeHD6IvimQHpyRywVWGbP1aVSGav
RUN awk '{print $1"  /go/bin/minio"}' /go/bin/minio.sha256sum | sha256sum -c - && \
    awk '{print $1"  /go/bin/mc"}'    /go/bin/mc.sha256sum    | sha256sum -c -

# curl para healthcheck
RUN cp /usr/bin/curl /go/bin/curl

FROM registry.access.redhat.com/ubi9/ubi-micro:latest
ARG RELEASE
ENV MINIO_UPDATE_MINISIGN_PUBKEY="RWTx5Zr1tiHQLwG9keckT0c45M3AGeHD6IvimQHpyRywVWGbP1aVSGav" \
    MC_CONFIG_DIR=/tmp/.mc \
    MINIO_CONSOLE_ADDRESS=":9001"
COPY --from=build /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=build /go/bin/minio /usr/bin/minio
COPY --from=build /go/bin/mc    /usr/bin/mc
COPY --from=build /go/bin/curl  /usr/bin/curl
RUN chown root:root /usr/bin/minio /usr/bin/mc /usr/bin/curl && chmod 0755 /usr/bin/minio /usr/bin/mc /usr/bin/curl
VOLUME ["/data"]
ENTRYPOINT ["/usr/bin/minio"]

