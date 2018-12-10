import { configKeys, IConfig } from "./interfaces";

const config: IConfig = {
    [configKeys.express_port]: 3000,
    [configKeys.environment]: "develop",
    [configKeys.apiserver]: "http://localhost:4000",
    [configKeys.api_endpoint_formats]: "/api/formats",
};

export default config;
