import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["drawer"];

  connect() {
    console.log("Drawer controller connected!");
  }

  toggle() {
    this.drawerTarget.classList.toggle("open");
  }
}
