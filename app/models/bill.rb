class Bill < ActiveRecord::Base
  
  belongs_to :currency
  belongs_to :payer, :class_name => 'Person', :foreign_key => 'payer_id'
  has_many :participations, :order => 'id' # a deterministic order is important for the calculation of the amounts  #, :inlcude => [:participant]
  has_many :participants, :through => :participations #, :readonly => true
  
  
  attr_accessible :payer_id, :name, :amount, :currency_id, :email
  attr_accessor :email # this is necessary for the bill creation page to redisplay the email address
  
  validates_presence_of :currency_id
  validates_presence_of :payer_id, :on => :update
  validates_presence_of :name
  validates_presence_of :creator_id
  validates_numericality_of :amount
  # validates_associated :participations
  
  before_save :calculate_participation_amounts
  
  attr_accessor :ower_id
  
  def validate
    if self.participations.empty?
      errors.add :participations_missing, 'There must be at least one participant!'
    end
  end
  
  def sum_of_factors
    return @sum_of_factors if @sum_of_factors

    @sum_of_factors = 0.0
    for p in participations
      @sum_of_factors += p.factor
    end
    
    return @sum_of_factors
  end
  
  def amount_per_factor
    amount / sum_of_factors
  end
  
  def amount_for( person_id )
    if self.ower_id == person_id
      # puts "Bill#amount_for( #{person_id} ): from DB: self.owed = #{self.owed}"
      res = self.owed.to_f
    else
      # puts "Bill#amount_for( #{person_id} ): calculating"
      res = 0.0
      if payer_id == person_id
        res += self.amount
      end
      
      participation = Participation.first( :conditions => { :bill_id => self.id, :participant_id => person_id } )
      if participation
        # puts "participation.amount: #{participation.amount}"
        res -= participation.amount
      end
      res = res.round_to(2)
    end 
    return res
  end
  
private

  def calculate_participation_amounts
    return if self.participations.empty?
    first_participation = self.participations[0]
    other_participations = self.participations[1..participations.length]
    
    sum = 0.0
    for participation in other_participations
      participation.amount = (self.amount_per_factor * participation.factor).round_to(2) # (self.amount_per_factor * participation.factor * 100.0).round / 100.0
      sum += participation.amount
    end
    first_participation.amount = (self.amount - sum).round_to(2) # ((self.amount - sum) * 100.0).round.to_i / 100.0
  end
end
