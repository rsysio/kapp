.DEFAULT: build

BINARY := run
SHARED_BIN := shared.so

APPLICATION := kapp
VERSION := 1.0.3
BUILD := $(shell date +%FT%T%z)
GIT_HASH := $(shell git rev-parse HEAD)
DOCKER_REG := rsysio

LDFLAGS=-ldflags "-X main.Version=${VERSION} -X main.Build=${BUILD} -X main.GitHash=${GIT_HASH}"

.PHONY: build
build:
	go build ${LDFLAGS} -o ${BINARY} main.go
	#docker run --rm -w /go/src/app -v ${PWD}:/go/src/app golang:alpine go build ${LDFLAGS} -o ${BINARY} main.go

.PHONY: build-shared
build-shared:
	go build ${LDFLAGS} -buildmode=c-shared -o ${SHARED_BIN} shared.go

.PHONY: glide-build
glide-build:
	docker build -t glide -f Dockerfile_glide .

.PHONY: glide-init
glide-init:
	docker run --rm -v ${PWD}:/go/src/app glide glide init

.PHONY: glide-install
glide-install:
	docker run --rm -v ${PWD}:/go/src/app glide:latest glide install

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
