import { BaseController, WithControllerMethod } from '/opt/@libs/mvc/controller';
import { Router, Method } from '/opt/@libs/annotations/routerConfig';
import {  Controller } from '/opt/@libs/annotations/controllerConfig';
import { BaseResponse, ControllerResponse } from '/opt/@libs/mvc/response';
import { Request, Response } from 'express';

@Controller({ name : 'Questionaires Controller', prefix : '/v1/admin/questionaires'})
class AdminQuestionairesController extends BaseController implements WithControllerMethod<AdminQuestionairesController> {
  @Router({method: Method.POST, path: '/', context: AdminQuestionairesController.getContext() })
  getUsers (req: Request, res: Response): BaseResponse {
    console.log(req);
    const response = new ControllerResponse;
    response.statusCode = 200;
    response.response = {
      message: 'Created Questionaires2'
    };
    return response;
  }
}

export default AdminQuestionairesController;