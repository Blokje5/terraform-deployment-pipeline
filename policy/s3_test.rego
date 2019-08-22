package aws.s3

test_is_s3_bucket {
    resource := { "type": "aws_s3_bucket" }
    is_s3_bucket(resource)
}

test_is_s3_bucket_mismatch {
    resource := { "type": "aws_iam_user" }
    not is_s3_bucket(resource)
}

test_access_block_of_bucket {
    bucket := "test_bucket"
    resource := { "type": "aws_s3_bucket_public_access_block", "change": { "after" : { "bucket" : bucket} } }
    access_block_of_bucket(resource,bucket)
}

test_not_access_block_of_bucket {
    bucket := "test_bucket"
    resource := { "type": "aws_s3_bucket_public_access_block", "change": { "after" : { "bucket" : "other_bucket"} } }
    not access_block_of_bucket(resource,bucket)
}