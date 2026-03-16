import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["frame"];
  static values = { url: String };

  open() {
    // Load the chat only on first open (lazy)
    if (!this.frameTarget.getAttribute("src")) {
      this.frameTarget.setAttribute("src", this.urlValue);
    }
  }
}
