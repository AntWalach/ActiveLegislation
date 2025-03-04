# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"

pin_all_from "app/javascript/controllers", under: "controllers"
pin_all_from "app/javascript/addons", under: "addons"

pin "jquery", to: "jquery.min.js", preload: true
pin "jquery_ujs", to: "jquery_ujs.js", preload: true
pin "bootstrap", to: "bootstrap.min.js", preload: true
pin "@popperjs/core", to: "popper.js", preload: true

pin "flatpickr", to: "flatpickr.js"
pin "chosen-jquery", to: "chosen-jquery.js"
pin "trix"
pin "@rails/actiontext", to: "actiontext.esm.js"
pin "apexcharts" # @4.1.0
