package aws.tags_validation

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