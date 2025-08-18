class AttendanceMailer < ApplicationMailer
  default from: "noreply@eventbrite-like.app"

  def new_attendee_email
    @attendance = params[:attendance]
    @event = @attendance.event
    @attendee = @attendance.user
    mail(to: @event.admin.email, subject: "Nouvelle inscription à #{@event.title}")
  end
end

