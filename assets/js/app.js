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
import ParseHTML from "./parse-html";

let Hooks = {};
Hooks.ParseHTML = ParseHTML;
Hooks.TocSpy = {
  mounted() {
    const links = Array.from(this.el.querySelectorAll(".ff-toc-link"));
    if (!links.length) return;

    const targets = links
      .map((a) => document.getElementById(a.dataset.target))
      .filter(Boolean);
    if (!targets.length) return;

    const setActive = (id) => {
      links.forEach((a) =>
        a.classList.toggle("is-active", a.dataset.target === id),
      );
      targets.forEach((h) =>
        h.classList.toggle("is-current", h.id === id),
      );
    };

    // Track which sections are currently above a line ~30% from the top.
    // The last one that's crossed the line is the "current" section.
    const visible = new Map();

    this.observer = new IntersectionObserver(
      (entries) => {
        entries.forEach((e) => {
          if (e.isIntersecting) visible.set(e.target.id, e.target);
          else visible.delete(e.target.id);
        });

        if (visible.size > 0) {
          // Pick the one closest to the top of the viewport
          const sorted = Array.from(visible.values()).sort(
            (a, b) => a.getBoundingClientRect().top - b.getBoundingClientRect().top,
          );
          setActive(sorted[0].id);
        } else {
          // Nothing in the band — fall back to the heading just above the viewport top
          let current = targets[0];
          for (const h of targets) {
            if (h.getBoundingClientRect().top < 120) current = h;
          }
          setActive(current.id);
        }
      },
      { rootMargin: "-80px 0px -65% 0px", threshold: 0 },
    );

    targets.forEach((t) => this.observer.observe(t));

    // Click handler: mark active immediately, don't wait for scroll
    links.forEach((a) =>
      a.addEventListener("click", () => setActive(a.dataset.target)),
    );
  },
  destroyed() {
    this.observer?.disconnect();
  },
};

Hooks.Utterances = {
  mounted() {
    this.el.style.opacity = "0";
    this.el.style.transition = "opacity 0.3s ease";

    const theme = document.documentElement.classList.contains("dark")
      ? "github-dark"
      : "github-light";
    const script = document.createElement("script");
    script.src = "https://utteranc.es/client.js";
    script.setAttribute("repo", "franknfjr/frank_ferreira");
    script.setAttribute("issue-term", "pathname");
    script.setAttribute("theme", theme);
    script.setAttribute("crossorigin", "anonymous");
    script.async = true;
    this.el.appendChild(script);

    const observer = new MutationObserver(() => {
      const iframe = this.el.querySelector(".utterances");
      if (iframe) {
        this.el.style.opacity = "1";
        observer.disconnect();
      }
    });
    observer.observe(this.el, { childList: true, subtree: true });
  },
};

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
  hooks: Hooks,
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

window.addEventListener("ff:copy", (e) => {
  const url = (e.detail && e.detail.url) || window.location.href;
  navigator.clipboard?.writeText(url);
});

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
