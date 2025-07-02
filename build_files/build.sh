#!/bin/bash

set -ouex pipefail

### Install packages
dnf5 install -y --setopt=install_weak_deps=0 cloud-init 

# Create /etc/caddy directory and copy Caddyfile
mkdir -p /etc/caddy
cp /ctx/Caddyfile /etc/caddy/Caddyfile

# Copy web content to /usr/share for the base image
mkdir -p /usr/share/caddy/web
cp -r /ctx/web/* /usr/share/caddy/web/

# Create tmpfiles.d configuration to set up /var directories at runtime
cat > /usr/lib/tmpfiles.d/caddy.conf << 'EOF'
# Create Caddy directories at runtime
d /var/log/caddy 0755 root root -
d /var/caddy-data 0755 root root -
d /var/caddy-config 0755 root root -

# Copy web content from /usr/share to /var at runtime
d /var/www 0755 root root -
C /var/www/index.html 0644 root root - /usr/share/caddy/web/index.html
C /var/www/fedora-logo.png 0644 root root - /usr/share/caddy/web/fedora-logo.png
C /var/www/caddy-logo.svg 0644 root root - /usr/share/caddy/web/caddy-logo.svg
C /var/www/README.md 0644 root root - /usr/share/caddy/web/README.md
EOF
