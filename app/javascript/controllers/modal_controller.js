import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["modal"];

  open() {
    this.modalTarget.classList.remove("hidden");
  }

  close() {
    event.preventDefault();
    event.stopPropagation();
    this.modalTarget.classList.add("hidden");
  }

  stay(event) {
    event.stopPropagation();
  }
}
