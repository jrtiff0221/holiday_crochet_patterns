require 'nokogiri'
require 'open-uri'
require 'pry'

class CrochetScraper
  BASE_PATH = "https://www.allfreecrochet.com"

  def self.scrape_halloween_pattern_titles
    doc = CrochetScraper.get_doc_from_url(BASE_PATH + '/Holiday-Crochet-Patterns')

    halloween_pattern_cards = doc.css('.articleHeadline a')

    # We filter out articles that contain multiple patterns like 30 cool halloween costume patterns
    halloween_pattern_cards.map {
      |a| { :title => a.text, :url_path => a[:href] }
    }.reject { |pattern_hash| pattern_hash[:title].split.any? { |word| Integer(word) rescue false} }
  end

  def self.scrape_halloween_pattern_by_path(url_path)
    # Attributes on pattern page
    # Difficulty
    # Pattern Link
    # Crochet Hook
    # Finished Size
    # Yarn Weight
    # - Possibly missing attributes\
    # # Crochet Gauge
    # # Materials
    doc = CrochetScraper.get_doc_from_url(BASE_PATH + url_path)
    attributes = doc.css('.articleAttrSection p')
    description = attributes[0].text
    rating = attributes[1].at_css('img')[:alt]
    anchor = doc.at_css('.articleAttrSection a')
    link = anchor[:href] if anchor


    attributes[2..-1].inject(
      {
        :description => description,
        :rating => rating,
        :link => link
      }
    ) { |attr_hash, attribute|
      key = attribute.at_css('.attrLabel')
      value = attribute.css('span').length == 2 ? attribute.css('span').last : attribute

      if key && value
        attr_hash[key.text] = value.text.gsub(key.text, '')
      end
      attr_hash
    }.compact
  end

  def self.get_doc_from_url(url)
    html = open(url)
    Nokogiri::HTML(html)
  end
end
