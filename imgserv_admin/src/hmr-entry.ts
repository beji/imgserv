/* tslint:disable:no-var-requires */

import express from "express";
import http from "http";
import morgan from "morgan";
import path from "path";
import { ICompiler } from "webpack";
import { configKeys } from "../config/interfaces";
import clientconfig from "../webpack/client.dev";
import serverconfig from "../webpack/server.dev";
import { getEnv } from "./util/config";

const app = express();
const server = new http.Server(app);

app.use(morgan("combined"));

if (process.env.NODE_ENV !== "production") {

    const webpack = require("webpack");
    const webpackDevMiddleware = require("webpack-dev-middleware");
    const webpackHotMiddleware = require("webpack-hot-middleware");
    const webpackHotServerMiddleware = require("webpack-hot-server-middleware");
    const compiler = webpack([clientconfig, serverconfig]);

    interface ICompilerWithName extends ICompiler {
        name: string;
    }

    app.use(webpackDevMiddleware(compiler, {
        hot: true,
        publicPath: "/assets/",
        serverSideRender: false,
    }));

    app.use(webpackHotMiddleware(compiler.compilers.find((c: ICompiler) => (c as ICompilerWithName).name === "client")));

    app.use(webpackHotServerMiddleware(compiler));

    app.use((req, res, next) => {
        if (req.url === "/favicon.ico") {
            res.writeHead(200, { "Content-Type": "image/x-icon" });
            res.end("");
        } else {
            next();
        }
    });
} else {
    const serverRenderer = require("../dist/server").default;
    const stats = require("../public/stats.json");
    app.use("/assets/", express.static(path.join(__dirname, "../public")));
    app.use(serverRenderer(stats));
    app.use((req, res, next) => {
        if (req.url === "/favicon.ico") {
            res.writeHead(200, { "Content-Type": "image/x-icon" });
            res.end("");
        } else {
            next();
        }
    });
}

const port = getEnv(configKeys.express_port);

if (typeof port === "string" || typeof port === "number") {
    server.listen(port, () => {
        console.log(`Server listening on http://localhost:${port}`);
    });
} else {
    console.error("No valid port specified in config!");
}
