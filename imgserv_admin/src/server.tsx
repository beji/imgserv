import { IncomingMessage, ServerResponse } from "http";

export const htmlhead = `<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Imgserv_admin</title>
</head>
<body>
<div id="content">`;

export const hmtlfoot = (bundlepaths: string[]) => `</div>${bundlepaths.map((bundlepath) => `<script src="/assets/${bundlepath}"></script>`).join("")}</body></html>`;

export interface IClientStats {
    assetsByChunkName: {
        ["vendors~main"]?: string | string[],
        main?: string | string[],
    };
}
export interface ICombinedStats {
    clientStats: IClientStats;
}

export const isClientStats = (stats: ICombinedStats | IClientStats): stats is IClientStats => {
    return (stats as IClientStats).assetsByChunkName !== undefined;
};

export const getJsAssets = (stats: ICombinedStats | IClientStats): any => {
    const baseObject = isClientStats(stats) ? stats : stats.clientStats;

    return [baseObject.assetsByChunkName["vendors~main"], baseObject.assetsByChunkName.main]
        .filter((v) => typeof v !== "undefined").reduce((acc: Array<string | undefined>, elem) => {
            if (Array.isArray(elem)) {
                return acc.concat(elem);
            }
            return acc.concat([elem]);
        }, []);
};

export default function serverRenderer(stats: ICombinedStats | IClientStats) {

    const jsAssets = getJsAssets(stats);

    return (req: IncomingMessage, res: ServerResponse) => {
        res.writeHead(200, {
            "Content-Type": "text/html",
        });
        res.write(htmlhead);

        return res.end(hmtlfoot(jsAssets));
    };
}
