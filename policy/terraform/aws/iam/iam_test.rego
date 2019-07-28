package aws.iam

test_is_iam_resource {
    resource := { "type": "aws_iam_user" }
    is_iam_resource(resource)
}

test_is_iam_resource_mismatch {
    resource := { "type": "aws_s3_bucket" }
    not is_iam_resource(resource)
}

test_has_permission_boundary {
    permission_boundary_arn = "arn:aws:iam::0123456789:policy/permission-boundary-policy"
    resource := { "type": "aws_iam_user", "values": { "permission_boundary": permission_boundary_arn } }
    has_permission_boundary(resource, permission_boundary_arn)
}

test_has_permission_boundary_empty {
    permission_boundary_arn = "arn:aws:iam::0123456789:policy/permission-boundary-policy"
    resource := { "type": "aws_iam_user", "values": { "permission_boundary": "" } }
    not has_permission_boundary(resource, permission_boundary_arn)
}

test_has_permission_boundary_mismatch {
    permission_boundary_arn = "arn:aws:iam::0123456789:policy/permission-boundary-xpolicy"
    resource := { "type": "aws_iam_user", "values": { "permission_boundary": "arn:aws:iam::0123456789:policy/permission-boundary-wrong-policy" } }
    not has_permission_boundary(resource, permission_boundary_arn)
}