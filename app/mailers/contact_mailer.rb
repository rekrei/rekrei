class ContactMailer < ActionMailer::Base
  add_template_helper(EmailHelper)
  default from: ENV["SENDER_EMAIL"]


  def contact_message(name, email, message)
    @name = name
    @email = email
    @message = message

    mail to: ENV["SENDER_EMAIL"], subject: "New message received at #{ENV["DOMAIN"]}"
  end
end
