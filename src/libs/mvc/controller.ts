import {Request, Response, Router } from 'express';
import { CoreServer } from './server';
import { BaseResponse } from './response';

type ControllerMethod = (req: Request, res: Response) => BaseResponse;
type WithControllerMethod<T> = { [K in keyof T]: T[K] extends Function ? ControllerMethod : T[K] }

abstract class BaseController {
  protected static _controllerName?: string;
  protected _router: Router | undefined;
  protected static _prefix?: string;

  public static  get controllerName(): string {
    return this._controllerName ?? "Unnamed Base Controller";
  }

  public static set controllerName(value: string) {
    this._controllerName = value;
  }

  public static get prefix(): string {
    return this._prefix ?? "";
  }

  public static set prefix(value: string) {
    this._prefix = value;
  }
  public get router(): Router | undefined {
    return this._router;
  }
  public set router(value: Router | undefined) {
    this._router = value;
  }

  constructor() {
    this._router = Router();
  }

  protected static _context: CoreServer;
  static getContext(): CoreServer {
    if (this._context == undefined ) {
      this._context = new CoreServer;
    }
    return this._context;
  }
}

export {
  BaseController,
  WithControllerMethod
};