import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["form"];

  

  generateDocument(event) {
    event.preventDefault();
  
    const form = this.element.querySelector("form");
    const formData = new FormData(form);
  
    fetch("/documents/generate_verification_document", {
      method: "POST",
      body: formData,
      headers: {
        "X-Requested-With": "XMLHttpRequest",
      },
    })
      .then(async (response) => {
        if (response.ok) {
          console.log("Pobieranie PDF...");
          const blob = await response.blob();
          const url = window.URL.createObjectURL(blob);
          const a = document.createElement("a");
          a.href = url;
          a.download = "wniosek_weryfikacyjny.pdf";
          document.body.appendChild(a);
          a.click();
          a.remove();
          window.URL.revokeObjectURL(url);
        } else {
          const result = await response.json();
          console.error("Błąd odpowiedzi:", result.error);
          alert(result.error || "Nie udało się wygenerować dokumentu.");
        }
      })
      .catch((error) => {
        console.error("Błąd generowania dokumentu:", error);
        alert("Wystąpił błąd. Spróbuj ponownie.");
      });
  }
}
