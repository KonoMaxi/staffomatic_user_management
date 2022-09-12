# Preview all emails at http://localhost:3000/rails/mailers/user_modified
class UserModifiedPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/user_modified/send
  def send
    UserModifiedMailer.send_notification
  end

end
