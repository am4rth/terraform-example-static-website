variable "domain_zone" {
  description = "Domain zone"
}

variable "domain_name" {
  description = "Domain name"
}

variable "bucket_name" {
  description = "Bucket name"
}

variable "aws_profile" {
  description = "The profile used to performe api requests"
  default = "default"
}