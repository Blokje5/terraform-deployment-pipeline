WAIT := 200s
NAME = $$(echo $@ | cut -d "-" -f 2- | sed "s/%*$$//")

create-%:
	-@kind create cluster --name $(NAME) --wait $(WAIT)

delete-%:
	@kind delete cluster --name $(NAME)

env-%:
	@kind get kubeconfig-path --name $(NAME)

clean:
	@kind get clusters | xargs -L1 -I% kind delete cluster --name %

list:
	@kind get clusters

.PHONY: create-% delete-% env-% clean list