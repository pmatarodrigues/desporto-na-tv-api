require 'nokogiri'
require 'httparty'
require 'pry'
require 'json'
require 'digest'
require_relative '../utils/common'

class Scraper
  attr_reader :name
  attr_reader :url
  attr_reader :parsed_page
  attr_reader :aggregator_selectors
  attr_reader :filename

  def initialize(name: ,url:, aggregator_selectors:, filename:)
    @name = name
    @url = url
    @aggregator_selectors = aggregator_selectors
    @filename = filename

    puts 'Reading ::' + name + '::'

    response = HTTParty.get(url)
    @parsed_page = Nokogiri::HTML(response.body)
  end

  def get_results_list
    results_list = []

    # Loop through each sport available
    parsed_page.css(aggregator_selectors[:sport]).each do |sport_section|
      sport_name = sport_section.css('.header').text

      # For each sport, get all available games
      results_by_section(sport_section).each do |result|
        date, time, home, away, tv, comp, country = get_single_result_data(result)
        results_list.push({
          date: convert_string_to_iso_timestamp("#{get_translated_date(date)} 2022 #{time}"),
          home: home,
          away: away,
          tv: tv,
          comp: comp,
          country: country,
          sport: sport_name
        })
      end
    end

    results_list
  end

  private
  def results_by_section(sport_section)
    sport_section.css("#{aggregator_selectors[:section]} #{aggregator_selectors[:result]}")
  end

  def get_single_result_data(result)
    date = result.css(aggregator_selectors[:date]).first.text
    time = result.css(aggregator_selectors[:time]).first.text

    home_no_icon = result.css(aggregator_selectors[:home_no_icon]).text
    home_with_icon = result.css(aggregator_selectors[:home_with_icon]).text
    away_no_icon = result.css(aggregator_selectors[:away_no_icon]).text
    away_with_icon = result.css(aggregator_selectors[:away_with_icon]).text

    home = home_with_icon.empty? ? home_no_icon : home_with_icon
    away = away_with_icon.empty? ? away_no_icon : away_with_icon

    tv = result.css(aggregator_selectors[:tv]).first['title']
    comp = result.css(aggregator_selectors[:comp]).first.text
    country = result.css(aggregator_selectors[:country]).first['title']
    return date, time, home, away, tv, comp, country
  end
end
