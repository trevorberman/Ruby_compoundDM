#!/usr/bin/env ruby
require 'rubygems'
require 'nokogiri'
require 'open-uri'

# Get CONTENTdm query from user; 1. cut/paste from CDM || 2. CDM API search call
# Define the URL with the argument passed by the user
# uri = "http://www.crunchbase.com/company/#{ARGV[0]}"
uri = 'http://collections.lib.uwm.edu/cdm/search/collection/mkenh/searchterm/southeast%20side/field/neighb/mode/all/conn/and/order/nosort'

# Use Nokogiri to get the document
doc = Nokogiri::HTML(open(uri))
# puts doc.class   # => Test doc returns something.
# puts doc.css('title')[0].text   # => Test returns expected 'Milwaukee Neighborhoods'

# Find the links of interest
# links = doc.search('dd span[1]')
links = doc.css('div.listContentBottom a')

# Output the content associated with that link
### For testing at start, WE NEED CLASSES, instances to hold data, methods to use it
# puts links[0].class   # => Test links returns something.
puts links.length   # => 20
puts links[0].name   # => href
puts links[0].text   # => South Shore Park beach
puts links[0]['href']   # => /cdm/singleitem/.../id/69/rec/1

# Orig from IBM scraper article. Seems equiv to puts links[0].text
# puts links[0].content

# Find the number of additional results pages
pagination = doc.css('div.link_bar_pagination li')
# Subtract 1st and next buttons' <li></li>s, divide by 2 for num <li></li>s each
more_results_pages = (pagination.length - 4) / 2
# puts more_results_pages   # => Test for returns expected num additional pages

while  more_results_pages > 0
  # counter = 1
  more_results_uri = uri + "/page/#{more_results_pages + 1}"
  ## Use Nokogiri to get the doc AS ABOVE
  doc = Nokogiri::HTML(open(more_results_uri))
  ## Find the links of interest AS ABOVE
  links = doc.css('div.listContentBottom a')   # CAN"T DO THIS AGAIN BECAUSE OVERWRITE PREVIOUS LINKS VAR
  ### WE NEED CLASSES !!
  ### !! Add as instances of class variables - with methods to name and use...
  # more_results_pages --
  # counter += 1
end
