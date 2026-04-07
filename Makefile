COMPOSE = docker compose -f srcs/docker-compose.yml

all:
	@mkdir -p /home/artperez/data/mariadb
	@mkdir -p /home/artperez/data/wordpress
	@docker compose -f srcs/docker-compose.yml up -d --build

clean:
	@docker compose -f srcs/docker-compose.yml down -v

fclean: clean
	@docker system prune -af
	@sudo rm -rf /home/artperez/data/mariadb/*
	@sudo rm -rf /home/artperez/data/wordpress/*

re: fclean all

logs_mariadb:
	@$(COMPOSE) logs mariadb

logs_wordpress:
	@$(COMPOSE) logs wordpress

logs_nginx:
	@$(COMPOSE) logs nginx

status:
	@$(COMPOSE) ps

.PHONY: all clean fclean re logs_mariadb logs_wordpress logs_nginx
