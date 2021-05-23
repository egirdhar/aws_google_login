variable "name" {
  default = "sample_up_apps"
}
variable "identity_name" {
  default = "sample_ip_apps"
}
variable "google_provider_client_id" {}
variable "google_provider_client_secret" {}

variable "domain" {
  default = "sample_apps"
}
variable "client_callback_urls" {
  type    = list(string)
  default = ["http://localhost:9000"]
}

variable "client_logout_urls" {
  type    = list(string)
  default = ["http://localhost:9000"]
}
locals {
  user_pool_name       = var.name
  identity_pool_name   = var.identity_name
  custom_domain        = var.domain
  client_id            = var.google_provider_client_id
  client_secret        = var.google_provider_client_secret
  client_callback_urls = var.client_callback_urls
  client_logout_urls   = var.client_logout_urls
}
