# Rego Policies

This repository contains rego policies for use with [the Open Policy Agent](https://www.openpolicyagent.org/). The goal is to create a set of policies, upload them to an OCI registry and pull them as part of a CI/CD pipeline using [conftest](https://github.com/instrumenta/conftest)

## Roadmap

1. Build a KIND cluster
2. Upload policies to OCI registry: https://github.com/docker/docker.github.io/blob/master/registry/deploying.md
3. Create a set of REGO policies for AWS resources and Kubernetes resources
4. Build a CI/CD pipeline for terraform and kubernetes deployments, validating them with OPA


## Testing the policies locally with conftests

Executing conftest locally can be done with:

```bash
conftest test example/terraform/missing_access_block/tfplan.json
```

which should return

```bash
FAIL - example/terraform/missing_access_block/tfplan.json - S3 bucket has no access blocks: aws_s3_bucket.profile_picture_storage
```

## Using the makefile to setup a cluster

```bash
make create
export KUBECONFIG=$(make env)
```

## Load rego policies in the docker registry

bash script:

```bash
./load-policies.sh
```

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

## Execute the terraform pipeline

Note: as it executes terraform plan this requires valid AWS credentials. An aws-secret needs to be created in the kubernetes cluster in order
for the tekton pipeline to have access to the credentials. the `./create-secret.sh` script can be used to create the secret (editing the `aws-sts-assume` call by passing in a valid role in your aws account with enough permissions)

Executing the tekton pipelines:

```bash
./create-secret.sh <aws-account-id> # create aws-secret
make tekton # deploy tekton in KIND cluster
./pipeline-run.sh # moves example code to configmaps, creates a tekton task and pipeline and executes the run
```

if set up properly, reading the logs for the `step-conftest-test` should return the following:

```bash
FAIL - tfplan.json - S3 bucket has no access blocks: aws_s3_bucket.profile_picture_storage
```

## Unit-test OPA policies

OPA supports writing unit-tests for Rego, which can be executed by calling:

```bash
make unit-test
```

this returns the following results:

```bash
data.common.test_is_resource_of_type: PASS (1.157768ms)
data.common.test_is_resource_of_type_mismatch: PASS (389.224µs)
data.aws.iam.test_is_iam_resource: PASS (402.074µs)
data.aws.iam.test_is_iam_resource_mismatch: PASS (368.948µs)
data.aws.iam.test_has_permission_boundary: PASS (967.804µs)
data.aws.iam.test_has_permission_boundary_empty: PASS (584.702µs)
data.aws.iam.test_has_permission_boundary_mismatch: PASS (488.105µs)
data.main.test_tags_pascal_case: PASS (1.368847ms)
data.main.test_tags_pascal_case_with_wrong_value_format: PASS (1.738822ms)
data.main.test_tags_pascal_case_with_wrong_key_format: PASS (1.283228ms)
data.main.test_tags_contain_minimum_set: PASS (2.795216ms)
data.main.test_tags_contain_minimum_set_with_extra_tags: PASS (1.487231ms)
data.main.test_tags_contain_minimum_set_without_minimum: PASS (1.151085ms)
data.aws.s3.test_is_s3_bucket: PASS (300.622µs)
data.aws.s3.test_is_s3_bucket_mismatch: PASS (294.866µs)
data.aws.s3.test_access_block_of_bucket: PASS (364.788µs)
data.aws.s3.test_not_access_block_of_bucket: PASS (317.812µs)
data.aws.tags_validation.test_tags_valid_camel_case: PASS (337.367µs)
data.aws.tags_validation.test_tags_valid_camel_case_lower_case_key: PASS (432.084µs)
data.aws.tags_validation.test_tags_valid_camel_case_lower_case_value: PASS (352.916µs)
data.aws.tags_validation.test_tags_valid_camel_case_lower_case_value_multiple_tags: PASS (485.881µs)
data.aws.tags_validation.test_tags_contain_proper_keys: PASS (408.266µs)
data.aws.tags_validation.test_tags_contain_proper_keys_missing_key: PASS (1.800584ms)
--------------------------------------------------------------------------------
PASS: 23/23
```
