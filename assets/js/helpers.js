/**
 * A shorthand for `document.querySelectorAll`.
 * @type {Function}
 */
export const qsAll = document.querySelectorAll.bind(document);

/**
 * Runs the given callback as soon as the whole document is loaded
 * and DOM is ready for manipulation.
 *
 * @param {Function} callback
 */
export function onDocumentReady(callback) {
  const observer = new MutationObserver((mutationsList, observer) => {
    const targetNode = document.body;

    if (targetNode.contains(document.body)) {
      callback();
      observer.disconnect();
    }
  });

  observer.observe(document.documentElement, {
    childList: true,
    subtree: true,
  });
}
