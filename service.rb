class ScrapeAllrecipesService
  def initialize(keyword)
    @keyword = keyword
  end

  def call
    url = "https://www.allrecipes.com/search/results/?search=#{@keyword}"
    html_doc = Nokogiri::HTML(URI.open(url).read)
    recipes = {}
    html_doc.search('.card__detailsContainer-left').first(5).each do |card|
      b = card.search('.review-star-text').children.text.strip.match(/(\d)/)
      c = b.nil? ? "" : b[0]
      d = cooking_time(card.search('a').attribute('href').value)
      recipes[card.search('h3').text.strip] = [card.search('.card__summary').children.text.strip, d, c]
    end
    return recipes
  end

  def cooking_time(url)
    html_doc = Nokogiri::HTML(URI.open(url).read)
    return html_doc.search('.recipe-meta-item-body').first.text.strip
  end
end
