FROM caddy:builder AS builder
RUN xcaddy build \
    --with github.com/caddy-dns/netcup \
    --with github.com/corazawaf/coraza-caddy/v2 \
    --with github.com/mholt/caddy-ratelimit \
    --with github.com/greenpau/caddy-security \
    --with github.com/porech/caddy-maxmind-geolocation
# Step 2: Create a Minimal Runtime Image
FROM caddy:latest
# Copy the built Caddy binary
COPY --from=builder /usr/bin/caddy /usr/bin/caddy
# Verify that the binary is executable
RUN chmod +x /usr/bin/caddy
ENTRYPOINT ["/usr/bin/caddy"]
CMD ["run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile"]
