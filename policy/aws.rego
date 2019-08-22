package aws

import data.aws.tags_validation
import data.aws.s3

module_address[i] = address {
    changeset := input.resource_changes[i]
    address := changeset.address
}

# validating existince of tags
tags_camel_case[i] = resources {
    changeset := input.resource_changes[i]
    tags  := changeset.change.after.tags
    resources := [resource | resource := module_address[i]; tags_validation.tags_camel_case(tags)]
}

tags_contain_minimum_set[i] = resources {
    changeset := input.resource_changes[i]
    tags := changeset.change.after.tags
    resources := [resource | resource := module_address[i]; not tags_validation.tags_contain_proper_keys(changeset.change.after.tags)]
}

# Checking for S3 buckets
s3_buckets[bucket] {
    bucket := input.resource_changes[i]
    s3.is_s3_bucket(bucket)
}

buckets_with_access_blocks[bucket] {
    resource := input.resource_changes[i]
    s3.is_access_block(resource)
    bucket := s3_buckets[j]
    not s3.access_block_of_bucket(resource, bucket)
}

buckets_without_access_blocks[bucket] {
    buckets_without_access_blocks := s3_buckets - buckets_with_access_blocks
    bucket := buckets_without_access_blocks[_].address
}