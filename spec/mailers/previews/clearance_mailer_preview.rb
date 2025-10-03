# Preview all emails at http://localhost:3000/rails/mailers/clearance_mailer
class ClearanceMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/clearance_mailer/change_password
  def change_password
    user = User.where.not(confirmation_token: nil).first || FactoryBot.create(:user)
    user.forgot_password! unless user.confirmation_token?

    ClearanceMailer.change_password(user)
  end

end
