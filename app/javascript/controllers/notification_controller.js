import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["dropdown"]

  toggle(event) {
    event.preventDefault()
    this.dropdownTarget.classList.toggle('visible')
  }

  hideDropdown(event) {
    if (!this.element.contains(event.target)) {
      this.dropdownTarget.classList.remove('visible')
    }
  }
}