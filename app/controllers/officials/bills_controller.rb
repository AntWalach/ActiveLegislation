class Officials::BillsController < ApplicationController
  before_action :authenticate_official!
  before_action :set_bill, only: [:show, :approve_committee, :approve_for_signatures, :start_collecting_signatures, :verify_signatures, :marshal_review, :committee_review]

  def index
    @bills = Bill.all
    case current_user.official_role
    when 'marshal'
      render 'officials/bills/marshal/index'
    when 'initial_verifier'
      render 'officials/bills/initial_verifier/index'
    when 'signature_verifier'
      render 'officials/bills/signature_verifier/index'
    when 'committee_member'
      render 'officials/bills/committee_member/index'
    else
      redirect_to root_path, alert: "Brak uprawnień do tej sekcji."
    end
  end
  
  def show
    case current_user.official_role
    when 'marshal'
      render 'officials/bills/marshal/show'
    when 'initial_verifier'
      render 'officials/bills/initial_verifier/show'
    when 'signature_verifier'
      render 'officials/bills/signature_verifier/show'
    when 'committee_member'
      render 'officials/bills/committee_member/show'
    else
      redirect_to root_path, alert: "Brak uprawnień do tej sekcji."
    end
  end

  # Zatwierdzenie komitetu przez Marszałka
  def approve_committee
    if current_user.marshal? && @bill.committee_formation?
      @bill.update(status: :submitted)
      redirect_to officials_bills_path, notice: "Komitet został zatwierdzony."
    else
      redirect_to officials_bills_path, alert: "Brak uprawnień do zatwierdzenia komitetu."
    end
  end

  # Wstępna weryfikacja przez Weryfikatora
  def approve_for_signatures
    if current_user.official_role == 'initial_verifier' && @bill.submitted?
      @bill.update(status: :under_review)
      redirect_to officials_bills_path, notice: "Projekt ustawy zatwierdzony do przeglądu."
    else
      redirect_to officials_bills_path, alert: "Brak uprawnień do zatwierdzenia."
    end
  end

  # Zmiana statusu na zbieranie podpisów
  def start_collecting_signatures
    if current_user.official_role == 'initial_verifier' && @bill.under_review?
      @bill.update(status: :collecting_signatures)
      redirect_to officials_bills_path, notice: "Zbieranie podpisów rozpoczęte."
    else
      redirect_to officials_bills_path, alert: "Brak uprawnień do rozpoczęcia zbierania podpisów."
    end
  end

  # Zatwierdzenie podpisów przez urzędnika ds. głosów
  def verify_signatures
    if current_user.official_role == 'signature_verifier' && @bill.collecting_signatures? && @bill.signatures.count >= Bill::MIN_SIGNATURES_FOR_REVIEW
      @bill.update(status: :awaiting_marshal_review)
      redirect_to officials_bills_path, notice: "Podpisy zostały zatwierdzone."
    else
      redirect_to officials_bills_path, alert: "Nie udało się zatwierdzić podpisów."
    end
  end

  # Weryfikacja Marszałka po etapie zbierania podpisów
  def marshal_review
    if current_user.marshal? && @bill.awaiting_marshal_review?
      @bill.update(status: :committee_review)
      redirect_to officials_bills_path, notice: "Wniosek przesłany do komisji."
    else
      redirect_to officials_bills_path, alert: "Brak uprawnień do przeglądu marszałka."
    end
  end

  # Przegląd komisji
  def committee_review
    if current_user.committee_member? && @bill.committee_review?
      if params[:decision] == 'approve'
        @bill.update(status: :approved)
        redirect_to officials_bills_path, notice: "Inicjatywa ustawodawcza przyjęta do procesu legislacyjnego."
      else
        @bill.update(status: :rejected)
        redirect_to officials_bills_path, alert: "Inicjatywa ustawodawcza została odrzucona."
      end
    else
      redirect_to officials_bills_path, alert: "Brak uprawnień do przeglądu komisji."
    end
  end

  private

  def set_bill
    @bill = Bill.find(params[:id])
  end


end
