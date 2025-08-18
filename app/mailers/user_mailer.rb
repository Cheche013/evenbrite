class UserMailer < ApplicationMailer
  default from: "noreply@eventbrite-like.app"

  def welcome_email
    @user = params[:user]
    mail(to: @user.email, subject: "Bienvenue sur Eventbrite-like 🎉")
  end
end
