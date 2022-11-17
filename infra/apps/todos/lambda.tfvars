
serverless_conf = {
  provider = {
    region = "ap-southeast-1"
    runtime = "nodejs14.x"
  }
  application = {
    name = "TodoApps"
    path = "todos"
  }
  function = {
    name = "TodosWebAPI",
    handler = "index.handler"
  }
}