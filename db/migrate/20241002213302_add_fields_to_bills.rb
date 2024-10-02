class AddFieldsToBills < ActiveRecord::Migration[7.1]
  def change
    add_column :bills, :content, :text
    add_column :bills, :justification, :text
    add_column :bills, :category, :string 
    add_column :bills, :required_signatures, :integer, default: 100000 
    add_column :bills, :signatures_deadline, :datetime  
    add_column :bills, :status, :string

    add_index :bills, :category
    add_index :bills, :status
  end
end
