.DEFAULT: build

BINARY=run
SHARED_BIN=shared.so

VERSION=0.0.1
BUILD=`date +%FT%T%z`
GIT_HASH=`git rev-parse HEAD`

LDFLAGS=-ldflags "-X main.Version=${VERSION} -X main.Build=${BUILD} -X main.GitHash=${GIT_HASH}"

.PHONY: build
build:
	docker run --rm -w /go/src/app -v ${PWD}:/go/src/app golang:alpine go build ${LDFLAGS} -o ${BINARY} main.go

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
