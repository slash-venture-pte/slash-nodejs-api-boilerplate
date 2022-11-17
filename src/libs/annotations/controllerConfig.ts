


interface ControllerConfigProps {
  name: string,
  prefix: string,
}

function Controller({name, prefix}: ControllerConfigProps)  {
  return function <T extends { new (...args: any[]): {} }>(constructor: T) {
    const cls = class extends constructor {
      static controllerName = name;
      static prefix = prefix;
    };
    return cls;
  }
}

 

export { Controller
}