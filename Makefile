run:
	@docker network create kind 2> /dev/null || echo ok; \
		docker run --rm\
		--network=kind\
		-ti --name kubernetes-in-docker\
		-v /var/run/docker.sock:/var/run/docker.sock\
		k8s-in-docker bash

build:
	@docker build -t k8s-in-docker .
