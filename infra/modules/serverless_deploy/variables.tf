# Input variable definitions

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
    path = string,
    uri = string
  })
  default = {
    name = "TodoApps"
    path = "todos"
    uri = ""
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
variable "apigateway" {
  type = object({
    arn = string,
    restid = string,
    count = number,
    stage = string,
    root_resource_id = string
  })
  default = {
    arn = "",
    restid = "",
    count = 0
    stage = "",
    root_resource_id = ""
  }
}