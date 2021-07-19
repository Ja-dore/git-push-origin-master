# frozen_string_literal: true

require 'nokogiri'
require 'open-uri'

# scrape all the recipes from the website
class ScrapeAllrecipesService
  def initialize(keyword)
    @keyword = keyword
    @scraped_recipes = {}
  end

  def call
    define_html.search('.card__detailsContainer-left').first(5).each do |card|
      @scraped_recipes[search_name(card)] = [search_description(card),
                                             cooking_time(search_link(card)),
                                             search_rating(card)]
    end
    @scraped_recipes
  end

  def define_html
    Nokogiri::HTML(URI.open("https://www.allrecipes.com/search/results/?search=#{@keyword}").read)
  end

  def shorten(something)
    something.nil? ? '' : something[0]
  end

  def cooking_time(url)
    html_doc = Nokogiri::HTML(URI.open(url).read)
    html_doc.search('.recipe-meta-item-body').first.text.strip
  end

  def search_name(card)
    card.search('h3').text.strip
  end

  def search_description(card)
    card.search('.card__summary').children.text.strip
  end

  def search_rating(card)
    shorten(card.search('.review-star-text').children.text.strip.match(/(\d)/))
  end

  def search_link(card)
    card.search('a').attribute('href').value
  end
end
