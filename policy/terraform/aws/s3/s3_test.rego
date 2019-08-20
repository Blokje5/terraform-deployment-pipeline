package aws.s3

test_is_s3_bucket {
    resource := { "type": "aws_s3_bucket" }
    is_s3_bucket(resource)
}

test_is_s3_bucket_mismatch {
    resource := { "type": "aws_iam_user" }
    not is_s3_bucket(resource)
}
