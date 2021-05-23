provider "aws" {
  profile = "default"
  region  = "eu-west-1"
}

resource "aws_cognito_user_pool" "apps_user_pool" {
  name                     = "${local.user_pool_name}"
  auto_verified_attributes = ["email"]
}

resource "aws_cognito_user_pool_domain" "sample_domain" {
  domain          = "${local.custom_domain}"
  user_pool_id    = aws_cognito_user_pool.apps_user_pool.id
}

resource "aws_cognito_user_pool_client" "cognito" {
  name                                 = "client"
  user_pool_id                         = aws_cognito_user_pool.apps_user_pool.id
  supported_identity_providers         = ["COGNITO", "Google"]
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows                  = ["code"]
  allowed_oauth_scopes                 = ["email", "openid", "profile"]
  callback_urls                        = "${local.client_callback_urls}"
  logout_urls                          = "${local.client_logout_urls}"
  read_attributes                      = []
  write_attributes                     = []
  explicit_auth_flows                  = []
  generate_secret                      = true
}

resource "aws_cognito_identity_pool" "apps_identity_pool" {
  identity_pool_name               = "${local.identity_pool_name}"
  allow_unauthenticated_identities = false

  cognito_identity_providers {
    client_id               = "${aws_cognito_user_pool_client.cognito.id}"
    provider_name           = "cognito-idp.eu-east-1.amazonaws.com/${aws_cognito_user_pool.apps_user_pool.id}"
    server_side_token_check = false
  }

  supported_login_providers {
    "accounts.google.com" = "${local.client_id}"
  }
}

resource "aws_cognito_identity_pool_roles_attachment" "apps_roles" {
  identity_pool_id = aws_cognito_identity_pool.apps_identity_pool.id

  roles = {
    "authenticated"   = aws_iam_role.aws_resource_access.arn
    "unauthenticated" = aws_iam_role.deny_everything.arn
  }
}
