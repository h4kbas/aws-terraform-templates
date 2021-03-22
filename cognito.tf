resource "aws_cognito_user_pool" "soulmeet_user_pool" {
  name                     = "soulmeet_user_pool"
  auto_verified_attributes = ["email"]
  username_attributes      = ["email"]
}

# Enable hosted UI feature in Cognito by attaching a domain to user pool.
# https://docs.aws.amazon.com/cognito/latest/developerguide/cognito-user-pools-app-integration.html
resource "aws_cognito_user_pool_domain" "default" {
  user_pool_id = aws_cognito_user_pool.soulmeet_user_pool.id
  domain       = "soulmeet-users"
}

resource "aws_cognito_user_pool_client" "soulmeet_user_pool" {
  name                          = "soulmeet_user_pool"
  user_pool_id                  = aws_cognito_user_pool.soulmeet_user_pool.id
}