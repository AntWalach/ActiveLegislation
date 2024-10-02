class AddMoreFieldsToPetitions < ActiveRecord::Migration[7.1]
  def change
    add_column :petitions, :signature_goal, :integer
    add_column :petitions, :end_date, :date
    add_column :petitions, :creator_name, :string
    add_column :petitions, :public_comment, :text
    add_column :petitions, :attachment, :string
    add_column :petitions, :external_links, :text
    add_column :petitions, :priority, :string
    add_column :petitions, :gdpr_consent, :boolean, default: false
    add_column :petitions, :privacy_policy, :boolean, default: false
    add_column :petitions, :subcategory, :string
  end
end
