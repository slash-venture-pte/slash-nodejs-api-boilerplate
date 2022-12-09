import path from 'path';
import serverlessExpress from '@vendia/serverless-express';
import { BaseController } from '../mvc/controller';
import { CoreServer } from '../mvc/server';


export default (controller: typeof BaseController) => {
  const server = new CoreServer;
  server.app.use(path.join('/', controller.prefix), controller.getContext().router);
  return serverlessExpress({ app: server.app });
}


