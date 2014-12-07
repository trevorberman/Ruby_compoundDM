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
# puts more_results_pages

# Create 'General Delimited Syntax' array
# of tokens %W("#{interpolated} strings") to hold uri list
uri_list = %W(
  #{base_uri}
).each do |uri|
  # puts uri
end

# Create array to hold more_result_pages uri list
pages = []

# Ouput tests on the new array
# puts pages.length
# p pages

# Add page/# ending for each results_page to base uri, push to uri list
while  more_results_pages > 0
  more_results_uri = base_uri + "/page/#{more_results_pages + 1}"
  pages.insert(0, more_results_uri)
  # p pages
  more_results_pages -= 1
  # puts more_results_pages
end

# Append pages[] to uri_list[]
pages.each { |uri| uri_list << uri }
# p uri_list

# Create array to hold CDM single_item_links
item_pages = %w()

# Collate list of single_item_links links from all results pages in uri_list
agent = Mechanize.new
uri_list.each do |uri|
  page = agent.get(uri)
  parser = page.parser
  single_item_links = parser.css('div.listContentBottom a')
  single_item_links.each do |link|
    item_pages.insert(-1, 'http://collections.lib.uwm.edu' + link['href'])
  end
end

# p item_pages   # => trip out on the wild pattern!

# Create array to hold each cdm_item 's array = CSV row of scraped data
item_pages_data = %w()

# Scrape data from item_pages links, push to item_pages_data
item_pages.each do |uri|
  page = agent.get(uri)
  parser = page.parser
  # cdm_item = parser.css('div#image_title h1').text.strip
  item_pages_data.insert(-1, Array.new([
    parser.css('div#image_title h1'),   # => Title
    parser.css('td#metadata_altern'),   # => Alternate Title
    parser.css('div#imageLayer'),   # => work on this info seperate loop, item_pages_data([][2])
    parser.css('td#metadata_data a'),   # => Date
    parser.css('td#metadata_descri'),   # => Description
    parser.css('td#metadata_neighb a.first'),   # => Neighborhood
    parser.css('td#metadata_addres a'),   # => Address; needs concat all 'a' text plus spaces
    parser.css('td#metadata_busine a'),   # => Business/Place
    parser.css('td#metadata_type'),   # => Type
    parser.css('td#metadata_collec a'),   # => Collection
    parser.css('td#metadata_origin a'),   # => Original Format
    parser.css('td#metadata_reposi'),   # => Repository
    parser.css('td#metadata_rights'),   # => Rights
    parser.css('td#metadata_publis'),   # => Digital Publisher
    parser.css('td#metadata_digita a'),   # => Digital ID
    parser.css('td#metadata_digitb a')   # => Digital Collection
  ])
  )
  # item_pages_data.insert(-1, 'cdm_item')
end

p item_pages_data.first.class
p item_pages_data.last.class
puts item_pages_data.first
# p item_pages_data.last
