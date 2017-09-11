# README

* Versions
Rails 5.1.3
Ruby 2.1.4
Postgres 9.5.2

* Configuration
The solution uses the env gem to manage ENV vars.
Please populate the amazon keys in the .env_COMPLETE_ME file in the root directory and then rename it to .env
You will need to run the usual Rails commands to setup the database: db:create, db:migrate

* Problems
1 When I tried to scrape the best seller rank by using the product's url (amazon_url in the Product model) amazon returned an error with this message in the HTML:

"To discuss automated access to Amazon data please contact api-services-support ..."

I have run out of time to investigate how to get around this blocking issue. You can see in the code (line 57 of the product model) that I initially thought SalesRank was returned by the amazon api itself, but it seems this number is relative to the search results itself and not the same as "Best Seller Rank" that you see on the Product Details section. Hence why line 57 is commented out and I tried to scrape the value instead.

2 I ran out of time and was unable to do the inventory check by adding product to cart.

3 Scraping the count of the number of reviews seemed the only way to get that number. I've never done web scraping before, so am not sure how reliable this code would be. I would need time to test more products and also make the code more resilient (as I find it hard to believe the HTML is always consistent on the reviews page).

* Daily product check
The project uses the whenever gem to schedule the daily task that refreshes product data. 

This gem simply creates a cron job - just type 'whenever --update-crontab' at the terminal. However, you don't need to actually run that, since the cron job will simply run the provided rake task each day at 1am. Easier to test manually...therefore to test this you can manually run "rake products:refresh" or "rails products:refresh"

* Daily email notification
You can preview what this looks like by running the app and visiting the mailer preview:
http://localhost:3000/rails/mailers/daily_changes/daily_changes_email_preview

This is also sent as a rake task using the whenever gem. However, I did not setup smtp settings (I usually use mailgun for such things), so no email will actually be sent.

