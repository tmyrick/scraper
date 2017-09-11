# Preview all emails at http://localhost:3000/rails/mailers/daily_changes
class DailyChangesPreview < ActionMailer::Preview
  def daily_changes_email_preview
    DailyChangesMailer.daily_changes_email("rmcsharry@gmail.com")
  end
end
