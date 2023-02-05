
variable "key_pair_name" {
  type        = string
  description = "Path to the private key file for SSH access to the EC2 instances"
  default     = "hch-bkp"
}

variable "domain_name" {
  type        = string
  default     = "seyi-altschool.com"
  description = "domain name"
}

variable "record_name" {
  type        = string
  default     = "terraform-test"
  description = "sub-domain name"
}

