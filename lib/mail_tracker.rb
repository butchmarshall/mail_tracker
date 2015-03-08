require 'active_support'
require 'charlock_holmes/string'
require 'mail_tracker/version'
require 'logger'
require 'benchmark'

module Mail
	class Message
		@do_mail_tracking = false
		def do_mail_tracking=i
			@do_mail_tracking = i
		end
		def do_mail_tracking
			@do_mail_tracking
		end
		
		# Owner 
		@mail_tracking_owner = nil
		def mail_tracking_owner=i
			@mail_tracking_owner = i
		end
		def mail_tracking_owner
			@mail_tracking_owner
		end

		def body_plain_in_utf8
			body = self.multipart? ? (self.text_part ? self.text_part.body.decoded : nil) : self.body.decoded
			if body.present?
				encoding = body.detect_encoding[:encoding]
				body = body.force_encoding(encoding).encode('UTF-8')
			end
			return body
		end
		def body_html_in_utf8
			body = self.html_part ? self.html_part.body.decoded : ""
			if body.present?
				encoding = body.detect_encoding[:encoding]
				body = body.force_encoding(encoding).encode('UTF-8')
			end
			return body
		end
	end
end

module MailTracker
	# Track a piece of email sent
	def self.track(mail, mail_tracking_owner = nil)
		mail.do_mail_tracking = true
		mail.mail_tracking_owner = mail_tracking_owner

		mail
	end

	class Log < ::ActiveRecord::Base
		self.table_name = "mail_trackers"
		belongs_to :owner, :polymorphic => true
		has_many :attachments, :class_name => "MailTracker::Attachment", :foreign_key => :mail_tracker_id
	end

	class Attachment < ::ActiveRecord::Base
		self.table_name = "mail_tracker_attachments"
		belongs_to :mailer_tracker, :class_name => "MailTracker::Attachment", :foreign_key => :mail_tracker_id
		attr_accessor :data

		after_save do
			attachment_path = "#{Rails.root}/public/mail_tracker_attachments/#{self.mailer_tracker.id}"
			FileUtils.mkdir_p(attachment_path) unless File.exist?(attachment_path)

			File.open("#{attachment_path}/#{self.filename}", "w+b", 0644) { |f| f.write @data }
		end

		def data=i
			@data = i
		end
	end
	class Impression < ::ActiveRecord::Base
		self.table_name = "mail_tracker_impressions"
		belongs_to :mailer_tracker, :class_name => "MailTracker::Log", :foreign_key => :mail_tracker_id
	end

	class Observer
		def self.delivered_email(message)
			if message.do_mail_tracking # We want to track this mail
				log = MailTracker::Log.new(
					:owner => message.mail_tracking_owner,
					:to => message.to.to_a.join(', '),
					:from => message.from.to_a.join(', '),
					:body_html => message.body_html_in_utf8,
					:body_plain => message.body_plain_in_utf8,
					:subject => message.subject.to_s,
					:message_id => message.message_id
				)

				message.attachments.each { |attachment|
					log.attachments.build(
						content_id: attachment.content_id,
						filename: attachment.filename,
						content_type: attachment.content_type,
						content_disposition: attachment.content_disposition,
						headers: attachment.headers.to_yaml,
						content_transfer_encoding: attachment.content_transfer_encoding,
						data: attachment.body.decoded,
					)
				}

				log.save
			end
		end
	end
end

# Register observer so we know about all emails sent through the system
ActionMailer::Base.register_observer(MailTracker::Observer)