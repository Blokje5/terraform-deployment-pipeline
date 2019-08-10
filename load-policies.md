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