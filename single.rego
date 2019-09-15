package main

deny[msg] {
    resources := tags_contain_minimum_set[_]
    resources != []
    msg := sprintf("Invalid tags (missing minimum required tags) for the following resources: %v", [resources])
}

deny[msg] {
    resources := tags_camel_case_all[_]
    resources != []
    msg := sprintf("Invalid tags (not camel case) for the following resources: %v", [resources])
}

deny[msg] {
    resources := buckets_without_access_blocks[_]
    resources != []
    msg := sprintf("S3 bucket has no access blocks: %v", [resources])
}

module_address[i] = address {
    changeset := input.resource_changes[i]
    address := changeset.address
}

# validating existince of tags
tags_camel_case_all[i] = resources {
    changeset := input.resource_changes[i]
    tags  := changeset.change.after.tags
    resources := [resource | resource := module_address[i]; not tags_camel_case(tags)]
}

tags_contain_minimum_set[i] = resources {
    changeset := input.resource_changes[i]
    tags := changeset.change.after.tags
    resources := [resource | resource := module_address[i]; not tags_contain_proper_keys(changeset.change.after.tags)]
}

# Checking for S3 buckets
s3_buckets[bucket] {
    bucket := input.resource_changes[i]
    is_s3_bucket(bucket)
}

buckets_with_access_blocks[bucket] {
    resource := input.resource_changes[i]
    is_access_block(resource)
    bucket := s3_buckets[j]
    not access_block_of_bucket(resource, bucket)
}

buckets_without_access_blocks[bucket] {
    buckets_without_access_blocks := s3_buckets - buckets_with_access_blocks
    bucket := buckets_without_access_blocks[_].address
}

iam_resources = [
  "aws_iam_user",
  "aws_iam_role",
  "aws_iam_group"
]

is_resource_of_type(resource, type) {
    resource.type == type
}

is_iam_resource(resource) {
    iam := iam_resources[_]
    is_resource_of_type(resource, iam)
}

has_permission_boundary(resource, permission_boundary_arn) {
    is_iam_resource(resource)
    resource.values.permission_boundary = permission_boundary_arn
}

is_s3_bucket(resource) {
    is_resource_of_type(resource, "aws_s3_bucket")
}

is_access_block(resource) {
    is_resource_of_type(resource, "aws_s3_bucket_public_access_block")
}

access_block_of_bucket(resource, bucket) {
    is_access_block(resource)
    resource.change.after.bucket == bucket 
}

minimum_tags = {"ApplicationRole", "Owner", "Project"}

# checks if all tags are camel case
tags_camel_case(tags) {
  not any_tags_not_camel_case(tags)
}

# checks if any tags are NOT camel case
any_tags_not_camel_case(tags) {
    some key
    val := tags[key]
    not is_camel_case(key, val)
}

# checks if a and b are both camel case
is_camel_case(a, b) {
  re_match(`^([A-Z][a-z0-9]+)+`, a)
  re_match(`^([A-Z][a-z0-9]+)+`, b)
}

tags_contain_proper_keys(tags) {
    keys := {key | tags[key]}
    leftover := minimum_tags - keys
    leftover == set()
}