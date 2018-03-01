module AmazonApi

	require 'HTTParty'
	require 'Nokogiri'
	require 'JSON'
	require 'Pry'
	require 'csv'
	PRODUCT_DETAILS = "https://www.amazon.com/dp"
	CRED_STRING = "SubscriptionId=AKIAIH7JUJT76TKM5QWA&tag=magicfishy-20&linkCode=xm2&camp=2025&creative=386001&creativeASIN="

	def self.scrape

		print "Type 'exit' when complete." + "\n"

		loop do

			print "What would you like to name your file? (please don't add extension):"
			file_name = gets.chomp + ".csv"
			break if file_name == "exit.csv"
			"\n"

			print "ASINS: "
			STDOUT.flush
			asins_array = STDIN.gets.chomp.split(/,/).map(&:to_s)

			asins_array.each do |asin|

				print "Analyzing #{asin}..."



		# ASIN = gets.chomp


				@endpoint = "#{PRODUCT_DETAILS}/#{asin}?#{CRED_STRING}#{asin}"

				page = HTTParty.get(@endpoint)
				parse_page = Nokogiri::HTML(page)
				arr = []
				title = parse_page.css('h1').text.strip

				images = parse_page.css('#altImages img').count.to_i
				brand = parse_page.css('#brand').text.strip
				reviews = parse_page.css('#acrCustomerReviewText').text.strip
				reviews = reviews.gsub!(/\D/, "")
				description = parse_page.css('#productDescription p').text.strip.to_s
				price = parse_page.css('#priceblock_ourprice').text.strip

				sns = parse_page.xpath('//span[contains(text(), "Subscribe & Save")]').count.to_i
				if sns >= 1
					sns = true
				else
					sns = false
				end

				prime = parse_page.css("#alternativeOfferEligibilityMessaging_feature_div").css(".a-icon-prime").length.to_i
				if prime == 0
					prime == false
				else
					prime == true
				end
				stars = parse_page.css(".a-icon-star").css(".a-icon-alt")[0].text.strip.chomp('out of 5 stars').strip

				bullet1 = parse_page.css('#fbExpandableSectionContent').css('li')[0].text.strip
				bullet2 = parse_page.css('#fbExpandableSectionContent').css('li')[1].text.strip
				bullet3 = parse_page.css('#fbExpandableSectionContent').css('li')[2].text.strip
				bullet4 = parse_page.css('#fbExpandableSectionContent').css('li')[3].text.strip
				bullet5 = parse_page.css('#fbExpandableSectionContent').css('li')[4].text.strip

				aplus = parse_page.at_css('#aplus') ? "true" : "false"

				offer = parse_page.xpath('//span[contains(text(), "Ships from and sold by Amazon.com")]').count.to_i
				if offer > 2
					offer = "1P"
				else
					offer = "3P"
				end

				arr.push(asin,brand,title,price,images,reviews,stars,prime,aplus,offer,sns,bullet1,bullet2,bullet3,bullet4,bullet5,description)

				rows = arr.each_slice(17)

				CSV.open("#{file_name}", "ab") do |csv|
					# IF the csv has content, don't give it headers
					if File.zero?(file_name)
						csv << ["ASIN", "Brand", "Title", "Price", "Images", "Reviews", "Stars", "Prime", "A Plus/EBC?", "Offer", "S&S?", "Bullet 1", "Bullet 2", "Bullet 3", "Bullet 4", "Bullet 5", "Description", "\n"]
					end

					# csv << [""]
					# csv << ["Seller", "Price", "Prime", "Shipping", "Shipping Details", "Condition"]
					rows.each do |row|
						csv << row
					end

			    end

			    print "Complete" + "\n"

			end

			print "\n▒▒▒▒▒▒▒█▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀█
	▒▒▒▒▒▒▒█░▒▒▒▒▒▒▒▓▒▒▓▒▒▒▒▒▒▒░█
	▒▒▒▒▒▒▒█░▒▒▓▒▒▒▒▒▒▒▒▒▄▄▒▓▒▒░█░▄▄
	▒▒▄▀▀▄▄█░▒▒▒▒▒▒▓▒▒▒▒█░░▀▄▄▄▄▄▀░░█
	▒▒█░░░░█░▒▒▒▒▒▒▒▒▒▒▒█░░░░░░░░░░░█
	▒▒▒▀▀▄▄█░▒▒▒▒▓▒▒▒▓▒█░░░█▒░░░░█▒░░█
	▒▒▒▒▒▒▒█░▒▓▒▒▒▒▓▒▒▒█░░░░░░░▀░░░░░█
	▒▒▒▒▒▄▄█░▒▒▒▓▒▒▒▒▒▒▒█░░█▄▄█▄▄█░░█
	▒▒▒▒█░░░█▄▄▄▄▄▄▄▄▄▄█░█▄▄▄▄▄▄▄▄▄█
	▒▒▒▒█▄▄█░░█▄▄█░░░░░░█▄▄█░░█▄▄█\nWooHoo, it worked!\n\n"

		end
		print "Goodbye!"

	end

	AmazonApi::scrape

end