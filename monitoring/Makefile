NAME           = MONITORING-HW
USER_NAME      = cmero
VM_NAME        = docker-host
VM_SSH_USER    = yc-user
VM_IP_ADDRESS  = ${shell yc compute instance show --name ${VM_NAME} | grep -E ' +address' | tail -n 1 | awk '{print $$2}'}
SSH_P_KEY_PATH = ${shell find ~/.ssh/ -name id_ed25519.pub}
SSH_KEY_PATH   = ${shell find ~/.ssh/ -name id_ed25519}
MACHINE_CHECKOUT = eval $$(docker-machine env ${VM_NAME})

all: infra_create env_init build run

infra_create:
	@printf "Создание инфраструктуры в облаке...\n"
	@yc compute instance create \
		--name ${VM_NAME} \
		--zone ru-central1-a \
		--network-interface subnet-name=default-ru-central1-a,nat-ip-version=ipv4 \
		--create-boot-disk image-folder-id=standard-images,image-family=ubuntu-1804-lts,size=15 \
		--ssh-key ${SSH_P_KEY_PATH}

env_init:
	@printf "Создание docker-machine...\n"
	@docker-machine create \
		--driver generic \
		--generic-ip-address=${VM_IP_ADDRESS} \
		--generic-ssh-user ${VM_SSH_USER} \
		--generic-ssh-key ${SSH_KEY_PATH} \
		${VM_NAME}

build:
	@printf "Сборка локальных образов ${NAME}...\n"
	@${MACHINE_CHECKOUT} && \
		docker build -t ${USER_NAME}/prometheus ./prometheus && \
		export USER_NAME=${USER_NAME} && \
		cd ../src/ui && bash docker_build.sh && \
		cd ../post-py && bash docker_build.sh && \
		cd ../comment && bash docker_build.sh

run:
	@printf "Запуск сервисов ${NAME}...\n"
	@${MACHINE_CHECKOUT} && docker-compose -f ../docker/docker-compose.yml up -d

push:
	@printf "Отправка образов в DockerHub...\n"
	@${MACHINE_CHECKOUT} && \
		export USER_NAME=${USER_NAME} && \
		docker push ${USER_NAME}/ui && \
		docker push ${USER_NAME}/comment && \
		docker push ${USER_NAME}/post && \
		docker push ${USER_NAME}/prometheus

clean:
	@printf "Остановка и удаление сервисов ${NAME}...\n"
	@${MACHINE_CHECKOUT} && docker-compose -f ../docker/docker-compose.yml down

fclean:
	@printf "Полная очистка всех конфигураций ${NAME}...\n"
	@docker-machine rm -y ${VM_NAME} 2>/dev/null && echo "SUCCESS: docker-machine removed" || echo "ERROR: docker-machine removed"
	@yc compute instance delete ${VM_NAME} 2>/dev/null && echo "SUCCESS: yc compute instance deleted" || echo "ERROR: yc compute instance deleted"

re:	fclean all

.PHONY: all infra_create env_init build run push clean fclean re
