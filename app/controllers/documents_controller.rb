class DocumentsController < ApplicationController
    def generate_verification_document
        registration_data = params.require(:user).permit(:first_name, :last_name, :pesel, :address, :postal_code, :city)
      
        if registration_data.values.any?(&:blank?)
            Rails.logger.debug "Niekompletne dane: #{registration_data.inspect}"
            render json: { error: "Wszystkie pola muszą być wypełnione, aby wygenerować dokument." }, status: :unprocessable_entity
            return
        end
      
        pdf = Prawn::Document.new
        pdf.text "Wniosek o weryfikacje tozsamosci"
        pdf.text "Imie: #{registration_data[:first_name]}"
        pdf.text "Nazwisko: #{registration_data[:last_name]}"
        pdf.text "PESEL: #{registration_data[:pesel]}"
        pdf.text "Adres: #{registration_data[:address]}, #{registration_data[:postal_code]} #{registration_data[:city]}"
      
        Rails.logger.debug "PDF wygenerowany poprawnie"
      
        send_data pdf.render, filename: "wniosek_weryfikacyjny.pdf", type: "application/pdf", disposition: "attachment"
      end
      
  end