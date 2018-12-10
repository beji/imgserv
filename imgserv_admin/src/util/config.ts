import defaultconf from "../../config/default";
import devconf from "../../config/dev";
import { configKeys, IConfig } from "../../config/interfaces";

const mergedconf: any = Object.assign({}, defaultconf, devconf);
// Object.assign.apply(Object, [{}, {a:2}, {b:3}])

const getEnv = (key: configKeys, ...configs: IConfig[]): unknown => {
    if (typeof process.env[key] !== "undefined") {
        return process.env[key];
    }
    if (typeof configs !== "undefined" && configs.length > 0) {
        const value = configs.reduce((acc: unknown, elem: IConfig) => {
            if (typeof elem[key] !== "undefined") {
                return elem[key];
            }
            return acc;
        }, undefined);
        if (typeof value !== "undefined") {
            return value;
        }
    } else if (typeof mergedconf !== "undefined" && typeof mergedconf[key] !== "undefined") {
        return mergedconf[key];
    }
    return undefined;
};

export { getEnv };
