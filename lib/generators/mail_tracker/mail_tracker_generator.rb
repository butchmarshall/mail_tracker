require 'rails/generators/base'
require 'mail_tracker/compatibility'

class MailTrackerGenerator < Rails::Generators::Base
	source_paths << File.join(File.dirname(__FILE__), 'templates')


end