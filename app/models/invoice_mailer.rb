class InvoiceMailer < ActionMailer::Base
  helper :application
  
  def bill_creation_notification( person, bill, current_person )
    content_type 'text/plain'
    recipients person.email
    subject "#{current_person.name} has scroOoged you"
    from "the scroOoge <bill_creation@scroooge.net>"
    reply_to "scroooge@pdietrich.net"
    
    ###
    dli = person.direct_login_identifiers.build
    dli.invitor_id = current_person.id
    dli.save!
    
    body :person => person, :bill => bill, :direct_login_identifier => dli, :current_person => current_person
  end
  
end
