class Department < ApplicationRecord
    has_many :officials, class_name: "Official", foreign_key: "department_id"
    has_many :petitions
    has_many :shared_petition_departments, dependent: :destroy
    has_many :shared_petitions, through: :shared_petition_departments, source: :petition
end
