class Participation < ActiveRecord::Base
  
  belongs_to :bill
  belongs_to :participant, :class_name => 'Person', :foreign_key => 'participant_id'
  belongs_to :creator, :class_name => 'Person', :foreign_key => 'creator_id'
  belongs_to :currency
  
  attr_accessible :factor, :name_or_email, :participant_id
  
  validates_presence_of :participant_id, :on => :update # because there may be newly created people when the bill is saved
  validates_presence_of :bill_id, :on => :update # bill_id is not checked on creation so participations can be saved together with a bill

  before_save :copy_currency_id_and_payer_id_from_bill

private
#  def email_given
#    email and email != ''
#  end

  def copy_currency_id_and_payer_id_from_bill
    self.currency_id = bill.currency_id
    self.payer_id = bill.payer_id
    
    unless self.currency_id and self.payer_id
      logger.error 'no currency found for bill'
      raise 'no currency found for bill'
    end
  end
end
