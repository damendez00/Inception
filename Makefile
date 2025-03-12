COMPOSE_FILE = srcs/docker-compose.yml

all: up

up:
	@echo "Upping services with Docker Compose!"
	docker compose $(COMPOSE_FILE) up --file --detach --build

# stops and removes containers
down:
	@echo "Stopping services ..."
	docker compose $(COMPOSE_FILE) down

#does down and also stops and removes network
clean: down
	@echo "Stopping services ..."
	docker compose $(COMPOSE_FILE) down
	docker system prune --all

re: clean all

.PHONY: all up down clean re