class Signature < ApplicationRecord
  belongs_to :user
  belongs_to :petition
  belongs_to :bill
  validates :user_id, uniqueness: { scope: :petition_id, message: "już podpisałeś tę petycję" }
  validates :digital_signature, presence: true

  def verify_signature
    public_key = OpenSSL::PKey::RSA.new(user.public_key)
    message = petition.id.to_s
    signature_bytes = Base64.decode64(digital_signature)
    public_key.verify(OpenSSL::Digest::SHA256.new, signature_bytes, message)
  end
end