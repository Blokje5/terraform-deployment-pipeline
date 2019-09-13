#!/usr/bin/env bash
account_id=$1
credentials=$(aws sts assume-role --role-arn "arn:aws:iam::$account_id:role/terraform-demo" --role-session-name "DemoOPATekton")
key="$(echo ${credentials} | jq -r '.Credentials.AccessKeyId')"
secret="$(echo ${credentials} | jq -r '.Credentials.SecretAccessKey')"
kubectl create secret generic aws-secret  --kubeconfig=$(make env) --from-literal=key=$key --from-literal=secret=$secret > /dev/null 2>&1