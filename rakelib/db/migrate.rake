# frozen_string_literal: true

namespace :db do
  task :migrate, %i[version] => :settings do |_t, args|
    desc 'Run database migration'
    require 'sequel/core'
    Sequel.extension(:migration)

    Sequel.connect(Settings.db.to_hash) do |db|
      migrations = File.expand_path('../../db/migrations', __dir__)
      version = args.version.to_i if args.version
      Sequel::Migrator.run(db, migrations, target: version)
    end
  end
end

# createdb -U postgres -h localhost <db_name>  #creates db through console
