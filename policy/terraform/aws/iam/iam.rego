package aws.iam

import data.common

iam_resources = [
  "aws_iam_user",
  "aws_iam_role",
  "aws_iam_group"
]

is_iam_resource(resource) {
    iam := iam_resources[_]
    common.is_resource_of_type(resource, iam)
}

has_permission_boundary(resource, permission_boundary_arn) {
    is_iam_resource(resource)
    resource.values.permission_boundary = permission_boundary_arn
}