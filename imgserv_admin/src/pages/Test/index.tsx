import App from "components/App";
import Content from "components/Content";
import Image from "components/Image";
import Navbar from "components/Navbar";
import NavbarHeadline from "components/Navbar/headline";
import Page from "components/Page";
import React from "react";
import { Link } from "react-router-dom";

class TestPage extends React.Component {
    public render() {
        return (
            <Page title="Imgserv Test">
                <Link to="/i/test.jpg">
                    <Image src="http://localhost:4000/thumbnail/test.jpg" />
                </Link>
            </Page>
        );
    }
}

export default TestPage;
