class CreateMailTracker < ActiveRecord::Migration
	def self.up
		create_table :mail_trackers do |table|
			table.string :owner_type
			table.string :owner_id

			table.string :message_id
			table.string :to
			table.string :from
			table.string :subject
			table.text :body_plain
			table.text :body_html

			table.timestamps
		end
		create_table :mail_tracker_attachments do |table|
			table.integer :mail_tracker_id
			table.string :content_id
			table.string :filename
			table.string :content_type
			table.string :content_disposition
			table.string :headers
			table.string :content_transfer_encoding
			#puts attachment.body.decoded

			table.timestamps
		end
		create_table :mail_tracker_impressions do |table|
			table.integer :mail_tracker_id
			table.integer  "ipv4"
			table.binary   "ipv6",                    :limit => 255

			table.timestamps
		end
	end

	def self.down
		drop_table :mail_trackers
		drop_table :mail_tracker_impressions
	end
end