variable "oidc_issuer_url" {
  type = string
}

variable "service_account_name" {
  default = "ecr-reader-sa"
}

variable "ecr_access_namespaces" {
  default = ["frontend", "backend"]
}

variable "oidc_provider_url" {
  type = string  
}

variable "env" {
  type = string
}