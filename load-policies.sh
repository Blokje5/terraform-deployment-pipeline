#!/usr/bin/env bash
make registry
kubectl port-forward docker-registry 5000:5000 &
sleep 2
conftest push localhost:5000/policies
conftest pull localhost:5000/policies -p tmp