import React from "react";
import styled from "styled-components";
import { BASEVARS } from "theme";

const Button = styled.button`
    background-color: ${(props) => props.theme.colors[1]};
    border: 1px solid ${(props) => props.theme.colors[BASEVARS.DARKEST_COLOR]};
    &:hover{
        background-color: ${(props) => props.theme.colors[7]};
        color: ${(props) => props.theme.colors[1]};
    }
`;

export default Button;
