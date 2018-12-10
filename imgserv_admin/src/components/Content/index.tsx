import React from "react";
import styled from "styled-components";

const Wrapper = styled.div`
    max-width: ${(props) => props.theme.page.maxwidth};
    margin: 0 auto;
`;

class Content extends React.Component {
    public render() {
        return (
            <Wrapper>
                {this.props.children}
            </Wrapper>
        );
    }
}

export default Content;
