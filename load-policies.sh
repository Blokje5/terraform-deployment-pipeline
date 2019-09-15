#!/usr/bin/env bash
kubectl create cm nginx-conf --from-file=nginx.conf=./deployments/registry/conf/nginx.conf --kubeconfig=$(make env)
kubectl create secret generic nginx-certs --from-file=cert=./deployments/registry/certs/docker-registry.pem --from-file=key=./deployments/registry/certs/docker-registry-key.pem --kubeconfig=$(make env)
make registry
kubectl wait  -l run=docker-registry --for=condition=Ready pod
kubectl port-forward docker-registry 5000:5000 &
sleep 2
conftest push localhost:5000/policies:latest
conftest pull localhost:5000/policies -p tmp