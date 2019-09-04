package aws.tags_validation

test_tags_valid_camel_case {
    tags := { "ApplicationRole": "ArtifactRepository" }
    tags_camel_case(tags)
}

test_tags_valid_camel_case_lower_case_key {
    tags := { "applicationRole": "ArtifactRepository" }
    not tags_camel_case(tags)
}

test_tags_valid_camel_case_lower_case_value {
    tags := { "ApplicationRole": "artifactRepository" }
    not tags_camel_case(tags)
}


test_tags_valid_camel_case_lower_case_value_multiple_tags {
    tags := { "ApplicationRole": "artifactRepository", "Project": "Artifacts" }
    not tags_camel_case(tags)
}

test_tags_contain_proper_keys {
    tags := { "ApplicationRole": "ArtifactRepository", "Project": "Artifacts", "Owner": "Ssi", "Country": "Ng" }
    tags_contain_proper_keys(tags)
}

test_tags_contain_proper_keys_missing_key {
    tags := { "ApplicationRole": "ArtifactRepository", "Project": "Artifacts", "Country": "Ng" }
    not tags_contain_proper_keys(tags)
}