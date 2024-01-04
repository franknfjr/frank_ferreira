import { qsAll } from "./helpers";

export function fixBlockquotes() {
  const classes = ["warning", "info", "error", "neutral", "tip"];

  classes.forEach((element) => {
    qsAll(`blockquote h3.${element}, blockquote h4.${element}`).forEach(
      (header) => {
        header.closest("blockquote").classList.add(element);
      },
    );
  });
}
