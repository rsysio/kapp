.DEFAULT: build

APPLICATION := kapp
BINARY ?= $(APPLICATION)
SHARED_BIN := shared.so
VERSION := 1.0.3
BUILD := $(shell date +%FT%T%z)
GIT_HASH := $(shell git rev-parse HEAD)
DOCKER_REG := rsysio

LDFLAGS=-ldflags "-X main.Version=${VERSION} -X main.Build=${BUILD} -X main.GitHash=${GIT_HASH}"

.PHONY: build
build:
	go build ${LDFLAGS} -o ${BINARY} main.go

.PHONY: build-shared
build-shared:
	go build ${LDFLAGS} -buildmode=c-shared -o ${SHARED_BIN} shared.go

.PHONY: clean
clean:
	go clean

.PHONY: run
run:
	go run main.go

.PHONY: artefact
artefact: build
	docker build -t $(DOCKER_REG)/$(APPLICATION):$(VERSION) .
	docker push $(DOCKER_REG)/$(APPLICATION):$(VERSION)
