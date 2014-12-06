require 'rubygems'
require 'nokogiri'
require 'open-uri'

uri = 'http://collections.lib.uwm.edu/cdm/search/collection/mkenh/searchterm/southeast%20side/field/neighb/mode/all/conn/and/order/nosort'

# Use Nokogiri to get the document
doc = Nokogiri::HTML(open(uri))

# Find the links of interest
links = doc.css('div.listContentBottom a')   # => returns array of links for singleItem results listed this page
# Find the number of additional results pages
pagination = doc.css('div.link_bar_pagination li')
# Subtract 1st and next buttons' <li></li>s, divide by 2 for num <li></li>s each
more_results_pages = (pagination.length - 4) / 2
puts more_results_pages

while  more_results_pages > 0
  more_results_uri = uri + "/page/#{more_results_pages + 1}"
  puts more_results_uri
  ## Use Nokogiri to get the doc AS ABOVE
  doc_2 = Nokogiri::HTML(open(more_results_uri))
  ## Find the links of interest AS ABOVE
  more_links = doc_2.css('div.listContentBottom a')
  puts more_links.length
  # Append more_links[arrary] to links[arrary]
  # links.push(*more_links)
  # (links << more_links).flatten!
  puts more_links.class   # => returns Nokogiri::XML::NodeSet ?????
  more_results_pages -= 1
  puts more_results_pages
end
# => Test returns expected num total results/links
# puts links.length

# => Test returns list of links
# links.each { |link| puts(link['href']) }
# more_links.each { |m_link| puts(m_link['href']) }
