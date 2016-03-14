#!/usr/bin/env rake

$:.unshift('./lib')

namespace :db do

  desc "Migrate database schema"
  task :migrate do
    require 'database'

    exec "bundle exec sequel -m db/migrate '#{DB_CONN_STRING}'"
  end

end

namespace :gauges do

  task :cleanup do
    require 'database'

    [:gauge_values, :gauge_value_hours, :gauge_value_days].each do |table|
      DB[table].where("time < '2001-01-01'").delete
    end
  end

  desc "Build missing gauge aggregations"
  task :aggregate do
    require 'database'

    [:hour, :day].each do |agg|
      groupped_gauges = DB[:gauge_values].
        where("time < date_trunc('#{agg}', current_timestamp)").
        group{ `gauge, date_trunc('#{agg}', time)` }.
        select{ `gauge, date_trunc('#{agg}', time) AS start, date_trunc('#{agg}', time) + interval '1 #{agg}' AS end, AVG(value) AS value` }

      new_aggregations = DB[groupped_gauges => :g].
        where("NOT EXISTS (SELECT 1 FROM gauge_value_#{agg}s a WHERE a.gauge = g.gauge AND time BETWEEN g.start AND g.end)").
        select{ `g.gauge, g.start + 0.5 * (g.end - g.start), g.value` }

      DB["gauge_value_#{agg}s".to_sym].import [:gauge, :time, :value], new_aggregations
    end
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
    `cd front && npm install && npm run build`
  end

end
