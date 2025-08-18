class User < ApplicationRecord
  # Associations
  has_many :attendances, dependent: :destroy
  has_many :events_attended, through: :attendances, source: :event

  has_many :organized_events, class_name: "Event",
                              foreign_key: "admin_id",
                              inverse_of: :admin,
                              dependent: :destroy

  # Validations
  validates :email, presence: true, uniqueness: true,
                    format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :encrypted_password, presence: true
  validates :first_name, length: { maximum: 50 }, allow_blank: true
  validates :last_name,  length: { maximum: 50 }, allow_blank: true
  validates :description, length: { maximum: 1000 }, allow_blank: true

  # Mailer: bienvenue à la création
  after_create_commit :send_welcome_email

  private

  def send_welcome_email
    UserMailer.with(user: self).welcome_email.deliver_later
  end
end

