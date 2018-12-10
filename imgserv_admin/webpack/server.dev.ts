import path from "path";
import { Configuration } from "webpack";
import nodeExternals from "webpack-node-externals";

const config: Configuration = {
    entry: "./src/server.tsx",
    externals: [nodeExternals()],
    mode: "development",
    module: {
        rules: [
            {
                enforce: "pre",
                exclude: /node_modules/,
                loader: "tslint-loader",
                options: { failOnHint: true },
                test: [/\.tsx?$/, /\.ts?$/],
            },
            {
                loader: "awesome-typescript-loader",
                test: [/\.tsx?$/, /\.ts?$/],
            },
        ],
    },
    name: "server",
    output: {
        filename: "server.js",
        libraryTarget: "commonjs2",
        path: path.join(__dirname, "..", "dist"),
    },
    resolve: {
        extensions: [".ts", ".tsx", ".js", ".jsx"],
    },
    target: "node",
};

export default config;
