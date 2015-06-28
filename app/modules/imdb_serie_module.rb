class ImdbSerieModule < Crawler::ModuleBase
  def run
    threads = Crawler::Threads.new

    series.each do |serie_id|
      threads.add do
        crawler = ImdbSerieCrawler.new(agent.dup)
        crawler.serie_id = serie_id
        crawler.crawl
      end
    end

    threads.start
  end

  protected

  def series
    YAML.load(File.binread(Crawler.root.join('config', 'imdb.yml')))['series']
  end
end
