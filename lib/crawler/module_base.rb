require 'mechanize'
require 'net/telnet'

module Crawler
  class ModuleBase
    attr_reader :agent

    def self.run(*args)
      new(*args).run
    end

    def initialize
      init_agent
    end

    def init_agent
      @agent = Mechanize.new
      # @agent.set_proxy('w3c.widzew.net', 8080)

      # disabling keep alive will make sure we can easier switch circuit in tor
      @agent.keep_alive = false
      # randomize user agent
      @agent.user_agent_alias = Mechanize::AGENT_ALIASES.keys.sample
    end

    # @abstract
    def run
      raise 'You must define #run method'
    end
  end
end
