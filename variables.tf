variable "cidr" {
  type = string
}

variable "public_subnet_cidr" {
  type = string
}

variable "private_subnet_cidr" {
  type = string
}

variable "tags" {
  type = map  
}

variable "internet_cidr" {
  type = string
  description = "(optional) describe your variable"
}

variable "internet" {
    type = bool
}

variable "lb_type" {
  type = string   
}

variable "subnet_ids" {
    type = list
}

variable "security_groups" {
    type = list 
}
variable "timeout" {
    type = number  
}