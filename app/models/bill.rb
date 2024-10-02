class Bill < ApplicationRecord
  belongs_to :user

  has_rich_text :content # Treść ustawy
  has_rich_text :justification # Uzasadnienie ustawy
end
