import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["formContent"]

  connect() {
    this.visible = false
    this.toggleVisibility()
    console.log("toggle")
  }

  toggle() {
    this.visible = !this.visible
    this.toggleVisibility()
  }

  toggleVisibility() {
    this.formContentTarget.style.display = this.visible ? 'block' : 'none'
  }
}
