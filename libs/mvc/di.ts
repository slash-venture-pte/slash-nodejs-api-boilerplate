
class DIContainer {
    protected static controllers: Map<string, any> = new Map<string, any>();
  public static addController<T>(name: string, controller: T) {
    if (!this.controllers.has(name)) {
      this.controllers.set(name, controller);
    }
  }

  public static getControllers (){
    return this.controllers.values;
  }
}

export {
  DIContainer
}