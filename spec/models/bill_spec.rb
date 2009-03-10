require File.dirname(__FILE__) + '/../spec_helper'

describe Bill do
  # fixtures :currencies, :people
  
  before(:each) do
    @bill = Bill.new(
      :currency_id => 1,
      :payer_id => 1,
      :name => 'Big Feast',
      :description => 'awesome food!',
      :amount => 20,
      :payed_at => Time.now - 2*24*3600
    )
    @bill.creator_id = 1
  end

  it "should be validate the precence of at least one participant" do
    @bill.should_not be_valid
    @bill.should have(1).errors
    @bill.errors.clear
    
    participation = @bill.participations.build( :factor => 1.0 )
    participation.participant_id = people( :quentin ).id
    participation.creator_id = @bill.creator_id
    
    @bill.should be_valid
  end
  
#  it "should calculate the amount of the participations correctly" do
#    p1 = @bill.participations.build( :factor => 1.0 )
#    p1.participant_id = people( :quentin ).id
#    p1.creator_id = @bill.creator_id
#
#    p1.amount.should be_nil
#    @bill.should be_valid
#    @bill.save!
#    
#    p1.amount.should_not be_nil
#    p1.amount.should eql(@bill.amount)
#    
#    p2 = @bill.participations.build( :factor => 2.0 )
#    p2.participant_id = people( :aaron ).id
#    p2.creator_id = @bill.creator_id
#    
#    p2.amount.should be_nil
#    @bill.should be_valid
#    @bill.save!
#    
#    p2.amount.should_not be_nil
#    p2.amount.to_s.should == ( (100.0 * @bill.amount * p2.factor / (p1.factor+p2.factor) ).round / 100.0).to_s
#    
#    p1.amount.to_s.should == ( ((@bill.amount - p2.amount)*100.0).round / 100.0 ).to_s
#  end
end
