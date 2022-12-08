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
    handler = string,
    method = string
  })
  default = {
    name = "TodosWebAPI",
    handler = "index.handler"
    method = "POST"
  }
}
variable "apigateway" {
  type = object({
    arn = string,
    restid = string,
    count = number,
    stage = string
  })
  default = {
    arn = "",
    restid = "",
    count = 0
    stage = ""
  }
}