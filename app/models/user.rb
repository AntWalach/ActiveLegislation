require 'openssl'
class User < ApplicationRecord
  has_many :petitions, dependent: :destroy
  has_many :bills, dependent: :destroy
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  after_create :auto_set_role

  ROLES = {
  "A" => "admin",
  "S" => "standard"
  }

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
  
  def generate_keys!
    rsa_key = OpenSSL::PKey::RSA.new(2048)
    self.public_key = rsa_key.public_key.to_pem
    save!
    rsa_key.to_pem # Zwracamy klucz prywatny, który może być zapisany lokalnie
  end

end
