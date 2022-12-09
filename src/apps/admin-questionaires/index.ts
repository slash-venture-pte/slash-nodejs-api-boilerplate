import 'module-alias/register';
import AdminQuestionairesController from './questionaires.controller';
import wrapper from '/opt/@libs/serverless/wrapper';

console.log('testr', AdminQuestionairesController, wrapper);

export const handler = wrapper(AdminQuestionairesController);