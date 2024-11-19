import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    console.log("dropdown controller loaded");
  }

  barsClick(e) {
    e.preventDefault();
    const elem = e.target.closest(".dropdown-bars");
    if (elem) {
      const dropdownContent = elem.closest(".dropdown").querySelector(".dropdown-content");
      dropdownContent.classList.toggle("no-opacity");
    }
  }

  hideDropdownContent(e) {
    if (
      !e.target.closest("a.dropdown-bars") &&
      !e.target.closest(".dropdown-content")
    ) {
      this.closeAllDropdowns();
    }
  }

  hideWithButton(e) {
    e.preventDefault();
    const dropdownContent = e.target.closest(".dropdown-content");
    if (dropdownContent) {
      dropdownContent.classList.add("no-opacity");
    }
  }

  closeAllDropdowns() {
    document.querySelectorAll(".dropdown-content").forEach((content) => {
      content.classList.add("no-opacity");
    });
  }
}
