import React from "react";
import { Link } from "react-router-dom";

class App extends React.Component {
    public render() {
        return (
            <React.Fragment>
                {this.props.children}
            </React.Fragment>
        );
    }
}

export default App;
