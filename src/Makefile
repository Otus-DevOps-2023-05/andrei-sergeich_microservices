NAME     = DOCKER-3
USER_R   = cmero
MONGO_V  = 5.0
NET_NAME = reddit
VOL_NAME = reddit_db

all: pull build net_create vol_create run

pull:
	@printf "Скачивание образа MONGO...\n"
	@docker pull mongo:${MONGO_V}

build:
	@printf "Сборка локальных образов ${NAME}...\n"
	@docker build -t ${USER_R}/post:1.0 ./post-py
	@docker build -t ${USER_R}/comment:1.0 ./comment
	@docker build -t ${USER_R}/ui:1.0 ./ui

net_create:
	@printf "Создание сети ${NET_NAME}...\n"
	@docker network create ${NET_NAME}

vol_create:
	@printf "Создание тома ${NET_NAME}...\n"
	@docker volume create ${VOL_NAME}

run:
	@printf "Запуск всех контейнеров ${NAME}...\n"
	@docker run -d --network=${NET_NAME} --network-alias=post_db --network-alias=comment_db -v ${VOL_NAME}:/data/db mongo:${MONGO_V}
	@docker run -d --network=${NET_NAME} --network-alias=post ${USER_R}/post:1.0
	@docker run -d --network=${NET_NAME} --network-alias=comment ${USER_R}/comment:1.0
	@docker run -d --network=${NET_NAME} -p 9292:9292 ${USER_R}/ui:1.0

run_2:
	@printf "Запуск всех контейнеров ${NAME}...\n"
	@docker run -d --network=${NET_NAME} --network-alias=post_db2 --network-alias=comment_db2 mongo:${MONGO_V}
	@docker run -d --network=${NET_NAME} --network-alias=post2 -e POST_DATABASE_HOST=post_db2 ${USER_R}/post:1.0
	@docker run -d --network=${NET_NAME} --network-alias=comment2 -e COMMENT_DATABASE_HOST=comment_db2 ${USER_R}/comment:1.0
	@docker run -d --network=${NET_NAME} -p 9292:9292 -e POST_SERVICE_HOST=post2 -e COMMENT_SERVICE_HOST=comment2 ${USER_R}/ui:1.0

## останавливаем все контейнейры
stop:
	@docker stop $$(docker ps -aq) 2>/dev/null || echo "ERROR: docker stop"

## запускаем все контейнейры
start:
	@docker start $$(docker ps -aq) 2>/dev/null || echo "ERROR: docker start"

fclean:
	@printf "Полная очистка всех конфигураций ${NAME}...\n"
	@docker stop $$(docker ps -qa) 2>/dev/null && echo "SUCCESS: docker stop" || echo "ERROR: docker stop"
	@docker system prune --all --force --volumes 2>/dev/null && echo "SUCCESS: system prune" || echo "ERROR: system prune"
	@docker network prune --force 2>/dev/null && echo "SUCCESS: network prune" || echo "ERROR: network prune"
	@docker volume prune --force 2>/dev/null && echo "SUCCESS: volume prune" || echo "ERROR: volume prune"
	@docker volume rm $$(docker volume ls -q)  2>/dev/null && echo "SUCCESS: volume rm" || echo "ERROR: volume rm"

re:	fclean all

.PHONY: all pull build network run fclean re
