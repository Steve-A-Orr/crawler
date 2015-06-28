module Crawler
  class CrawlerBase
    attr_reader :agent

    def self.crawl(*args)
      new(*args).crawl
    end

    # @param mechanize [Mechanize::HTTP::Agent]
    def initialize(mechanize)
      @agent = mechanize
    end

    # @abstract
    def crawl
      raise 'You must define #crawl method'
    end

    # @param msg [String]
    def log(msg)
      Crawler.mutex.synchronize do
        puts msg
      end
    end
  end
end
