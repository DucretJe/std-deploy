# AWS IAM Role

This module deploys a [Role](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles.html) and a [Policy](https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies.html) attached to this role (except if the role has an inline policy).

## Documentation

* [aws_iam_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role)
* [aws_iam_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy)

## How to

By default this module will create a Role and a Role policy. You have to define the policy that grants an entity permission to assume the role using variable `iam_role_assume_role_policy`, you also have to define the inline policy document using variable `iam_role_policy_policy`.
The Maximum session duration set for the specified role is defaulted to 1h.
You can customize it specifiying the following variables:

* IAM Role:
  * Name: `iam_role_name`
  * Name Prefix: `iam_role_name_prefix`
  * Description: `iam_role_description`
  * Policy that grant an entity to assume the role: `iam_role_assume_role_policy`
  * Whether to force detaching any policies the role has before destroying it: `iam_role_force_detach_policies`
  * Inline Policy: `iam_role_inline_policy`
  * Managed Policy ARN: `iam_role_managed_policy_arns`
  * Max Session Duration: `iam_role_max_session_duration`
  * Path to the role: `iam_role_path`
  * ARN of the policy that is used to set the permissions boundary for the role: `iam_role_permissions_boundary`
  * Tags: `iam_role_tags`
* IAM Role policy:
  * Name: `iam_role_policy_name`
  * Name Prefix: `iam_role_policy_name_prefix`
  * Policy: `iam_role_policy_policy`

