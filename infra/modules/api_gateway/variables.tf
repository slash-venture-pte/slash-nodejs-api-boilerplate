# Input variable definitions

variable "general" {
  type = object({
    region = string,
  })
  default = {
    region = "ap-southeast-1"
  }
}

variable "application" {
  type = object({
    name = string
  })
  default = {
    name = "AppName"
  }
}

variable "protocol" {
  type = string
  default = "HTTP"
}

variable "stage" {
  type = string
  default = "dev"
}