variable "name" {
  type = string
}

variable "internal" {
  type = bool
}

variable "security_groups" {
  type = set(string)
}

variable "subnets" {
  type = set(string)
}