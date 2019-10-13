require_relative 'scraper'
require 'nokogiri'

class CommandLineInterface
  def run
    puts "\nWelcome to your Holiday crochet pattern program!"

    patterns = CrochetScraper.scrape_holiday_pattern_titles
    patterns.each_with_index { |pattern, index| puts "#{index + 1}. #{pattern[:title]}" }

    pick_pattern(patterns)
  end

  def pick_pattern(patterns)
    puts "\nPlease choose a pattern number(1-#{patterns.length}) from the list."

    input = gets.strip
    index = input_to_index(input)
    if valid_input?(index, patterns.length - 1)
      # pattern is a hash with keys(:title, :url_path)
      pattern = patterns[index]
      # Call scaper method to get details from url from patterns array
      puts "\n\nTitle: #{pattern[:title]}\n"
      pattern_info = CrochetScraper.scrape_holiday_pattern_by_path(pattern[:url_path])
      pattern_info.each { |key, value| puts "\n#{key}: #{value}\n" }

      pick_another_pattern
    else
      pick_pattern(patterns)
    end
  end

  def pick_another_pattern
    puts "\n\nWould you like to pick another pattern? Please enter Yes or No."
    input = gets.strip

    if input.downcase != 'yes' && input.downcase != 'no'
      pick_another_pattern
    end

    if input.downcase == 'yes'
      run
    end
  end

  def input_to_index(str_index)
    str_index.to_i - 1
  end

  def valid_input?(index, patterns_len)
    index.between?(0, patterns_len)
  end
end
