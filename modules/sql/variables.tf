variable "vpc_id" {
  type = string
}

variable "region" {
  type = string
}

variable "mysql" {
  type = object({
    instance_name = string
    db_version = string
    instance_tier = string
    db = object({
      name = string
    }) 
  })
}