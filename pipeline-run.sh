#!/usr/bin/env bash
# Deploy configmap with example code
kubectl create configmap terraform --from-file=example/terraform/missing_access_block
# Deploy tasks
kubectl apply --kubeconfig=$(make env) -f deployments/pipelines/tasks/terraform.yaml
# Deploy pipeline
kubectl apply --kubeconfig=$(make env) -f deployments/pipelines/pipeline/opa-pipeline.yaml
# Run pipeline
kubectl apply --kubeconfig=$(make env) -f deployments/pipelines/pipeline/run.yaml