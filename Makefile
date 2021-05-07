check-repo:
ifndef REPOSITORY
	$(error REPOSITORY is undefined)
endif

# Build the binaries
build:
	@GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -v -o=bin/pulsar-operator -installsuffix=cgo ./cmd/manager/
.PHONY: build

# Build and push the docker image
install: check-repo
	docker build --tag $(REPOSITORY) -f Dockerfile bin/
	docker push $(REPOSITORY)
	kubectl create -f deploy/crds/pulsar.apache.org_pulsarclusters_crd.yaml
	kubectl create -f deploy/rbac/all_namespace_rbac.yaml
	# Take that, Helm!
	@REPOSITORY="$(REPOSITORY)"  cat deploy/operator.yaml | envsubst | kubectl create -f -
.PHONY: install

uninstall:
	kubectl delete -f deploy/operator.yaml
	kubectl delete -f deploy/rbac/all_namespace_rbac.yaml
	kubectl delete -f deploy/crds/pulsar.apache.org_pulsarclusters_crd.yaml
.PHONY: uninstall


# clean all binaries
clean:
	rm -rf ./bin
	go clean -i all
	go clean -cache
.PHONY: clean
