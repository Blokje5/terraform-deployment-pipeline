package common

test_is_resource_of_type {
    resource := { "type": "aws_iam_role" }
    type := "aws_iam_role"
    is_resource_of_type(resource, type)
}

test_is_resource_of_type_mismatch {
    resource := { "type": "aws_iam_user" }
    type := "aws_iam_role"
    not is_resource_of_type(resource, type)
}