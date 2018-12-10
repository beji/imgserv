import styled from "styled-components";
import { BASEVARS } from "theme";

const Headline = styled.h1`
    color: ${(props) => props.theme.colors[BASEVARS.TEXT_COLOR]};
    padding: 0;
    margin: 0;
    font-size: 1.2rem;
`;

export default Headline;
