require_relative "scraper"
require 'nokogiri'
require 'colorize'

class CommandLineInterface

  def run
    puts "Welcome to your halloween crochet pattern database!"
    patterns = CrochetScraper.scrape_halloween_pattern_titles
    patterns.each_with_index { |pattern, index| puts "#{index + 1}. #{pattern[:title]}" }

    pick_pattern(patterns)
  end

  def pick_pattern(patterns)
    puts "\nPlease choose a pattern number(1-#{patterns.length}) from the list."

    input = gets.strip
    index = input_to_index(input)
    if valid_input?(index, patterns.length)
      # pattern is a hash with keys(:title, :url_path)
      pattern = patterns[index]
      # Call scaper method to get details from url from patterns array
      puts "You picked #{pattern[:title]}"
      puts "URL #{pattern[:url_path]}"
      CrochetScraper.scrape_halloween_pattern_by_path(pattern[:url_path])
    else
      pick_pattern(patterns)
    end
  end

  def input_to_index(str_index)
    str_index.to_i - 1
  end

  def valid_input?(index, patterns_len)
    index.between?(0, patterns_len)
  end
end