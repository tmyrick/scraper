desc 'send daily email'
task send_daily_email: :environment do
  DailyChangesMailer.daily_changes_email("rmcsharry@gmail.com").deliver!
end