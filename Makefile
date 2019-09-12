WAIT := 200s
APPLY = kubectl apply --kubeconfig=$$(kind get kubeconfig-path --name test) --filename
OPA = opa

unit-test:
	@$(OPA) test -v policy

create:
	-@kind create cluster --name test --wait $(WAIT)

delete:
	@kind delete cluster --name test

env:
	@kind get kubeconfig-path --name test

clean:
	@kind get clusters | xargs -L1 -I% kind delete cluster --name %

list:
	@kind get clusters

registry:
	@$(APPLY) deployments/registry/registry.yml

tekton:
	@$(APPLY) https://storage.googleapis.com/tekton-releases/latest/release.yaml

.PHONY: create delete env clean list registry unit-test tekton