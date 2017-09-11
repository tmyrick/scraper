# README

* Configuration
The solution uses the env gem to manage ENV vars.
Please populate the amazon keys in the .env_COMPLETE_ME file in the root directory and then rename it to .env

* Problems
When I tried to scrape the best seller rank by using the product's url (amazon_url in the Product model) amazon returned an error with this message in the HTML:

"To discuss automated access to Amazon data please contact api-services-support ..."

I have run out of time to investigate how to get around this blocking issue. You can see in the code (line 57 of the product model) that I initially thought SalesRank was returned by the amazon api itself, but it seems this number is relative to the search results itself and not the same as "Best Seller Rank" that you see on the Product Details section. Hence why line 57 is commented out and I tried to scrape the value instead.

* Daily product check
The project uses the whenever gem to schedule the daily task that refreshes product data. 

This gem simply creates a cron job. You don't need to actually run that, since the cron job will simply run the provided rake task each day at 1am.

Therefore to test this you can manually run "rake products:refresh" or "rails products:refresh"

* Daily email notification
You can preview what this looks like by running the app and visiting the mailer preview:
http://localhost:3000/rails/mailers/daily_changes/daily_changes_email_preview


