import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["petitionTypeSelect", "thirdPartyFields"]

  connect() {
    this.toggleThirdPartyFields()
    console.log("first")
  }

  toggleThirdPartyFields() {
    if (this.petitionTypeSelectTarget.value === 'third_party') {
      this.thirdPartyFieldsTarget.style.display = 'block'
    } else {
      this.thirdPartyFieldsTarget.style.display = 'none'
    }
  }
}
