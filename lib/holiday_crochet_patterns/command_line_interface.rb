require_relative "scraper"
require 'nokogiri'
require 'paint'
using Paint
Paint.mode = 256

class CommandLineInterface
  HALLOWEEN_COLORS = ['#F75F1C', '#FF9A00', '#881EE4', '#85E21F']

  def run
    puts "\nWelcome to your " + to_halloween_colors("Halloween") + " crochet pattern database!"
    patterns = CrochetScraper.scrape_halloween_pattern_titles
    patterns.each_with_index { |pattern, index| puts "#{to_halloween_colors((index + 1).to_s)}. #{pattern[:title]}" }

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
      puts "\n" + to_halloween_colors("Title") + ": #{pattern[:title]}\n"
      pattern_info = CrochetScraper.scrape_halloween_pattern_by_path(pattern[:url_path])
      pattern_info.each { |key, value| puts "#{to_halloween_colors(key.to_s.capitalize)}: #{value}\n" }
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

  def to_halloween_colors(str)
    str.chars.map { |char| Paint[char, HALLOWEEN_COLORS.sample] }.join 
  end
end
