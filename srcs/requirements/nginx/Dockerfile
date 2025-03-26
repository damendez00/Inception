FROM debian:bullseye

# Update and install nginx and openssl
RUN apt-get update && apt-get install -y \
    nginx \
    openssl \
    && rm -rf /var/lib/apt/lists/*

# Create SSL certs directory
RUN mkdir -p /etc/nginx/ssl

# Generate SSL certificates
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/server.key \
    -out /etc/nginx/ssl/server.crt \
    -subj "/C=ES/ST=Madrid/L=Madrid/O=42/OU=42/CN=localhost"

# Copy nginx config
COPY conf/nginx.conf /etc/nginx/nginx.conf

EXPOSE 443

# Start nginx in foreground
CMD ["nginx", "-g", "daemon off;"]