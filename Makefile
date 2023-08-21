VERSION := $(shell cat .version)
PWD := $(shell pwd)
BUILD_DIR = $(PWD)/dist
PROG := milter-framework-admin

DOCKER_PLATFORM := linux/amd64
DOCKER_REGISTRY := 
DOCKER_TAG := $(DOCKER_REGISTRY)/$(PROG):$(VERSION)

.PHONY: all version build clean install docker

docker:
	docker build --build-arg "APP_VERSION=$(VERSION)" --platform "$(DOCKER_PLATFORM)" --tag "$(DOCKER_TAG)" .
	docker push "$(DOCKER_TAG)"

version:
	@echo "$(VERSION)"

clean:
	@echo "Not implemented yet"

