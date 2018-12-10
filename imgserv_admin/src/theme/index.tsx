import { darken, lighten, rgb } from "polished";

const base = rgb(38, 38, 38);

const basecolors = [
    rgb(20, 20, 20),
    rgb(51, 51, 51),
    darken(0.2, base),
    darken(0.1, base),
    base,
    lighten(0.1, base),
    lighten(0.2, base),
    rgb(178, 178, 178),
    rgb(219, 219, 219),
];

export enum BASEVARS {
    BASE_COLOR = 4,
    TEXT_COLOR = 8,
    DARKEST_COLOR = 0,
    LIGHTEST_COLOR = basecolors.length,
}

export default {
    colors: basecolors,
    page: {
        maxwidth: "1280px",
    },
};
