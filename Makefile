export PROJECT_NAME = $(shell basename $(shell go list -m))
export IMG = quay.io/joelanford/$(PROJECT_NAME)
export IMG_TAG ?= devel

export VERSION_PKG = $(shell go list -m)/internal/version
export GIT_VERSION = $(shell git describe --dirty --tags --always)
export GIT_COMMIT = $(shell git rev-parse HEAD)

export GO_BUILD_TAGS ?= upstream
BUILD_DIR = $(PWD)/bin

# Setup project-local paths and build settings
SHELL=/bin/bash
TOOLS_DIR=$(PWD)/tools
TOOLS_BIN_DIR=$(TOOLS_DIR)/bin
SCRIPTS_DIR=$(TOOLS_DIR)/scripts
export PATH := $(BUILD_DIR):$(TOOLS_BIN_DIR):$(SCRIPTS_DIR):$(PATH)

.PHONY: all
all: test-all lint build

##@ Development

.PHONY: build
build: ## Build the binary
	fetch goreleaser 1.14.1 && goreleaser build --snapshot --single-target --rm-dist -o $(BUILD_DIR)/$(PROJECT_NAME)

.PHONY: generate
generate: ## Run go generation
	go generate ./...

.PHONY: clean
clean:
	rm -rf $(TOOLS_BIN_DIR) $(BUILD_DIR)

##@ Testing

.PHONY: test-all
test-all: test-sanity test-unit test-e2e ## Run all tests

.PHONY: test-sanity
test-sanity: generate lint ## Test repo formatting, linting, etc.
	go mod tidy
	go vet ./...
	go fmt ./...
	git diff --exit-code # diff again to ensure other checks don't change repo

# Use envtest based on the version of kubernetes/client-go configured in the go.mod file.
# If this version of envtest is not available yet, submit a PR similar to
# https://github.com/kubernetes-sigs/kubebuilder/pull/2287 targeting the kubebuilder
# "tools-releases" branch. Make sure to look up the appropriate etcd version in the
# kubernetes release notes for the minor version you're building tools for.
ENVTEST_VERSION = $(shell go list -m k8s.io/client-go | cut -d" " -f2 | sed 's/^v0\.\([[:digit:]]\{1,\}\)\.[[:digit:]]\{1,\}$$/1.\1.x/')
TESTPKG ?= $(shell go list ./... | grep -v "$(shell go list -m)/test/e2e")
.PHONY: test-unit
test-unit: ## Run unit tests
	go install sigs.k8s.io/controller-runtime/tools/setup-envtest@latest
	eval $$(setup-envtest use -p env $(ENVTEST_VERSION)) && go test -race -covermode atomic -coverprofile cover.out $(TESTPKG)

test-e2e: ## Run e2e tests
	go test -race ./test/e2e/...

.PHONY: lint
lint: ## Run linter
	fetch golangci-lint 1.50.1 && golangci-lint run



##@ CI/CD

.PHONY: release
release: GORELEASER_ARGS ?= --snapshot --rm-dist --skip-sign
release:
	fetch goreleaser 1.14.1 && goreleaser $(GORELEASER_ARGS)

.DEFAULT_GOAL := help
.PHONY: help
help: ## Show this help screen.
	@echo 'Usage: make <OPTIONS> ... <TARGETS>'
	@echo ''
	@echo 'Available targets are:'
	@echo ''
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z0-9_-]+:.*?##/ { printf "  \033[36m%-25s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)
