import { qsAll } from "./helpers";

const BUTTON =
  '<button class="copy-button"><svg aria-hidden="true" xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0 0 24 24" width="24px" fill="currentColor"><path d="M0 0h24v24H0z" fill="none"/><path d="M16 1H4c-1.1 0-2 .9-2 2v14h2V3h12V1zm3 4H8c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h11c1.1 0 2-.9 2-2V7c0-1.1-.9-2-2-2zm0 16H8V7h11v14z"/></svg><span class="sr-only">copy</span><span aria-live="polite"></span></button>';

function showToast(message, duration = 1500) {
  const toastContainer = document.createElement("div");
  toastContainer.classList.add("toast", "show");
  toastContainer.textContent = message;
  document.body.appendChild(toastContainer);

  setTimeout(() => {
    toastContainer.classList.remove("show");
    setTimeout(() => document.body.removeChild(toastContainer), 400);
  }, duration);
}

/**
 * Initializes copy buttons.
 */
export function initialize() {
  addCopyButtons();
}

/**
 * Find pre tags, add copy buttons, copy <code> content on click.
 */
function addCopyButtons() {
  const preElements = Array.from(qsAll("pre")).filter(
    (pre) => pre.firstElementChild && pre.firstElementChild.tagName === "CODE",
  );

  preElements.forEach((pre) => pre.insertAdjacentHTML("beforeend", BUTTON));

  Array.from(qsAll(".copy-button")).forEach((button) => {
    let timeout;
    button.addEventListener("click", () => {
      timeout && clearTimeout(timeout);

      const text = Array.from(
        button.parentElement.querySelector("code").childNodes,
      )
        .filter(
          (elem) =>
            !(
              elem.tagName === "SPAN" && elem.classList.contains("unselectable")
            ),
        )
        .map((elem) => elem.textContent)
        .join("");

      navigator.clipboard.writeText(text);
      button.classList.add("clicked");

      // Show toast notification
      showToast("Copied! ✅");

      timeout = setTimeout(() => {
        button.classList.remove("clicked");
      }, 1000);
    });
  });
}
