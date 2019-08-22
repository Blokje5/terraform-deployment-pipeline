package aws

import data.aws.tags_validation
import data.aws.s3

module_address[i] = address {
    changeset := input.resource_changes[i]
    address := changeset.address
}

# validating existince of tags
tags_pascal_case[i] = resources {
    changeset := input.resource_changes[i]
    tags  := changeset.change.after.tags
    resources := [resource | resource := module_address[i]; val := tags[key]; not tags_validation.key_val_valid_pascal_case(key, val)]
}

tags_contain_minimum_set[i] = resources {
    changeset := input.resource_changes[i]
    tags := changeset.change.after.tags
    resources := [resource | resource := module_address[i]; not tags_validation.tags_contain_proper_keys(changeset.change.after.tags)]
}

# Checking for S3 buckets
s3_buckets[i] = resource {
    resource := input.resource_changes[i]
    s3.is_s3_bucket(resource)
}

access_blocks[i] = resource {
    resource := input.resource_changes[i]
    bucket := s3_buckets[_].name
    s3.accesss_block_of_bucket(resource, bucket)
}