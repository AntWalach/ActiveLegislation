import QRCode from "qrcode";
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["qrCode"];

  connect() {
    console.log("ShareController connected");
  }

  generateQR() {
    const petitionLink = window.location.href; // Link do petycji
    QRCode.toCanvas(this.qrCodeTarget, petitionLink, { width: 200 }, (error) => {
      if (error) {
        console.error("Error generating QR Code:", error);
      } else {
        console.log("QR Code generated!");
      }
    });
  }
}
