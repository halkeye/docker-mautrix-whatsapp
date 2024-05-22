FROM curlimages/curl:8.8.0 AS builder
ENV WHATSAPP_VERSION=0.10.7
RUN arch=$(arch | sed s/aarch64/arm64/ | sed s/x86_64/amd64/) && curl -sL https://github.com/mautrix/whatsapp/releases/download/v${WHATSAPP_VERSION}/mautrix-whatsapp-${arch} > /tmp/mautrix-whatsapp
RUN chmod 0755 /tmp/mautrix-whatsapp

FROM debian:12.5-slim AS runtime
RUN apt-get update && apt-get install -y \
    ca-certificates=20230311 \
 && rm -rf /var/lib/apt/lists/*
COPY --from=builder /tmp/mautrix-whatsapp /usr/bin/mautrix-whatsapp
ENTRYPOINT ["/usr/bin/mautrix-whatsapp"]
