WP_DATA = /home/gsmereka/data/wordpress
DB_DATA = /home/gsmereka/data/mariadb

# default target
all: up

# start the building process
# create the wordpress and mariadb data directories.
# start the containers in the background and leaves them running
up: build
	@sudo mkdir -p $(WP_DATA)
	@sudo mkdir -p $(DB_DATA)
	sudo docker-compose -f srcs/docker-compose.yml up -d

# stop the containers
down:
	sudo docker-compose -f srcs/docker-compose.yml down

# stop the containers
stop:
	sudo docker-compose -f srcs/docker-compose.yml stop

# start the containers
start:
	sudo docker-compose -f srcs/docker-compose.yml start

# build the containers
build:
	sudo docker-compose -f srcs/docker-compose.yml build

# clean the containers
# stop all running containers and remove them.
# remove all images, volumes and networks.
# remove the wordpress and mariadb data directories.
# the (|| true) is used to ignore the error if there are no containers running to prevent the make command from stopping.
clean:
	@sudo docker ps -qa | xargs -r sudo docker stop || true
	@sudo docker ps -qa | xargs -r sudo docker rm || true
	@sudo docker images -qa | xargs -r sudo docker rmi -f || true
	@sudo docker volume ls -q | xargs -r sudo docker volume rm || true
	@sudo docker network ls -q | grep -v -e bridge -e host -e none | xargs -r sudo docker network rm || true
	@sudo rm -rf $(WP_DATA) || true
	@sudo rm -rf $(DB_DATA) || true

# clean and start the containers
re: clean up

# prune the containers: execute the clean target and remove all containers, images, volumes and networks from the system.
prune: clean
	@sudo docker system prune -a --volumes -f
