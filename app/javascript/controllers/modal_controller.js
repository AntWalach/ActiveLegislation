import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
    static targets = ["modal", "pdfViewer"];

    connect() {
        console.log("Modal controller connected");
    }

    open(event) {
        event.preventDefault();
        const pdfUrl = event.currentTarget.dataset.pdfUrl;
        const userId = event.currentTarget.dataset.userId;
        console.log("userID:", userId)
        // Ustaw URL PDF w iframe
        const iframe = document.getElementById("pdfViewer");
        iframe.src = pdfUrl;

        // Zaktualizuj linki weryfikacji i odrzucenia
        const verifyButton = document.querySelector(".modal-footer .btn-success");
        const rejectButton = document.querySelector(".modal-footer .btn-danger");

        // Zakładając, że linki to np. "/admin/users/:id/verify" i "/admin/users/:id/reject"
        verifyButton.setAttribute("formaction", `/admin/users/${userId}/verify`);
        rejectButton.setAttribute("formaction", `/admin/users/${userId}/reject`);

        // Otwórz modal
        const modal = new bootstrap.Modal(document.getElementById("pdfModal"));
        modal.show();
    }
}
