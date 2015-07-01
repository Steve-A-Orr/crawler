require 'yaml'
require 'active_record'

module Crawler
  autoload :Main, 'crawler/main'
  autoload :Threads, 'crawler/threads'
  autoload :ModuleBase, 'crawler/module_base'
  autoload :CrawlerBase, 'crawler/crawler_base'

  def self.setup_env
    init_active_record
    setup_load_path
    setup_autoloader
    @mutex = ::Mutex.new
  end

  # @return [Mutex]
  def self.mutex
    @mutex
  end

  # @return [void]
  def self.init_active_record
    log_file = File.expand_path('database.log', 'log')

    ::ActiveRecord::Base.establish_connection(config['database'])
    ::ActiveRecord::Base.logger = Logger.new(File.open(log_file, 'a'))
  end

  # @return [void]
  def self.setup_load_path
    $LOAD_PATH << root.join('lib')

    Dir.new(root.join('app')).each do |entry|
      next if entry.eql?('.') || entry.eql?('..') || !File.directory?(root.join('app', entry))

      $LOAD_PATH << root.join('app', entry)
    end
  end

  # @deprecated
  def self.load_files
    Dir.glob(root.join('app', '**', '*.rb')).each do |file|
      require file
    end
  end

  # @return [void]
  def self.setup_autoloader
    def Object.const_missing(name)
      Crawler.mutex.synchronize do
        file = name.to_s.underscore
        require file
        klass = const_get(name)
        klass ? klass : raise("Class not found[1]: #{name}")
      end
    end
  end

  # @return [Pathname]
  def self.root
    @root ||= Pathname.new(File.expand_path('.'))
  end

  # @return [Hash]
  def self.config
    @config ||= begin
      config_file = root.join('config', 'config.yml')
      YAML::load(File.binread(config_file))
    end
  end
end

Crawler.setup_env

