class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :petition

  validates :user_id, uniqueness: { scope: :petition_id, message: "możesz zagłosować na petycję tylko raz" }
end
