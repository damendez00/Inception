FROM alpine:3.20

# fetch latest versions of packages and install nginx and openssl
# ngnix is 
# openssl is ...
RUN apt-get update && apt-get install -y \
    nginx \
    openssl \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /etc/ngnix/ssl

# Generate SSL certs



# Override default config with custom one
COPY conf/nginx.conf /etc/nginx/ngnix.conf

EXPOSE 443

# Start ngnix in foreground
CMD ["ngnix", "-g", "daemon off;"]