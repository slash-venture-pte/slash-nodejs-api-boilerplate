import { Request, Response, Router as ExpressRouter } from "express";
import {CoreServer} from '../mvc/server';
import { ControllerResponse } from '../mvc/response';


enum Method {
  GET = "get",
  POST = "post",
  PUT = "put",
  PATCH = "patch",
  DELETE = "delete",
}

interface RouteConfigProps {
  method: Method;
  path: string;
  context: CoreServer,
}

function Router({ method, path, context }: RouteConfigProps): MethodDecorator {
  return function (
    target: Object,
    propertyKey: string | symbol,
    descriptor: PropertyDescriptor
  ) {
    const response = (req: Request, res: Response) => {
      const original: ControllerResponse = descriptor.value(req, res);

      res.status(original.statusCode!).json(original.response);
    };
    // Context can be null
    context?.router[method](path, response);
  };
}


 

export { Router, Method
}