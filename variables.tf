variable "name" {
  description = "The name of this deployment."
  type        = string
  default     = "consul-dev-deployment"
}

# AWS

## VPC

variable "region" {
  description = "The AWS region to create resources in."
  type        = string
  default     = "us-west-2"
}

variable "vpc_cidr" {
  description = "VPC CIDR block."
  type        = string
  default     = "10.0.0.0/16"

}

variable "private_subnets" {
  description = "List of private subnet CIDR blocks."
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "public_subnets" {
  description = "List of public subnet CIDR blocks."
  type        = list(string)
  default     = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}

## K8S

variable "k8s_version" {
  type        = string
  description = "Version of Kubernetes to deploy to EKS."
  default     = "1.22"
}

# Consul

variable "consul_chart_version" {
  description = "Version of the Helm chart used to install Consul."
  type        = string
  default     = "0.49.0"
}

variable "consul_datacenter" {
  description = "The name of the Consul datacenter."
  type        = string
  default     = "dc1"
}

variable "consul_image" {
  type        = string
  description = "The Consul version to deploy"
  default     = "hashicorp/consul:1.13.3"
}

variable "consul_secrets_name" {
  description = "The name of the Kubernetes secret that holds Consul secrets."
  type        = string
  default     = "consul-secrets"
}

variable "consul_license_path" {
  description = "The path to a valid Consul license file if using a Consul enterprise image."
  type        = string
  default     = ""
}
