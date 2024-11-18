class AddCommentTypeToOfficialComments < ActiveRecord::Migration[7.1]
  def change
    add_column :official_comments, :comment_type, :string
  end
end
