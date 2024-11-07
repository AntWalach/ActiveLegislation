class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :petition
  scope :unread, -> { where(read: false) }
end
