#!/usr/bin/env rake

$:.unshift('./lib')

namespace :db do

  desc "Migrate database schema"
  task :migrate do
    require 'database'

    exec "bundle exec sequel -m db/migrate '#{DB_CONN_STRING}'"
  end

end

namespace :records do

  desc "Cleanup old records"
  task :cleanup do
    require 'database'

    records = DB[:camera_events].where('time < current_timestamp - interval ?', '5 days').select_map([:id, :file_name])

    if records.empty?
      puts "No old records found"
    else
      ids, files = records.transpose

      puts "Removing records: #{ids.inspect}"

      # Remove old records from database
      DB[:camera_events].where(:id => ids).delete

      # Remove old record files
      files.each do |f|
        File.delete f if File.exists? f
      end
    end
  end

end

namespace :assets do

  task :precompile do
    require 'sinatra'
    require 'sinatra/sprockets'
    require 'sinatra/sprockets/static_compiler'

    Sinatra.register Sinatra::Sprockets

    require './assets'

    Sinatra::Sprockets::StaticCompiler.new(app_assets, 'public/assets', [/app\..*/], digest: false).compile
  end

end
