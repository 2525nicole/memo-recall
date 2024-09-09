import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["input", "counter"];

  connect() {
    this.inputTargets.forEach((input) => this.updateCounter({ target: input }));
  }

  updateCounter(event) {
    const input = event.target;
    const maxLength = input.dataset.maxLength;
    const inputLength = input.value.length;

    const counter = this.counterTargets.find(
      (counter) => counter.dataset.counterFor === input.id,
    );
    if (counter) {
      counter.innerText = `現在 ${inputLength}/${maxLength} 文字入力しています`;

      if (inputLength > maxLength) {
        counter.classList.add("text-red-500");
      } else {
        counter.classList.remove("text-red-500");
      }
    }
  }
}
