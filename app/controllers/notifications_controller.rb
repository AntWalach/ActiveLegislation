class NotificationsController < ApplicationController
  def mark_as_read
    notification = Notification.find(params[:id])
    notification.update(read: true)
    redirect_to request.referer || root_path, notice: 'Powiadomienie oznaczone jako przeczytane.'
  end

  # Metoda do powiadomienia o zgłoszeniu petycji
  def self.notify_submission(user, petition)
    Notification.create(user: user, message: "Twoja petycja '#{petition.title}' została zgłoszona do weryfikacji.")
  end

  # Metoda do powiadomienia o zatwierdzeniu petycji
  def self.notify_approval(user, petition)
    Notification.create(user: user, message: "Twoja petycja '#{petition.title}' została zatwierdzona i skierowana do przeglądu.")
  end

  # Metoda do powiadomienia o odrzuceniu petycji
  def self.notify_rejection(user, petition, comments = nil)
    message = "Twoja petycja '#{petition.title}' została odrzucona."
    message += " Komentarz: #{comments}" if comments.present?
    Notification.create(user: user, message: message)
  end

  # Metoda do powiadomienia o rozpoczęciu zbierania podpisów
  def self.notify_collecting_signatures(user, petition)
    Notification.create(user: user, message: "Twoja petycja '#{petition.title}' rozpoczęła etap zbierania podpisów.")
  end

  # Metoda do powiadomienia o zweryfikowaniu podpisów
  def self.notify_signature_verification(user, petition)
    Notification.create(user: user, message: "Podpisy pod Twoją petycją '#{petition.title}' zostały pomyślnie zweryfikowane.")
  end

  # Metoda do powiadomienia o odpowiedzi na petycję
  def self.notify_response(user, petition, comments)
    Notification.create(user: user, message: "Twoja petycja '#{petition.title}' otrzymała odpowiedź. Komentarz: #{comments}")
  end

  def self.notify_supplement_required(user, petition, comments)
    # Implementacja powiadomienia, np. wysłanie e-maila lub wiadomości w aplikacji
    # Przykład:
    Notification.create(
      user: user,
      petition: petition,
      message: "Twoja petycja wymaga uzupełnienia. Komentarz: #{comments}"
    )
  end

  def self.notify_forwarded(user, petition)
    message = "Twoja petycja '#{petition.title}' została przekazana do rozpatrzenia."
    Notification.create(user: user, message: message)
    # Optionally, send an email or other notification mechanisms here
  end
end
