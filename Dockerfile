FROM curlimages/curl:8.8.0 AS builder
ARG TARGETPLATFORM
ARG WHATSAPP_VERSION=0.10.7
RUN DOCKER_ARCH=$(case ${TARGETPLATFORM:-linux/amd64} in \
    "linux/amd64")   echo "amd64"  ;; \
    "linux/arm/v7")  echo "arm64"   ;; \
    "linux/arm64")   echo "arm64" ;; \
    *)               echo ""        ;; esac) \
  && echo "DOCKER_ARCH=$DOCKER_ARCH" \
  && curl -sL https://github.com/mautrix/whatsapp/releases/download/v${WHATSAPP_VERSION}/mautrix-whatsapp-${DOCKER_ARCH} > /tmp/mautrix-whatsapp
RUN chmod 0755 /tmp/mautrix-whatsapp

FROM debian:12.5-slim AS runtime
RUN apt-get update && apt-get install -y \
    ca-certificates=20230311 \
    gettext-base=0.21-12 \
 && rm -rf /var/lib/apt/lists/*
COPY --from=builder /tmp/mautrix-whatsapp /usr/bin/mautrix-whatsapp
USER 1337
ENTRYPOINT ["/usr/bin/mautrix-whatsapp"]
