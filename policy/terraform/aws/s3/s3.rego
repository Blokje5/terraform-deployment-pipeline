package aws.s3

import data.common

is_s3_bucket(resource) {
    common.is_resource_of_type(resource, "aws_s3_bucket")
}

find_all_s3_buckets(resources) = resource {
    resource := resources[_]
    is_s3_bucket(resource)
}