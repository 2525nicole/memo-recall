import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["input", "counter"];

  connect() {
    this.updateCounter();
  }

  updateCounter() {
    const inputLength = this.inputTarget.value.length;
    const maxLength = this.inputTarget.dataset.maxLength;
    this.counterTarget.innerText = `現在 ${inputLength}/${maxLength} 文字入力しています`;

    if (inputLength > maxLength) {
      this.counterTarget.classList.add("text-red-500");
    } else {
      this.counterTarget.classList.remove("text-red-500");
    }
  }
}
