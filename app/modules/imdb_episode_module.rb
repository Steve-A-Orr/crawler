class ImdbEpisodeModule < Crawler::ModuleBase

  def run
    threads = Crawler::Threads.new

    Serie.find_each do |serie|
      threads.add do
        crawler = ImdbEpisodeCrawler.new(agent.dup)
        crawler.serie = serie
        crawler.crawl
      end
    end

    threads.start
  end

end
