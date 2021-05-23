resource "aws_iam_role_policy" "aws_resource_access" {
  name   = "aws_resource_access"
  role   = aws_iam_role.aws_resource_access.id
  policy = data.aws_iam_policy_document.aws_resource_access.json
}
resource "aws_iam_role" "aws_resource_access" {
  name = "elasticloadbalancing-access"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "cognito-identity.amazonaws.com"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "cognito-identity.amazonaws.com:aud": "${aws_cognito_identity_pool.apps_identity_pool.id}"
        },
        "ForAnyValue:StringLike": {
          "cognito-identity.amazonaws.com:amr": "authenticated"
        }
      }
    }
  ]
}
EOF
}

data "aws_iam_policy_document" "aws_resource_access" {
  version = "2012-10-17"
  statement {
    actions = [
      "elasticloadbalancing:*"
    ]

    effect = "Allow"

    resources = ["arn:aws:elasticloadbalancing:*:*:*"]
  }
}

resource "aws_iam_role_policy" "deny_everything" {
  name   = "deny_everything"
  role   = aws_iam_role.deny_everything.id
  policy = data.aws_iam_policy_document.deny_everything.json
}

resource "aws_iam_role" "deny_everything" {
  name = "deny_everything"
  # permission document to assume the role
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "cognito-identity.amazonaws.com"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "cognito-identity.amazonaws.com:aud": "${aws_cognito_identity_pool.apps_identity_pool.id}"
        },
        "ForAnyValue:StringLike": {
          "cognito-identity.amazonaws.com:amr": "unauthenticated"
        }
      }
    }
  ]
}
EOF
}

data "aws_iam_policy_document" "deny_everything" {
  version = "2012-10-17"

  statement {
    actions   = ["*"]
    effect    = "Deny"
    resources = ["*"]
  }
}
