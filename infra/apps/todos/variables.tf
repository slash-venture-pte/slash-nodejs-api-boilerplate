# Input variable definitions

# variable "aws_region" {
#   description = "AWS region for all resources."

#   type    = string
#   default = "ap-southeast-1"
# }

variable "serverless_conf" {
  # provider = object({
  #   region = string
  # })
  type = object({
     provider = object({
      region = string
      runtime = string
     })
    application = object({
      name = string
      path = string
     })
     function = object({
      name = string
      handler = string
     })
  })

  
  # default = [
  #   {
  #     name              = "example-vm"
  #     size = "Standard_F2"
  #     username               = "adminuser"
  #     password = "Notallowed1!"
  #   }
  # ]
}
