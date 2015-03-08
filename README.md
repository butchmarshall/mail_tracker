MailTracker
============

A Rails plugin that tracks the full contents (to, from, cc, bcc, subject, body text/html) and attachments of emails sent via Mail::Message

Still needs work in the configurability department

Installation
============

```ruby
gem 'mail_tracker'
```

The Active Record migration is required to create the tables. You can create that table by running the following commands:

    rails generate mail_tracker:active_record
    rake db:migrate

Usage
============

MailTracker automatically registers an ActionMailer observer.

To track a piece of mail, you want to call MailTracker.track in your mailer class.

e.g.

```ruby
class MyMailer < ActionMailer::Base
	def deliver_some_mail(user)
		mail_message = mail :to => user.email
			format.text
			format.html 
		end

		# Track this Mail::Message object and associate it with an optional owner object (in this case - the user object)
		MailTracker.track(mail_message, user)
	end
end
```

I use this in conjunction with my [mail_delivery_status](https://github.com/butchmarshall/mail_delivery_status) gem to get a pretty good overview idea of what's happening with my emails.

Special Thanks
============
A lot of this gems code was inspired by the [delayed_job](https://github.com/collectiveidea/delayed_job) gem