# Multi-stage: official xray image has no shell, copy binary into Alpine
# Railway-ready version of the proven Cloady set (2026-11-06).
# Differences from Cloady: no UUID baked into the image (set it as a
# Railway variable instead, so it is not committed to the repo), and no
# hardcoded PORT — Railway injects $PORT at runtime; entrypoint.sh
# falls back to 3000 only if PORT is unset.
FROM ghcr.io/xtls/xray-core:latest AS xray
FROM alpine:latest
RUN apk add --no-cache ca-certificates
COPY --from=xray /usr/local/bin/xray /usr/local/bin/xray
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
