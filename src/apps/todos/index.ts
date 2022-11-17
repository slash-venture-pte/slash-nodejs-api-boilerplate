import 'module-alias/register';
import * as controller from './todo.controller';

console.log('testr');

export {
  controller
};

export const handler = () => {
  return {};
}