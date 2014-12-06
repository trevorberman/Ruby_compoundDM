require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'mechanize'

# Take a CONTENTdm results query
# Southside; more_results_pages = 1
# base_uri = 'http://collections.lib.uwm.edu/cdm/search/collection/mkenh/searchterm/southeast%20side/field/neighb/mode/all/conn/and/order/nosort'
# Eastside; more_results_pages = 4
base_uri = 'http://collections.lib.uwm.edu/cdm/search/collection/mkenh/searchterm/east%20side/field/neighb/mode/all/conn/and/order/nosort'

# Use Nokogiri to access the query
doc = Nokogiri::HTML(open(base_uri))

# Find the number of additional results pages
pagination = doc.css('li#pagination_button_last a')
more_results_pages = pagination[0].text.to_i - 1
puts more_results_pages

# Create 'General Delimited Syntax' array
# of tokens %W("#{interpolated} strings") to hold uri list
uri_list = %W(
  #{base_uri}
).each do |uri|
  puts uri
end

# Create array to hold more_result_pages uri list
pages = []

# Ouput tests on the new array
puts pages.length
p pages

# Add page/# ending for each results_page to base uri and add to uri list
while  more_results_pages > 0
  more_results_uri = base_uri + "/page/#{more_results_pages + 1}"
  pages.insert(0, more_results_uri)
  p pages
  more_results_pages -= 1
  puts more_results_pages
end

# Append pages[] to uri_list[]
pages.each { |uri| uri_list << uri }
p uri_list

# Create array to hold CDM singleItem pages links list
item_pages = %w()

# Collate list of singleItem pages links from all results pages in uri_list
agent = Mechanize.new
uri_list.each do |uri|
  page = agent.get(uri)
  parser = page.parser
  single_item_links = parser.css('div.listContentBottom a')
  single_item_links.each do |link|
    item_pages.insert(-1, 'http://collections.lib.uwm.edu' + link['href'])
  end
end

p item_pages   # => trip out on the wild pattern!
