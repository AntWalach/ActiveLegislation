class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :petition, optional: true
  belongs_to :official_comment, optional: true

  scope :unread, -> { where(read: false) }

  validates :message, presence: true

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

  def self.notify_comment(user, petition, comment)
    Notification.create(
      user: user,
      petition: petition,
      message: "Nowy komentarz do Twojej petycji '#{petition.title}': #{comment}"
    )
  end

  def self.notify_forwarded(user, petition)
    message = "Twoja petycja '#{petition.title}' została przekazana do rozpatrzenia."
    Notification.create(user: user, message: message)
    # Optionally, send an email or other notification mechanisms here
  end

  def self.notify_comment(user, petition, comment)
    Notification.create(
      user: user,
      petition: petition,
      official_comment: comment,
      message: "Nowy komentarz do Twojej petycji '#{petition.title}': #{comment.content}"
    )
  end

  def self.notify_supplement_required(user, petition, comment)
    Notification.create(
      user: user,
      petition: petition,
      official_comment: comment,
      message: "Twoja petycja '#{petition.title}' wymaga uzupełnienia. Komentarz: #{comment.content}"
    )
  end

  def self.notify_response(user, petition, comment)
    Notification.create(
      user: user,
      petition: petition,
      official_comment: comment,
      message: "Twoja petycja '#{petition.title}' otrzymała odpowiedź. Komentarz: #{comment.content}"
    )
  end

  def self.send_acknowledgment(user, petition)
    # Implementacja wysyłki e-maila z potwierdzeniem
    #UserMailer.petition_acknowledgment(user, petition).deliver_later
  end


  def self.notify_upcoming_deadline(user, petition, deadline)
    Notification.create(
      user: user,
      petition: petition,
      message: "Termin odpowiedzi na Twoją petycję '#{petition.title}' zbliża się: #{deadline.strftime('%d-%m-%Y')}."
    )
  end

  # Powiadomienie o przekroczonym terminie
  def self.notify_missed_deadline(user, petition, deadline)
    Notification.create(
      user: user,
      petition: petition,
      message: "Przekroczono termin odpowiedzi na Twoją petycję '#{petition.title}': #{deadline.strftime('%d-%m-%Y')}."
    )
  end

  # Powiadomienie o rejestracji petycji
  def self.notify_registration(user, petition)
    Notification.create(
      user: user,
      petition: petition,
      message: "Twoja petycja '#{petition.title}' została zarejestrowana w systemie."
    )
  end

  # Powiadomienie o braku wymaganych dokumentów
  def self.notify_missing_documents(user, petition, comments)
    Notification.create(
      user: user,
      petition: petition,
      message: "Twoja petycja '#{petition.title}' wymaga uzupełnienia dokumentów. Komentarz: #{comments}."
    )
  end

  # Powiadomienie o historii zmian statusu
  def self.notify_status_change(user, petition, previous_status, new_status)
    Notification.create(
      user: user,
      petition: petition,
      message: "Status Twojej petycji '#{petition.title}' zmienił się z '#{previous_status}' na '#{new_status}'."
    )
  end

  # Powiadomienie dla urzędnika o nowej przypisanej petycji
  def self.notify_new_assignment(official, petition)
    Notification.create(
      user: official,
      petition: petition,
      message: "Nowa petycja '#{petition.title}' została przypisana do Ciebie."
    )
  end
end
