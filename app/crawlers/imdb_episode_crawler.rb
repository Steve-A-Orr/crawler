class ImdbEpisodeCrawler < Crawler::CrawlerBase
  attr_accessor :serie

  def crawl
    1.upto(serie.seasons) do |season|
      page = agent.get("#{url}?season=#{season}")

      episodes_container = page.search('div[id="episodes_content"]')

      episodes_container.css('.list_item').each do |episode_info|
        episode_number = episode_info.css('meta[itemprop="episodeNumber"]')[0].attr('content')
        episode = serie.episodes.where(season: season, episode: episode_number).first_or_initialize

        title_link = episode_info.css('a[itemprop="name"]')[0]
        episode.title = title_link.content
        episode.url = title_link.attr('href')
        episode.description = episode_info.css('div[itemprop="description"]')[0].content
        episode.release_date = episode_info.css('div[class="airdate"]')[0].content

        episode.save!
      end

      log "Saved episodes for serie #{serie.name}, season: #{season}".yellow
    end
  end

  def url
    @url ||= "#{serie.url}/episodes/"
  end

end
