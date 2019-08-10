# Rego Policies

This repository contains rego policies for use with [the Open Policy Agent](https://www.openpolicyagent.org/). The goal is to create a set of policies, upload them to an OCI registry and pull them as part of a CI/CD pipeline using [conftest](https://github.com/instrumenta/conftest)

## Roadmap

1. Build a KIND cluster
2. Upload policies to OCI registry: https://github.com/docker/docker.github.io/blob/master/registry/deploying.md
3. Create a set of REGO policies for AWS resources and Kubernetes resources
4. Build a CI/CD pipeline for terraform and kubernetes deployments, validating them with OPA

