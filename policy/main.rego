package main

import data.aws

deny[msg] {
    resources := aws.tags_contain_minimum_set[_]
    resources != []
    msg := sprintf("Invalid tags (missing minimum required tags) for the following resources: %v", [resources])
}

deny[msg] {
    resources := aws.tags_camel_case[_]
    resources != []
    msg := sprintf("Invalid tags (not camel case) for the following resources: %v", [resources])
}

deny[msg] {
    resources := aws.buckets_without_access_blocks[_]
    resources != []
    msg := sprintf("S3 bucket has no access blocks: %v", [resources])
}