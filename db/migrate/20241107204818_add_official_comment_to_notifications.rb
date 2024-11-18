class AddOfficialCommentToNotifications < ActiveRecord::Migration[7.1]
  def change
    add_reference :notifications, :official_comment, foreign_key: true
  end
end
