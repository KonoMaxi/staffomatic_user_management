class UserModifiedMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_modified_mailer.send_notification.subject
  #
  def send_notification email, audit_id
    @audit = Audited::Audit.find(audit_id)
    @greeting = email

    if @audit.action == "destroy"
      @change_type = "deleted"
    else
      if @audit.audited_changes.dig("archived", 1) == true
        @change_type = "archived"
      else
        @change_type = "unarchived"
      end
    end

    mail to: email
  end
end
