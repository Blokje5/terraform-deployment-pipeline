#!/usr/bin/env bash
cd deployments/registry/certs
cfssl gencert -initca ca.json | cfssljson -bare ca
cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=server -hostname="docker-registry" request.json | cfssljson -bare docker-registry
