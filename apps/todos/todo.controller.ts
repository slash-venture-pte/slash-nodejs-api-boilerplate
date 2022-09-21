import { BaseController, WithControllerMethod } from '../../libs/mvc/controller';
import { Router, Method } from '../../libs/annotations/routerConfig';
import {  Controller } from '../../libs/annotations/controllerConfig';
import { BaseResponse, ControllerResponse } from '../../libs/mvc/response';
import { Request, Response } from 'express';

@Controller({ name : 'Todo Controller', prefix : '/todos'})
class TodoController extends BaseController implements WithControllerMethod<TodoController> {
  @Router({method: Method.GET, path: '/users', context: TodoController.getContext() })
  getUsers (req: Request, res: Response): BaseResponse {
    const response = new ControllerResponse;
    response.statusCode = 200;
    response.response = {
      message: 'Good'
    };
    return response;
  }
}

export default TodoController;