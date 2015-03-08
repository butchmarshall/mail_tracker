require "generators/mail_tracker/mail_tracker_generator"
require "generators/mail_tracker/next_migration_version"
require "rails/generators/migration"
require "rails/generators/active_record"

# Extend the MailTrackerGenerator so that it creates an AR migration
module MailTracker
	class ActiveRecordGenerator < ::MailTrackerGenerator
		include Rails::Generators::Migration
		extend NextMigrationVersion

		source_paths << File.join(File.dirname(__FILE__), "templates")

		def create_migration_file
			migration_template "migration.rb", "db/migrate/create_mail_tracker.rb"
		end

		def self.next_migration_number(dirname)
			ActiveRecord::Generators::Base.next_migration_number dirname
		end
	end
end
