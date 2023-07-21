variable "db_name" {
  description = "mysql database name"
  type        = string
}

variable "db_username" {
  description = "mysql database username"
  type        = string
}

variable "db_password" {
  description = "mysql database password"
  type        = string
}

variable "hosted_zone_id" {
  description = "hosted zone ID for route53"
  type        = string
}