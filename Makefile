check-repo:
ifndef REPOSITORY
	$(error REPOSITORY is undefined)
endif

# Build the binaries
build:
	GOOS=linux
	GOARCH=amd64
	CGO_ENABLED=0
	go build -v -o=bin/pulsar-operator -installsuffix=cgo ./cmd/manager/
.PHONY: build

# Build and push the docker image
image: check-repo
	docker build --tag $(REPOSITORY) -f Dockerfile bin/
	docker push $(REPOSITORY)
.PHONY: image

# generate code(zz_generated*)
# generate go mod list to vendor
# Example:
#   make generate
generate:
	operator-sdk generate k8s
	operator-sdk generate openapi
	go mod vendor
.PHONY: generate

# clean all binaries
clean:
	rm -rf ./bin
	go clean -i all
	go clean -cache
.PHONY: clean
