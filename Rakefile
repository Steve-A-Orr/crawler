require 'active_record'
require 'yaml'
require 'logger'

task :default => 'db:migrate'

namespace :db do
  desc 'Migrate the database through scripts in db/migrate. Target specific version with VERSION=x'
  task :migrate => :environment do
    ActiveRecord::Migrator.migrate('db/migrate', ENV["VERSION"] ? ENV["VERSION"].to_i : nil )
  end
end

task :environment do
  config = YAML::load(File.open('config/config.yml'))['database']
  ActiveRecord::Base.establish_connection(config)
  ActiveRecord::Base.logger = Logger.new(File.open('log/migrate.log', 'a'))
end
