require 'rubygems'
require 'nokogiri'
require 'open-uri'

# Take a CONTENTdm results query
# Southside; more_results_pages = 1
# base_uri = 'http://collections.lib.uwm.edu/cdm/search/collection/mkenh/searchterm/southeast%20side/field/neighb/mode/all/conn/and/order/nosort'
# Eastside; more_results_pages = 4
base_uri = 'http://collections.lib.uwm.edu/cdm/search/collection/mkenh/searchterm/east%20side/field/neighb/mode/all/conn/and/order/nosort'

# Use Nokogiri to access the query
doc = Nokogiri::HTML(open(base_uri))

# Find the number of additional results pages
# As orig devised; works as expected BUT CONTENTdm fills middle button
# numbers with '...' if length exceeds 3+ additional results pages. Thus unable
# to get pagination by th efoolowing methed. See: scraper.rb for updated.
pagination = doc.css('div.link_bar_pagination li')
# Because <li></li>s each
# Divide by 2 changes .length from num elements to num buttons
# Subtract 2 eliminates '1st'(active-page) and 'Next' buttons
more_results_pages = (pagination.length / 2) - 2
puts more_results_pages

# Create 'General Delimited Syntax' array
# of tokens %W("#{interpolated} strings") to hold uri list
uri_list = %W(
  #{base_uri}
).each do |uri|
  puts uri
end

# Can use var to set array length!
# But .inset into empty array is simpler solution here.
# pages = Array.new(more_results_pages)

# Create array to hold more_result_pages uri list
pages = []

# Ouput tests on the new array
puts pages.length
p pages

# Add page/# ending for each results_page to base uri and add to uri list
while  more_results_pages > 0
  more_results_uri = base_uri + "/page/#{more_results_pages + 1}"
  # Can use var and arithm to index array!
  # But .inset into empty array is simpler solution here.
  # pages.insert(more_results_pages.to_i - 1, more_results_uri)
  pages.insert(0, more_results_uri)
  p pages
  more_results_pages -= 1
  puts more_results_pages
end

# Append pages[] to uri_list[]
pages.each { |uri| uri_list << uri }
p uri_list

# !!!??? why Eastside query only giving 3 additional pages
# when should be 4; from buttons 2, 3, 4, 5 ???!!!
