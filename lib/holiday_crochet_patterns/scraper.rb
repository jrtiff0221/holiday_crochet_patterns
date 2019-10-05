require 'nokogiri'
require 'open-uri'
require 'pry'

class CrochetScraper
  BASE_PATH = "https://www.allfreecrochet.com"

  def self.scrape_halloween_pattern_titles
    doc = CrochetScraper.get_doc_from_url(BASE_PATH + '/Holiday-Crochet-Patterns')

    halloween_pattern_cards = doc.css('.articleHeadline a')

    # We filter out articles that contain multiple patterns like 30 cool halloween costume patterns
    halloween_pattern_cards.map { |a| { :title => a.text, :url_path => a[:href] } }.reject { |pattern_hash| pattern_hash[:title].split.any? { |word|  Integer(word) rescue false} }
  end

  def self.scrape_halloween_pattern_by_path(url_path)
    # Attributes on pattern page
    # Difficulty
    # Pattern Link
    # Crochet Hook
    # Finished Size
    # Yarn Weight
    # - Possibly missing attributes
    # # Crochet Gauge
    # # Materials
    doc = CrochetScraper.get_doc_from_url(BASE_PATH + url_path)
    attributes = doc.css('.articleAttrSection')
    puts attributes
  end

  def self.get_doc_from_url(url)
    html = open(url)
    Nokogiri::HTML(html)
  end
end
