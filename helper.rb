require "bundler/setup"
require "active_record"
require "benchmark/ips"
require "logger"
require "pg"

configuration = {
  "adapter"  => "postgresql",
  "database" => "activerecord-scripts",
  "host" => "localhost",
  "port" => 5432
}

ActiveRecord::Base.establish_connection(configuration.merge(
  "database" => "postgres",
  "schema_search_path" => "public"
))

ActiveRecord::Base.connection.drop_database(configuration["database"])

ActiveRecord::Base.connection.create_database(configuration["database"])

ActiveRecord::Base.establish_connection(configuration)

ActiveRecord::Base.logger = Logger.new(STDOUT) if ENV["LOG"] == "1"
