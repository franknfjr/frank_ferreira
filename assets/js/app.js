// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html";
// Establish Phoenix Socket and LiveView configuration.
import { Socket } from "phoenix";
import { LiveSocket } from "phoenix_live_view";
import topbar from "../vendor/topbar";
import { initialize as initCopyButton } from "./copy-button";
import { onDocumentReady } from "./helpers";
import { fixBlockquotes } from "./content";

onDocumentReady(() => {
  initCopyButton();
  fixBlockquotes();
});

// let locale = Intl.DateTimeFormat().resolvedOptions().locale;
let csrfToken = document
  .querySelector("meta[name='csrf-token']")
  .getAttribute("content");
let liveSocket = new LiveSocket("/live", Socket, {
  params: { _csrf_token: csrfToken },
});

window.addEventListener("scroll", function () {
  const isBlogRoute = window.location.pathname.startsWith("/blog/");

  if (isBlogRoute) {
    const scrollProgress =
      window.scrollY / (document.body.scrollHeight - window.innerHeight);

    topbar.config({
      autoRun: false,
      barThickness: 5,
      barColors: {
        0: "rgba(26,  188, 156, .7)",
        ".5": "rgba(41,  128, 185, .7)",
        "1.0": "rgba(231, 76,  60,  .7)",
      },
      shadowBlur: 5,
      shadowColor: "rgba(0, 0, 0, .5)",
      className: "topbar",
    });

    topbar.show();
    topbar.progress(scrollProgress);
  }
});

// Show progress bar on live navigation and form submits
topbar.config({ barColors: { 0: "#fff" }, shadowColor: "rgba(0, 0, 0, .3)" });
window.addEventListener("phx:page-loading-start", (_info) => topbar.show(300));
window.addEventListener("phx:page-loading-stop", (_info) => topbar.hide());
// connect if there are any LiveViews on the page
liveSocket.connect();

window.liveSocket = liveSocket;

function darkExpected() {
  return (
    (!window.matchMedia("print").matches && localStorage.theme === "dark") ||
    (!("theme" in localStorage) &&
      window.matchMedia("(prefers-color-scheme: dark)").matches)
  );
}

function initDarkMode() {
  // On page load or when changing themes, best to add inline in `head` to avoid FOUC
  if (darkExpected()) document.documentElement.classList.add("dark");
  else document.documentElement.classList.remove("dark");
}

window.addEventListener("toogle-darkmode", (e) => {
  if (darkExpected()) localStorage.theme = "light";
  else localStorage.theme = "dark";
  initDarkMode();
});

initDarkMode();

console.log(
  `%c
 _____                _
|  ___| __ __ _ _ __ | | __
| |_ | '__/ _\` | '_ \\| |/ /
|  _|| | | (_| | | | |   <
|_|  |_|  \\__,_|_| |_|_|\\_\\
 _____                  _                _
|  ___|__ _ __ _ __ ___(_)_ __ __ _   __| | _____   __
| |_ / _ \\ '__| '__/ _ \\ | '__/ _\` | / _\` |/ _ \\ \\ / /
|  _|  __/ |  | | |  __/ | | | (_| || (_| |  __/\\ V /
|_|  \\___|_|  |_|  \\___|_|_|  \\__,_|(_)__,_|\\___|\\_/
`,
  "font-family:monospace; color: #4285f4; font-size: 14px; font-weight: bold;",
);
