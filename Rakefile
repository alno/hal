#!/usr/bin/env rake

$:.unshift('./lib')

namespace :db do

  desc "Migrate database schema"
  task :migrate do
    require 'database'

    exec "bundle exec sequel -m db/migrate '#{DB_CONN_STRING}'"
  end

end
