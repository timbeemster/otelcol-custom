FROM golang:1.23.2 AS build
ARG  OTEL_VERSION=0.109.0
WORKDIR /app
COPY otel-builder-config.yml /etc/otel-builder-config.yml
RUN go install go.opentelemetry.io/collector/cmd/builder@v${OTEL_VERSION}
RUN CGO_ENABLED=0 builder --config=/etc/otel-builder-config.yml

FROM gcr.io/distroless/cc-debian12
USER nonroot

COPY otel-collector-config.yml /etc/otel-collector-config.yml
COPY --from=build /app/bin/otelcol-custom /

CMD ["/otelcol-custom", "--config=/etc/otel-collector-config.yml" ]
