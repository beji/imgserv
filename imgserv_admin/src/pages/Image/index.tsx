import App from "components/App";
import Content from "components/Content";
import Image from "components/Image";
import Navbar from "components/Navbar";
import NavbarHeadline from "components/Navbar/headline";
import Page from "components/Page";
import React from "react";
import { RouteComponentProps } from "react-router";
import { getEnv } from "util/config";
import { configKeys } from "../../../config/interfaces";

interface IPageMatchParams {
    image: string;
}

interface IPageState {
    formats?: string[];
}

interface IAPIResponse {
    formats: string[];
}

interface IImagePageProps extends RouteComponentProps<IPageMatchParams> { }

class ImagePage extends React.Component<IImagePageProps, IPageState> {
    constructor(props: IImagePageProps) {
        super(props);
        this.state = {
            formats: undefined,
        };
    }
    public render() {
        const { match } = this.props;
        const { formats } = this.state;
        if (typeof formats === "undefined") {
            this.fetchFormats();
            return (
                <Page title="Loading...">
                    Loading images formats...
                </Page>
            );
        } else {
            return (
                <Page title={`Image ${match.params.image} format overview`}>
                    {formats.map((format, idx) =>
                        <React.Fragment key={idx}>
                            <p>{format}:</p>
                            <Image src={`http://localhost:4000/${format}/${match.params.image}`} />
                        </React.Fragment>,
                    )}
                </Page>
            );
        }
    }

    private fetchFormats() {
        const server = getEnv(configKeys.apiserver);
        const path = getEnv(configKeys.api_endpoint_formats);
        fetch(`${server}${path}`).then((resp) => resp.json())
            .then((json: IAPIResponse) => {
                this.setState({
                    formats: json.formats,
                });
            });
    }
}

export default ImagePage;
