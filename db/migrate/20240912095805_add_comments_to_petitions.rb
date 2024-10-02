class AddCommentsToPetitions < ActiveRecord::Migration[7.1]
  def change
    add_column :petitions, :comments, :text
  end
end
