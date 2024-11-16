import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["formContent", "responseForm"]

  connect() {
    this.visible = false
    this.responseFormVisible = false
    this.toggleVisibility()
  }

  toggle() {
    this.visible = !this.visible
    this.toggleVisibility()
  }

  toggleVisibility() {
    this.formContentTarget.style.display = this.visible ? 'block' : 'none'
  }

  toggleResponseForm() {
    this.responseFormVisible = !this.responseFormVisible
    this.responseFormTarget.style.display = this.responseFormVisible ? 'block' : 'none'
  }
}
