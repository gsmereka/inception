WP_DATA = /home/gsmereka/data/wordpress
DB_DATA = /home/gsmereka/data/mariadb

all: makedir host up 

host:
	sudo echo "127.0.0.1 gsmereka.42.fr" | sudo tee -a /etc/hosts

makedir:
	@sudo mkdir -p $(WP_DATA)
	@sudo mkdir -p $(DB_DATA)

up: build
	sudo docker compose -f srcs/docker-compose.yml up -d

down:
	sudo docker compose -f srcs/docker-compose.yml down

stop:
	sudo docker compose -f srcs/docker-compose.yml stop

start:
	sudo docker compose -f srcs/docker-compose.yml start

build:
	sudo docker compose -f srcs/docker-compose.yml build

clean:
	@sudo docker ps -qa | xargs -r sudo docker stop || true
	@sudo docker ps -qa | xargs -r sudo docker rm || true
	@sudo docker images -qa | xargs -r sudo docker rmi -f || true
	@sudo docker volume ls -q | xargs -r sudo docker volume rm || true
	@sudo docker network ls -q | grep -v -e bridge -e host -e none | xargs -r sudo docker network rm || true
	@sudo rm -rf $(WP_DATA) || true
	@sudo rm -rf $(DB_DATA) || true

re: clean up

prune: clean
	@sudo docker system prune -a --volumes -f host
