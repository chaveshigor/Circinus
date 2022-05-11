# frozen_string_literal: true

module Account
  class ConfirmateAccountWorker < ApplicationWorker
    def perform(user_id)
      user = User.find(user_id)
      UserMailer.with(user: user).welcome_email.deliver_now
    end
  end
end
