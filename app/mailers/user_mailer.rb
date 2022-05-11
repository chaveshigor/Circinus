class UserMailer < ApplicationMailer
  def welcome_email
    @user = params[:user]

    mail(to: @user.email, subject: 'Bem vindo a uma nova galáxia')
  end
end
