module CommentPlugin
  class MigrationGenerator < Rails::Generators::Base
    include Rails::Generators::Migration

    def self.source_root
      File.join(File.dirname(__FILE__), 'templates')
    end

    def self.next_migration_number(dirname)
      if ActiveRecord::Base.timestamped_migrations
        migration_number = Time.now.utc.strftime("%Y%m%d%H%M%S").to_i
        migration_number += 1
        migration_number.to_s
      else
        "%.3d" % (current_migration_number(dirname) + 1)
      end
    end

    desc "migrate comments table"
    def create_migration_file
      migration_template 'migration.rb', 'db/migrate/create_comments'
    end
  end
end