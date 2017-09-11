class DailyChangesMailer < ApplicationMailer
  default from: "amazono_lookup@gmail.com"

  def daily_changes_email(recipient_address)
    @changes = DailyChange.all
    mail(to: recipient_address, subject: 'Daily Product Changes Email')
  end
end
