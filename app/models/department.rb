class Department < ApplicationRecord
    has_many :officials, class_name: "Official", foreign_key: "department_id"
    has_many :petitions
end
