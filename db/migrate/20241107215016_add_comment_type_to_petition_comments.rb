class AddCommentTypeToPetitionComments < ActiveRecord::Migration[7.1]
  def change
    add_column :petition_comments, :comment_type, :string
  end
end
