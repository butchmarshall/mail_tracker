# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mail_tracker/version'

Gem::Specification.new do |spec|
	spec.name          = "mail_tracker"
	spec.version       = MailTracker::VERSION
	spec.authors       = ["Butch Marshall"]
	spec.email         = ["butch.a.marshall@gmail.com"]
	spec.summary       = "Track your emails"
	spec.description   = "Tracks emails sent by Actionmailer"
	spec.homepage      = "https://github.com/butchmarshall/mail_tracker"
	spec.license       = "MIT"

	spec.files         = `git ls-files -z`.split("\x0")
	spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
	spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
	spec.require_paths = ["lib"]

	spec.add_dependency "activerecord", [">= 3.0", "< 5.0"]
	spec.add_dependency "charlock_holmes"

	spec.add_development_dependency	"rspec"
	spec.add_development_dependency "bundler", "~> 1.7"
	spec.add_development_dependency "rake", "~> 10.0"
end
