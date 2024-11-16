// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

import "jquery"
import "jquery_ujs"
import 'bootstrap'
import 'chosen-jquery'
import 'flatpickr'
import "trix"
import "@rails/actiontext"


document.addEventListener('DOMContentLoaded', function() {
    const increaseFontButton = document.getElementById('increase-font');
    const decreaseFontButton = document.getElementById('decrease-font');
    const resetFontButton = document.getElementById('reset-font');
    const body = document.body;
  
    // Pobierz aktualny rozmiar czcionki z lokalnego magazynu lub ustaw domyślny
    let fontSize = localStorage.getItem('fontSize') || 100;
    body.style.fontSize = fontSize + '%';
  
    increaseFontButton.addEventListener('click', function(e) {
      e.preventDefault();
      if (fontSize < 150) { // Ustaw maksymalny rozmiar czcionki
        fontSize = parseInt(fontSize) + 10;
        body.style.fontSize = fontSize + '%';
        localStorage.setItem('fontSize', fontSize);
      }
    });
  
    decreaseFontButton.addEventListener('click', function(e) {
      e.preventDefault();
      if (fontSize > 70) { // Ustaw minimalny rozmiar czcionki
        fontSize = parseInt(fontSize) - 10;
        body.style.fontSize = fontSize + '%';
        localStorage.setItem('fontSize', fontSize);
      }
    });
  
    resetFontButton.addEventListener('click', function(e) {
      e.preventDefault();
      fontSize = 100;
      body.style.fontSize = fontSize + '%';
      localStorage.setItem('fontSize', fontSize);
    });
  });


  const toggleContrastButton = document.getElementById('toggle-contrast');

// Sprawdź, czy tryb wysokiego kontrastu jest włączony
let highContrast = localStorage.getItem('highContrast') === 'true';
if (highContrast) {
  body.classList.add('high-contrast');
}

toggleContrastButton.addEventListener('click', function(e) {
  e.preventDefault();
  highContrast = !highContrast;
  if (highContrast) {
    body.classList.add('high-contrast');
  } else {
    body.classList.remove('high-contrast');
  }
  localStorage.setItem('highContrast', highContrast);
});
