# Load rego policies in the docker registry

Steps:
In the KIND cluster, start an instance of the docker regitry:

```bash
make registry
```

port-forward the docker registry so it is reachable from the terminal
```bash
kubectl port-forward docker-registry 5000:5000 
```

Using conftest push the Rego policies in this repository

```bash
conftest push localhost:5000/policies:latest
````

Verify whether the policies where succesfully uploaded by pulling them

```bash
conftest pull localhost:5000/policies:latest
```

# Securing the docker-registry
See also: https://github.com/kubernetes-sigs/kind/issues/110
https://github.com/windmilleng/kind-local

Due to the certs not coming from a trusted CA, the kind cluster docker daemon (which uses containerd)
needs to be edited. 

The following script can be executed after the kind cluster is started to allow for access to an insecure docker-registry 
from within the kind cluster:

```bash
./registry.sh
```
