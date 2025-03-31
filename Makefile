COMPOSE_FILE = srcs/docker-compose.yml
ENV_FILE = srcs/.env
include $(ENV_FILE)
export $(shell sed 's/=.*//' $(ENV_FILE))

all: up

up:
	@echo "🚀 Upping services with Docker Compose!"
	docker compose -f $(COMPOSE_FILE) up -d --build

down:
	@echo "🛑 Stopping services ..."
	docker compose -f $(COMPOSE_FILE) down

clean: down
	@echo "🧹 Cleaning volumes and networks..."
	docker compose -f $(COMPOSE_FILE) down -v
	docker system prune -af
	rm -rf /c/Users/David/Desktop/data/*

re: clean all

# Restart services without losing data
restart:
	@echo "🔄 Restarting services..."
	docker compose -f $(COMPOSE_FILE) down
	docker compose -f $(COMPOSE_FILE) up -d --build

nginx:
	docker compose -f $(COMPOSE_FILE) up -d --build nginx

mariadb:
	docker compose -f $(COMPOSE_FILE) up -d --build mariadb

wordpress:
	docker compose -f $(COMPOSE_FILE) up -d --build wordpress

# Logs
logs:
	docker compose -f $(COMPOSE_FILE) logs -f

nginx-logs:
	docker compose -f $(COMPOSE_FILE) logs -f nginx

mariadb-logs:
	docker compose -f $(COMPOSE_FILE) logs -f mariadb

wordpress-logs:
	docker compose -f $(COMPOSE_FILE) logs -f wordpress

# Access to containers
mariadb-bash:
	docker compose -f $(COMPOSE_FILE) exec mariadb bash

nginx-bash:
	docker compose -f $(COMPOSE_FILE) exec nginx sh

wordpress-bash:
	docker compose -f $(COMPOSE_FILE) exec wordpress bash

# Show tables in mariadb
mariadb-show-tables:
	docker compose -f $(COMPOSE_FILE) exec mariadb mysql -u $(MYSQL_USER) -p$(MYSQL_PASSWORD) $(MYSQL_DATABASE) -e "SHOW TABLES;"

mariadb-show-databases:
	docker compose -f $(COMPOSE_FILE) exec mariadb mysql -u $(MYSQL_USER) -p$(MYSQL_PASSWORD) -e "SHOW DATABASES;"

.PHONY: all up down clean re logs mariadb-bash nginx-bash wordpress-bash