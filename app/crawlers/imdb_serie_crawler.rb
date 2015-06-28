class ImdbSerieCrawler < Crawler::CrawlerBase
  BASE_URL = 'http://www.imdb.com/title/'

  attr_accessor :serie_id

  def crawl
    @serie = Serie.where(url: url).first_or_initialize

    overview = page.search('td[id="overview-top"]')
    @serie.name = overview.css('span[itemprop="name"]')[0].content
    @serie.description = overview.css('p[itemprop="description"]')[0].content

    episodes_container = page.search('div[class="seasons-and-year-nav"]')
    @serie.seasons = episodes_container.css("div:nth-of-type(3) a").map { |a| a.content.to_i }.max || 0

    @serie.save!

    log "Saved serie #{@serie.name}".red
  end

  def url
    @url ||= "#{BASE_URL}#{serie_id}"
  end

  def page
    @page ||= agent.get(url)
  end
end
