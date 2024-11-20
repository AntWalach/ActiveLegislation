require 'openssl'
class User < ApplicationRecord

  self.inheritance_column = :type
  has_many :petitions, dependent: :destroy
  has_many :bills, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :committee_members, dependent: :destroy
  has_many :bill_committees, through: :committee_members
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  attr_accessor :terms_of_service, :consent_data_processing, :information_acknowledgment

  validates :terms_of_service, acceptance: { message: "Musisz zaakceptować regulamin, aby się zarejestrować." }
  validates :consent_data_processing, acceptance: { message: "Musisz wyrazić zgodę na przetwarzanie danych osobowych." }
  validates :information_acknowledgment, acceptance: { message: "Musisz zapoznać się z treścią powyższych informacji." }

  after_create :auto_set_role

  has_one_attached :avatar do |img|
    img.variant :medium, resize_to_fit: [250, 250]
    img.variant :thumb, resize_to_fit: [50, 50]
  end

  ROLES = {
  "A" => "admin",
  "S" => "standard",
  "O" => "official"
  }


  def avatar_url(v=:medium)
    avatar.attached? ? rails_representation_url(avatar.variant(v), only_path: true) : "sessions_avatar.png"
  end

  def auto_set_role
    default_role = case type
                   when "Admin" then "A"
                   when "StandardUser" then "S"
                   when "Official" then "O"
                   else nil
                   end
    update_column(:role_mask, default_role) if default_role && role_mask.nil?
  end

  def roles
    return [] unless role_mask
    role_mask&.chars.map do |letter|
      ROLES[letter.upcase]
    end.compact
  end

  def set_role(role)
    self.roles = [role]
    self.save
  end
  
  def roles=(roles)
    self.role_mask = roles.map{|role| ROLES.invert[role] }.compact.join
  end

  def auto_set_role
    self.update_column(:role_mask, "S") unless self.role_mask.present?
  end

  def is?(role)
    roles.include?(role.to_s)
  end
  

end
