require 'httparty'
require 'nokogiri'
require 'json'
require 'pry'
require 'csv'

target = HTTParty.get('https://newyork.craigslist.org/search/pet?s=0')
jydsk  = HTTParty.get('https://dk.trustpilot.com/review/www.jef.dk')

parse_jydsk = Nokogiri::HTML(jydsk)
parse_target = Nokogiri::HTML(target)

pets_array = []
jydsk_rating = []

parse_target.css('.content').css('.row').css('.hdrlnk').map do |x|
	post_name = x.text
	pets_array << post_name
end

parse_jydsk.css('.number-rating').css('span').map do |rating|
	current_rating = rating.text
	jydsk_rating	<< current_rating
end

CSV.open('jydsk.csv', 'w') do |csv|
	csv << jydsk_rating
end

CSV.open('pets.csv', 'w') do |csv|
	csv << pets_array
end


puts "All done, file executed with no errors. A total of #{jydsk_rating.length} headlines was imported to Jydsk.csv"
puts "Furthermore, an additional #{pets_array.length} lines was added to pets.csv"


#Pry.start(binding)
