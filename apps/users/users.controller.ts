import { BaseController, WithControllerMethod } from '../../libs/mvc/controller';
import { Router, Method } from '../../libs/annotations/routerConfig';
import {  Controller } from '../../libs/annotations/controllerConfig';
import { BaseResponse, ControllerResponse } from '../../libs/mvc/response';
import { Request, Response } from 'express';

@Controller({ name: 'User Controller', prefix: '/users'})
class UserController extends BaseController implements WithControllerMethod<UserController> {
  @Router({method: Method.GET, path: '/', context: UserController.getContext() })
  getUsers (req: Request, res: Response): BaseResponse {
    const response = new ControllerResponse;
    response.statusCode = 200;
    response.response = {
      message: 'Meow'
    };
    return response;
  }
}

export default UserController;