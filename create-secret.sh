#!/usr/bin/env bash
account_id=$1
credentials=$(aws sts assume-role --role-arn "arn:aws:iam::$account_id:role/terraform-demo" --role-session-name "DemoOPATekton")
key="$(echo ${credentials} | jq -r '.Credentials.AccessKeyId')"
secret="$(echo ${credentials} | jq -r '.Credentials.SecretAccessKey')"
token="$(echo ${credentials} | jq -r '.Credentials.SessionToken')"
kubectl create secret generic aws-secret  --kubeconfig=$(make env) --from-literal=key=$key --from-literal=secret=$secret --from-literal=token=$token > /dev/null 2>&1
