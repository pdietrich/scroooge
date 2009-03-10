class DirectLoginIdentifier < ActiveRecord::Base
  
  belongs_to :identified_person, :class_name => 'Person', :foreign_key => 'identified_person_id'
  belongs_to :invitor, :class_name => 'Person', :foreign_key => 'invitor_id'
  
  before_create :generate_code
  # after_create :send_email
    
private
  def generate_code
    puts 'generating code'
    chars = 'qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM1234567890'
    self.code = ''
    30.times do
      self.code += chars[rand(chars.length),1]
    end
  end

#  def send_email
#    puts "now sending email with code '#{self.code}' to '#{identified_person.email}'"
#    # FIXME: to be implemented
#  end
end