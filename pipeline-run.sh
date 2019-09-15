#!/usr/bin/env bash
# Deploy configmap with example code
kubectl create configmap terraform --from-file=example/terraform/missing_access_block
# Deploy configmap with policies
kubectl create configmap policy --from-file=single.rego
# Deploy temp PV
kubectl apply --kubeconfig=$(make env) -f deployments/pipelines/pv.yaml
# Deploy tasks
kubectl apply --kubeconfig=$(make env) -f deployments/pipelines/tasks/terraform.yaml
# Deploy pipeline
kubectl apply --kubeconfig=$(make env) -f deployments/pipelines/pipeline/opa-pipeline.yaml
# Run pipeline
kubectl apply --kubeconfig=$(make env) -f deployments/pipelines/pipeline/run.yaml