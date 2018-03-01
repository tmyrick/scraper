module AmazonApi

	require 'HTTParty'
	require 'Nokogiri'
	require 'JSON'
	require 'Pry'
	require 'csv'
	OFFER_LISTING = "https://www.amazon.com/gp/offer-listing"
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


				@endpoint = "#{OFFER_LISTING}/#{asin}?#{CRED_STRING}#{asin}"

				page = HTTParty.get(@endpoint)
				parse_page = Nokogiri::HTML(page)
				arr = []
				title = parse_page.css('h1').text.strip

				parse_page.css('.olpOffer').each do |a|
				if a.css('.olpSellerName img').empty?
					seller = a.css('.olpSellerName').text.strip
				else
					seller = a.css('.olpSellerName img').attr('alt').value
				end
					offer_price = a.css('.olpOfferPrice').text.strip
					prime = a.css('.supersaver').text.strip
					shipping_info = a.css('.olpShippingInfo').text.strip.squeeze(" ").gsub!(/(\n)/, '')
					shipping_details = a.css('.olpFastTrack').text.strip
					condition = a.css('.olpCondition').text.strip
					a.css('.olpFastTrack').each do |bullet|
						bullets = bullet.text.strip
					end


					arr.push(asin,seller,offer_price,prime,shipping_info,shipping_details,condition)
				end

				rows = arr.each_slice(7)

				CSV.open("#{file_name}", "ab") do |csv|
					# IF the csv has content, don't give it headers
					# if File.zero?(file_name)
					# 	csv << ["Seller", "Price", "Prime", "Shipping", "Shipping Details", "Condition"\n"]
					# end

					csv << [""]
					csv << [title]
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