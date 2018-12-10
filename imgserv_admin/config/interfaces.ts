export interface IConfig {
    [configKeys.express_port]?: number;
    [configKeys.environment]?: string;
    [configKeys.apiserver]?: string;
    [configKeys.api_endpoint_formats]?: string;
}

export const enum configKeys {
    express_port = "express_port",
    environment = "environment",
    apiserver = "apiserver",
    api_endpoint_formats = "api_endpoint_formats",
}
