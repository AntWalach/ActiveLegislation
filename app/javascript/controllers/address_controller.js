// app/javascript/controllers/address_controller.js
import { Controller } from "stimulus";

export default class extends Controller {
  static targets = [
    "residenceStreet",
    "residenceCity",
    "residenceZipCode",
    "addressStreet",
    "addressCity",
    "addressZipCode",
    "correspondenceFields",
    "sameAddressCheckbox"
  ];

  connect() {
    this.toggle();
  }

  toggle() {
    if (this.sameAddressCheckboxTarget.checked) {
      this.copyAddress();
      this.correspondenceFieldsTarget.style.display = "none";
      this.disableCorrespondenceFields();
    } else {
      this.correspondenceFieldsTarget.style.display = "block";
      this.enableCorrespondenceFields();
    }
  }

  copyAddress() {
    this.addressStreetTarget.value = this.residenceStreetTarget.value;
    this.addressCityTarget.value = this.residenceCityTarget.value;
    this.addressZipCodeTarget.value = this.residenceZipCodeTarget.value;
  }

  disableCorrespondenceFields() {
    this.addressStreetTarget.disabled = true;
    this.addressCityTarget.disabled = true;
    this.addressZipCodeTarget.disabled = true;
  }

  enableCorrespondenceFields() {
    this.addressStreetTarget.disabled = false;
    this.addressCityTarget.disabled = false;
    this.addressZipCodeTarget.disabled = false;
  }

  updateAddress() {
    if (this.sameAddressCheckboxTarget.checked) {
      this.copyAddress();
    }
  }
}
