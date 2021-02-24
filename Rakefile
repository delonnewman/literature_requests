require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

namespace :db do
  desc "Run migrations"
  task :migrate do
    sh 'sequel $DATABASE_URL -m db/migrations/'
  end
end

desc "Setup application"
task :setup => :'db:migrate' do
  sh './scripts/import-congregation db/data/congregation_members.csv'
  sh './scripts/initialize-publications'
end

desc "Start development server"
task :server do
  sh 'shotgun config.ru'
end
