import App from "components/App";
import Button from "components/Button";
import Content from "components/Content";
import Image from "components/Image";
import Navbar from "components/Navbar";
import NavbarHeadline from "components/Navbar/headline";
import React from "react";
import { Link } from "react-router-dom";

interface IPageProps {
    title: string;
}

class Page extends React.Component<IPageProps> {
    public render() {
        return (
            <App>
                <Navbar>
                    <NavbarHeadline>{this.props.title}</NavbarHeadline>
                </Navbar>
                <Content>
                    <Button>Test</Button>
                    {this.props.children}
                </Content>
            </App>
        );
    }
}

export default Page;
