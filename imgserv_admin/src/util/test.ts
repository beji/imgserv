import { configKeys, IConfig } from "../../config/interfaces";
import { getEnv } from "./config";

describe("getEnv", () => {
    const OLD_ENV = process.env;
    beforeEach(() => {
        jest.resetModules(); // this is important
        process.env = { ...OLD_ENV };
        delete process.env[configKeys.express_port];
    });

    afterEach(() => {
        process.env = OLD_ENV;
    });

    test("should return undefined on non existing keys", () => {
        const resp = getEnv(configKeys.express_port, {}, { environment: "debug" });
        expect(typeof resp).toBe("undefined");
    });

    test("should return a value from the default configs if no configs are passed", () => {
        const resp = getEnv(configKeys.express_port);
        expect(resp).toBe(3000);
    });

    test("should a value from process.env if that exists", () => {
        process.env[configKeys.express_port] = "5555";
        const resp = getEnv(configKeys.express_port);
        expect(resp).toBe("5555");
    });

    test("should return a value from the passed configs", () => {
        const resp = getEnv(configKeys.express_port, { express_port: 4000 }, { express_port: 3000 });
        expect(resp).toBe(3000);
    });

});
