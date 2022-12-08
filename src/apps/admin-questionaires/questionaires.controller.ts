import { BaseController, WithControllerMethod } from '/opt/@libs/mvc/controller';
import { Router, Method } from '/opt/@libs/annotations/routerConfig';
import {  Controller } from '/opt/@libs/annotations/controllerConfig';
import { BaseResponse, ControllerResponse } from '/opt/@libs/mvc/response';
import { Request, Response } from 'express';

@Controller({ name : 'Questionaires Controller', prefix : '/admin/questionaires'})
class TodoController extends BaseController implements WithControllerMethod<TodoController> {
  @Router({method: Method.POST, path: '/', context: TodoController.getContext() })
  getUsers (req: Request, res: Response): BaseResponse {
    const response = new ControllerResponse;
    response.statusCode = 200;
    response.response = {
      message: 'Created Questionaires'
    };
    return response;
  }
}

export default TodoController;