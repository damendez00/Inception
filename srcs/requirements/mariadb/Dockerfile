FROM debian:12.0

RUN apt-get update && apt-get install -y \
    mariadb-server \
    mariadb-client \
    net-tools \
    procps \
    && rm -rf /var/lib/apt/lists/*

# Configure MariaDB to listen on all interfaces
RUN echo "[mysqld]\nbind-address = 0.0.0.0\nport = 3306\n" > /etc/mysql/mariadb.conf.d/50-server.cnf

# Create necessary directories
RUN mkdir -p /var/run/mysqld && \
    chown -R mysql:mysql /var/run/mysqld /var/lib/mysql

# Copy initialization script
COPY tools/script.sh /script.sh
COPY tools/init.sql /init.sql

# Initialize the database
RUN chmod +x /script.sh && \
    mysql_install_db --user=mysql --datadir=/var/lib/mysql && \
    chown -R mysql:mysql /var/lib/mysql

# Expose MariaDB port
EXPOSE 3306

# Run script in container when it starts
CMD ["bash", "/script.sh"]