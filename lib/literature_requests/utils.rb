# frozen_string_literal: true
module LiteratureRequests
  module_function

  def env
    PredicateString.new(ENV.fetch('RACK_ENV') { 'development' })
  end

  def logger
    @logger ||= Logger.new(STDOUT)
  end

  def root
    @root ||= Pathname.new(File.join(__dir__, '..', '..')).expand_path
  end

  def db_config
    YAML.load_file(root.join('config/database.yml'))
  end

  def db
    @db ||= Sequel.connect(ENV.fetch('DATABASE_URL'))
  end
end
