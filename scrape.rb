#!/usr/bin/env ruby
require 'rubygems'
require 'nokogiri'
require 'open-uri'

# Define the URL with the argument passed by the user
# uri = "http://www.crunchbase.com/company/#{ARGV[0]}"
uri = 'http://collections.lib.uwm.edu/cdm/search/collection/mkenh/searchterm/southeast%20side/field/neighb/mode/all/conn/and/order/nosort'

# Use Nokogiri to get the document
doc = Nokogiri::HTML(open(uri))

# puts doc.class   # => Test doc returns something.
puts doc.css('title')[0].text   # => Milwaukee Neighborhoods

# Find the links of interest
# links = doc.search('dd span[1]')
links = doc.css('div.listContentBottom a')

# Emit the content associated with that link
# puts links[0].class   # => Test links returns something.
puts links.length   # => 20
puts links[0].name   # => href
puts links[0].text   # => South Shore Park beach
puts links[0]['href']   # => /cdm/singleitem/.../id/69/rec/1

# puts name[0].text   # => South Shore Park beach

# Orig from IBM scraper article. Seems equiv to puts links[0].text
# puts links[0].content
