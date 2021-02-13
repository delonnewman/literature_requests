require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

namespace :db do
  desc "Run migrations"
  task :migrate do
    sh 'sequel config/database.yml -m migrations/'
  end
end
