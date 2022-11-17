import express, { Express, Request, Response, Router } from 'express';
import dotenv from 'dotenv';
import * as http from "http";
import bodyParser from "body-parser";

dotenv.config();

class CoreRouter {
    
}

class CoreServer {
  private readonly _app: Express;
  private readonly _router: Router;

    get app(): Express {
        return this._app;
    }
    get router(): Router {
        return this._router;
    }

    private _server!: http.Server;

    get server(): http.Server {
        return this._server;
    }

    constructor() {
        this._app = express();
        this._router = Router();

        this._app.set("port", process.env.PORT || 3000);

        this.configureMiddleware();
    }

    public configureMiddleware() {
        // Required for POST requests
        this._app.use(bodyParser.json());
        this._app.use(bodyParser.urlencoded({ extended: true }));

        // CORS
        this.app.use(function (req, res, next) {
            res.setHeader("Access-Control-Allow-Origin", "*");
            res.setHeader("Access-Control-Allow-Credentials", "true");
            res.setHeader("Access-Control-Allow-Methods", "GET,HEAD,OPTIONS,POST,PUT");
            res.setHeader("Access-Control-Allow-Headers", "Access-Control-Allow-Origin,Access-Control-Allow-Headers, Origin,Accept, X-Requested-With, Content-Type, Access-Control-Request-Method, Access-Control-Request-Headers,Authorization");
            next();
        });
    }

    public start() {
        // this._app.use(this._router);
        this._server = this._app.listen(this._app.get("port"), () => {
            console.log("🚀 Server is running on port " + this._app.get("port"));
        });
    }
}

export { CoreServer }

// export const start = (): Express => {
//   const app: Express = express();
//   const port = process.env.PORT || 5000;
  
//   app.get('/', (req: Request, res: Response) => {
//     res.send('Express + TypeScript Server');
//   });
  
//   app.listen(port, () => {
//     console.log(`⚡️[server]: Server is running at https://localhost:${port}`);
//   });

//   return app;
// };