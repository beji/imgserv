import path from "path";
import TsconfigPathsPlugin from "tsconfig-paths-webpack-plugin";
import webpack, { Configuration } from "webpack";

const config: Configuration = {
    devtool: "inline-source-map",
    entry: ["./src/app.tsx", "webpack-hot-middleware/client"],
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
    name: "client",
    optimization: {
        splitChunks: {
            chunks: "all",
        },
    },
    output: {
        // filename: "bundle-[hash].js",
        filename: "bundle.js",
        path: path.join(__dirname, "..", "public"),
        publicPath: "/assets/",
    },
    plugins: [
        new webpack.HotModuleReplacementPlugin(),
    ],
    resolve: {
        extensions: [".tsx", ".ts", ".js", ".jsx"],
        plugins: [new TsconfigPathsPlugin()],
    },
    target: "web",

};

export default config;
