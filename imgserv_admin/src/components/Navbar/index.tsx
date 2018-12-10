import React from "react";
import { Link } from "react-router-dom";
import styled from "styled-components";
import { BASEVARS } from "theme";

const Header = styled.header`
    background-color: ${(props) => props.theme.colors[1]};
    border-bottom: 1px solid ${(props) => props.theme.colors[BASEVARS.DARKEST_COLOR]};
    margin-bottom: 1rem;
    padding: 0.2rem 0.5rem;
`;

class Navbar extends React.Component {
    public render() {
        return (
            <Header>
                {this.props.children}
            </Header>
        );
    }
}

export default Navbar;
