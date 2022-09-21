abstract class BaseResponse {
  public statusCode : number | undefined;
  public response : Object | undefined;
}

class ControllerResponse extends BaseResponse {

}

export {
  BaseResponse,
  ControllerResponse,
}