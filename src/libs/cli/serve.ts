import path from 'path';
import { CoreServer } from '../mvc/server';

// Start importing controllers
import TodoController from '../../apps/todos/todo.controller';
import UserController from '../../apps/users/users.controller';


const server = new CoreServer;

// const controller = new TodoController();

server.app.use(path.join('/', TodoController.prefix), TodoController.getContext().router);
server.app.use(path.join('/', UserController.prefix), UserController.getContext().router);
server.start();

console.log('start controller');


