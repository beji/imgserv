import { IncomingMessage, ServerResponse } from "http";
import { Socket } from "net";
import serverRenderer, { getJsAssets, hmtlfoot, htmlhead, IClientStats, ICombinedStats, isClientStats } from "./server";

describe("isClientStats", () => {

    test("should correctly detect client stats objects", () => {
        const clientStatsWithMain: IClientStats = {
            assetsByChunkName: {
                main: "bla",
            },
        };
        const clientStatsWithVendor: IClientStats = {
            assetsByChunkName: {
                "vendors~main": "bla",
            },
        };
        const clientStatsWithBoth: IClientStats = {
            assetsByChunkName: {
                "main": "bla",
                "vendors~main": "bla",
            },
        };
        expect(isClientStats(clientStatsWithMain)).toBeTruthy();
        expect(isClientStats(clientStatsWithVendor)).toBeTruthy();
        expect(isClientStats(clientStatsWithBoth)).toBeTruthy();
    });

    test("should correctly detect combined stats objects", () => {
        const stats: ICombinedStats = {
            clientStats: {
                assetsByChunkName: {
                    main: "bla",
                },
            },
        };
        expect(isClientStats(stats)).toBeFalsy();
    });

});

describe("getJsAssets", () => {
    test("it should work with combined stats", () => {
        const stats: ICombinedStats = {
            clientStats: {
                assetsByChunkName: {
                    main: "a",
                },
            },
        };
        expect(getJsAssets(stats)).toEqual(["a"]);
    });
    test("it should work with client stats", () => {
        const stats: IClientStats = {
            assetsByChunkName: {
                main: "a",
            },
        };
        expect(getJsAssets(stats)).toEqual(["a"]);
    });
    test("it should work with multiple asset definitions", () => {
        const stats: IClientStats = {
            assetsByChunkName: {
                "main": "a",
                "vendors~main": "b",
            },
        };
        expect(getJsAssets(stats)).toEqual(["b", "a"]);
    });

    test("it should work with array asset definitions", () => {
        const stats: IClientStats = {
            assetsByChunkName: {
                "main": "a",
                "vendors~main": ["b", "c"],
            },
        };
        expect(getJsAssets(stats)).toEqual(["b", "c", "a"]);
    });

    test("it should ignore undefined entries", () => {
        const stats: IClientStats = {
            assetsByChunkName: {
                "main": "a",
                "vendors~main": undefined,
            },
        };
        expect(getJsAssets(stats)).toEqual(["a"]);
    });

    test("it should work without any actual assets", () => {
        const stats: IClientStats = {
            assetsByChunkName: {},
        };
        expect(getJsAssets(stats)).toEqual([]);
    });

});

describe("serverRenderer", () => {
    test("it returns a function", () => {
        const stats: IClientStats = {
            assetsByChunkName: {
            },
        };

        const resp = serverRenderer(stats);
        expect(typeof resp).toBe("function");
    });

    test("it returns a function that modifies the given response stream", () => {
        const stats: IClientStats = {
            assetsByChunkName: {
                main: "a",
            },
        };
        const socket = new Socket();
        const respFunction = serverRenderer(stats);
        const req = new IncomingMessage(socket);
        const resp = new ServerResponse(req);
        respFunction(req, resp);
        // const out: string = (resp as any).output[0];
        expect(resp.finished).toBeTruthy();
    });
});

describe("htmlfoot", () => {
    test("it returns a correct html foot", () => {
        const foot = hmtlfoot(["a"]);
        const expected = "</div><script src=\"/assets/a\"></script></body></html>";
        expect(foot).toBe(expected);
    });
});
