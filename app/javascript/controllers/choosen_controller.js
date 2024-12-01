import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  
  initialize() {
    this.chosenReady = false;
  }

  connect() {
    if (window.jQuery && $.fn.chosen) {
      this.initializeChosen();
      console.log("Choosen conncted")
    } else {
      console.error("Chosen or jQuery not loaded.");
    }
  }

  initializeChosen() {
    $(this.element).chosen({
      allow_single_deselect: true,
      no_results_text: 'Brak elementów',
      width: '100%',
      placeholder_text_multiple: "Kliknij i Wybierz (możesz wskazać wiele)"
    });
  }
}
