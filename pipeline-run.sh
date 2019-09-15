#!/usr/bin/env bash
# Deploy configmap with example code
kubectl create configmap terraform --from-file=example/terraform/missing_access_block
# Deploy temp PV
kubectl apply --kubeconfig=$(make env) -f deployments/pipelines/pv.yaml
# Copy example to path
cp -r example/terraform/missing_access_block /tmp/data
# Deploy tasks
kubectl apply --kubeconfig=$(make env) -f deployments/pipelines/tasks/terraform.yaml
# Deploy pipeline
kubectl apply --kubeconfig=$(make env) -f deployments/pipelines/pipeline/opa-pipeline.yaml
# Run pipeline
kubectl apply --kubeconfig=$(make env) -f deployments/pipelines/pipeline/run.yaml