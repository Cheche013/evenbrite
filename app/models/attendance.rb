class Attendance < ApplicationRecord
  # Associations
  belongs_to :user
  belongs_to :event

  # Validations (stripe id peut être vide au moment de la création, selon le flux de paiement de mercredi)
  validates :stripe_customer_id, length: { maximum: 191 }, allow_blank: true

  # Mailer: notifier l'admin quand quelqu'un rejoint l'événement
  after_create_commit :notify_event_creator

  private

  def notify_event_creator
    AttendanceMailer.with(attendance: self).new_attendee_email.deliver_later
  end
end
