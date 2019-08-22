package main

import data.aws

deny[msg] {
    resources := aws.tags_contain_minimum_set[_]
    resources != []
    msg := sprintf("Invalid tags (missing minimum required tags) for the following resources: %v", [resources])
}

deny[msg] {
    resources := aws.tags_pascal_case[_]
    resources != []
    msg := sprintf("Invalid tags (not pascal case) for the following resources: %v", [resources])
}

deny[msg] {
    true
    resources := aws.access_blocks[_]
    msg := sprintf("Invalid tags (not pascal case) for the following resources: %v", [resources])
}