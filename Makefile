PACKAGES=$(shell go list ./... | grep -v '/simulation')

VERSION := $(shell echo $(shell git describe --tags --always) | sed 's/^v//')
COMMIT := $(shell git log -1 --format='%H')
COSMOS_SDK := $(shell grep -i cosmos-sdk go.mod | awk '{print $$2}')
TEST_DOCKER_REPO=saisunkari19/ff-hub

build_tags := $(strip netgo $(build_tags))

ldflags = -X github.com/cosmos/cosmos-sdk/version.Name=FreeFlix \
	-X github.com/cosmos/cosmos-sdk/version.ServerName=ffd \
	-X github.com/cosmos/cosmos-sdk/version.ClientName=ffcli \
	-X github.com/cosmos/cosmos-sdk/version.Version=$(VERSION) \
	-X github.com/cosmos/cosmos-sdk/version.Commit=$(COMMIT) \
	-X "github.com/cosmos/cosmos-sdk/version.BuildTags=$(build_tags),cosmos-sdk $(COSMOS_SDK)"

BUILD_FLAGS := -ldflags '$(ldflags)'

all: go.sum install

create-wallet:
	ffcli keys add validator

init:
	rm -rf ~/.ffd
	ffd init freeflix-media-hub  --chain-id freeflix-media-hub --stake-denom ffmt
	ffd add-genesis-account $(shell ffcli keys show validator -a) 1000000000000ffmt,1000000000000mdm
	ffd gentx --name=validator --amount 100000000ffmt
	ffd collect-gentxs

install: go.sum
		go install  $(BUILD_FLAGS) ./cmd/ffd
		go install  $(BUILD_FLAGS) ./cmd/ffcli
build:
		go build $(BUILD_FLAGS) ./cmd/ffd
		go build $(BUILD_FLAGS)  ./cmd/ffcli

go.sum: go.mod
		@echo "--> Ensure dependencies have not been modified"
		GO111MODULE=on go mod verify

lint:
	@echo "--> Running linter"
	@golangci-lint run
	@go mod verify


docker-test:
	@docker build -f Dockerfile.test -t ${TEST_DOCKER_REPO}:$(shell git rev-parse --short HEAD) .
#	@docker tag ${TEST_DOCKER_REPO}:$(shell git rev-parse --short HEAD) ${TEST_DOCKER_REPO}:$(shell git rev-parse --abbrev-ref HEAD | sed 's#/#_#g')
#	@docker push ${TEST_DOCKER_REPO}:$(shell git rev-parse --short HEAD)
#	@docker push ${TEST_DOCKER_REPO}:$(shell git rev-parse --abbrev-ref HEAD | sed 's#/#_#g')

.PHONY: build install docker-test