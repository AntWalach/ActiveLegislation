import { Controller } from "@hotwired/stimulus"

var Polish = {
  weekdays: {
    shorthand: ["Niedz.", "pon.", "wt.", "śr.", "czw.", "pt.", "sob."],
    longhand: [
      "Niedziela",
      "Poniedziałek",
      "Wtorek",
      "Środa",
      "Czwartek",
      "Piątek",
      "Sobota",
    ],
  },
  months: {
    shorthand: [
      "Sty",
      "Lut",
      "Mar",
      "Kwi",
      "Maj",
      "Cze",
      "Lip",
      "Sie",
      "Wrz",
      "Paź",
      "Lis",
      "Gru",
    ],
    longhand: [
      "Styczeń",
      "Luty",
      "Marzec",
      "Kwiecień",
      "Maj",
      "Czerwiec",
      "Lipiec",
      "Sierpień",
      "Wrzesień",
      "Październik",
      "Listopad",
      "Grudzień",
    ],
  },
  rangeSeparator: " do ",
  weekAbbreviation: "tydz.",
  scrollTitle: "Przewiń, aby zwiększyć",
  toggleTitle: "Kliknij, aby przełączyć",
  firstDayOfWeek: 1,
  time_24hr: true,
  ordinal: function () {
      return ".";
  },
};

export default class extends Controller {
  connect() {
    console.log("flatpickr_controller connected");
   
    let serviceDates = [];

    if (this.element.dataset.dates) {
      try {
        serviceDates = JSON.parse(this.element.dataset.dates);
      } catch (error) {
        console.error("Invalid JSON in data-dates:", error);
        console.log("Data-dates value:", this.element.dataset.dates);
      }
    }

    if($(this.element).hasClass("datepicker")){
        flatpickr(this.element,{
          locale: Polish,
        });
    }

    if ($(this.element).hasClass("inline-datepicker")) {
      flatpickr(this.element, {
        locale: Polish,
        inline: true,
        onDayCreate: function (dObj, dStr, fp, dayElem) {
          var previousDay = new Date(dayElem.dateObj);
          previousDay.setDate(previousDay.getDate() + 1);

          if (serviceDates.includes(previousDay.toISOString().split('T')[0])) {
            dayElem.classList.add('service-day');
          }
        },
        onChange: function(selectedDates, dateStr, instance) {
          //window.location.href = `/services`;
          window.location.href = `/services?q[date_eq]=${dateStr}`;
        }
      });
    }

    if($(this.element).hasClass("datetimepicker")){
        flatpickr(this.element, {
            enableTime: true,
            locale: Polish
        });
    }

    if($(this.element).hasClass("timepicker")){
        flatpickr(this.element, {
          enableTime: true,
          noCalendar: true,
          dateFormat: "H:i",
          time_24hr: true,
          minuteIncrement: 15,
          locale: Polish,
          allowInput: true
        });
    }
  }


  calculateReservationCost(e){
    var starts_at = $('.starts_at').val();
    var ends_at = $('.ends_at').val();
    var office_id = $('.office').val();
    // console.log(office_id)
    var date = $('.date').val();
    // console.log(date)

    $.ajax({
      url: "/offices/" + office_id  + "/calculate_cost",
      type: 'POST',
      dataType: 'script',
      data: {
        starts_at: starts_at,
        ends_at: ends_at,
        date: date
      }
    });

  }
}
