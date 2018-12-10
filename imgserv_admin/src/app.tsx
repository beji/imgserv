import GlobalStyle from "components/GlobalStyle";
import React from "react";
import { render } from "react-dom";
import { BrowserRouter, Route } from "react-router-dom";
import { ThemeProvider } from "styled-components";
import ImagePage from "./pages/Image";
import TestPage from "./pages/Test";
import theme from "./theme";

render(
    <ThemeProvider theme={theme}>
        <React.Fragment>
            <GlobalStyle />
            <BrowserRouter>
                <React.Fragment>
                    <Route exact={true} path="/" component={TestPage} />
                    <Route path="/i/:image" component={ImagePage} />
                </React.Fragment>
            </BrowserRouter>
        </React.Fragment>
    </ThemeProvider>
    , document.getElementById("content"));

if (module.hot) {
    module.hot.accept();
}
