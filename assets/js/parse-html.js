import { subscribe } from "@github/paste-markdown";

export default {
  mounted() {
    subscribe(this.el);
  },
};
