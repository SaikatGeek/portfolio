# Static portfolio served by lightweight Nginx Alpine.
# No build step needed — just copy the static assets into the Nginx web root.
FROM nginx:1.27-alpine

# Replace default Nginx config with our hardened static-serving config.
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy site assets into the web root.
COPY index.html robots.txt sitemap.xml /usr/share/nginx/html/
COPY images/ /usr/share/nginx/html/images/

# Container exposes plain HTTP only — TLS is terminated upstream at the
# Cloudflare edge, and Traefik routes to this port internally.
EXPOSE 80

# Liveness check used by Docker + Traefik. /health is defined in nginx.conf.
HEALTHCHECK --interval=30s --timeout=5s --retries=3 \
  CMD wget -qO- http://localhost/health || exit 1

CMD ["nginx", "-g", "daemon off;"]
