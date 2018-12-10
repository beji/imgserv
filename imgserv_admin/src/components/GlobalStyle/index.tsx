import { createGlobalStyle } from "styled-components";
import theme, { BASEVARS } from "theme";
import normalize from "../../normalize";

const GlobalStyle = createGlobalStyle`
    ${normalize};
    * {
        box-sizing: border-box;
        font-size: 1rem;
        color: ${theme.colors[BASEVARS.TEXT_COLOR]};
    }
    body {
        background-color: ${theme.colors[BASEVARS.BASE_COLOR]};
    }
`;

export default GlobalStyle;
