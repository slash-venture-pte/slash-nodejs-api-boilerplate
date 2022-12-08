# Input variable definitions

# variable "aws_region" {
#   description = "AWS region for all resources."

#   type    = string
#   default = "ap-southeast-1"
# }

# variable "serverless_conf" {
#   # provider = object({
#   #   region = string
#   # })
#   type = object({
#      provider = object({
#       region = string
#       runtime = string
#      })
#     application = object({
#       name = string
#       path = string
#      })
#      function = object({
#       name = string
#       handler = string
#      })
#   })
# }

variable "general" {
  type = object({
    region = string,
    runtime = string
  })
  default = {
    region = "ap-southeast-1"
    runtime = "nodejs14.x"
  }
}

variable "application" {
  type = object({
    name = string,
    path = string
  })
  default = {
    name = "TodoApps"
    path = "todos"
  }
}
variable "function" {
  type = object({
    name = string,
    handler = string
  })
  default = {
    name = "TodosWebAPI",
    handler = "index.handler"
  }
}