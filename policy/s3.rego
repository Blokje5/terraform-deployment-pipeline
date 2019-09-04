package aws.s3

import data.common

is_s3_bucket(resource) {
    common.is_resource_of_type(resource, "aws_s3_bucket")
}

is_access_block(resource) {
    common.is_resource_of_type(resource, "aws_s3_bucket_public_access_block")
}

access_block_of_bucket(resource, bucket) {
    is_access_block(resource)
    resource.change.after.bucket == bucket 
}