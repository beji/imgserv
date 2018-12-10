import React from "react";
import { BrowserRouter } from "react-router-dom";
import renderer from "react-test-renderer";
import App from ".";

test("App is rendered correctly", () => {
    const component = renderer.create(<BrowserRouter><App /></BrowserRouter>);
    const tree = component.toJSON();
    expect(tree).toMatchSnapshot();
});
