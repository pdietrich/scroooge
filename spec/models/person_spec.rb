require File.dirname(__FILE__) + '/../spec_helper'

describe Person do
  # fixtures :people, :bills, :participations 
  
  before(:each) do
    @person = Person.new({
      :name => 'Hans Wurst',
      :email => 'hans@wurst.net',
      :currency_id => 1,
      :password => 'asdf',
      :password_confirmation => 'asdf',
    })
  end

  it "should be valid" do
      @person.should be_valid
  end

  it "should calculate his balance correctly" do
    people(:aaron).balance.should eql( -(bills(:cooking).amount * 2.0) / 3.0 )
    people(:quentin).balance.should eql( bills(:cooking).amount - (bills(:cooking).amount * 1.0) / 3.0 )
  end
  
  it "should calculate the amount owed to another person correctly" do
    people(:aaron).amount_owed_to( people(:quentin) ).should eql( bills(:cooking).amount * 2.0 / 3.0 )
    people(:quentin).amount_owed_to( people(:aaron) ).should eql( -bills(:cooking).amount * 2.0 / 3.0 )
  end

  it "should know people who have payed a bill he has participated in" do
    aarons_payers = people(:aaron).payers
    aarons_payers.should_not be_nil
    aarons_payers.size.should eql( 1 )
    aarons_payers[0].id.should eql( people(:quentin).id )
    
    people(:quentin).payers.should be_empty
    people(:quentin).payers( :include_self => true ).should_not be_empty
    people(:quentin).payers( :include_self => true )[0].id.should eql( people(:quentin).id )
  end
  
  it "should know people who participated in a bill he has payed" do
    people(:quentin).participants.should_not be_nil
    people(:quentin).participants.size.should eql( 1 )
    people(:quentin).participants[0].id.should eql( people(:aaron).id )

    people(:quentin).participants( :include_self => true ).size.should eql( 2 )
    
    # aaron has not payed any bills
    people( :aaron ).participants.should be_empty
    people( :aaron ).participants( :include_self => true ).should be_empty
  end
  
  it "should know his deptors and creditors" do
    people(:quentin).deptors_and_creditors.should_not be_nil
    people(:quentin).deptors_and_creditors.size.should eql( 1 )
    people(:quentin).deptors_and_creditors[0].id.should eql( people(:aaron).id )

    people( :aaron ).deptors_and_creditors.size.should eql( 1 )
    people( :aaron ).deptors_and_creditors[0].id.should eql( people(:quentin).id )
  end
  
  it "should know the bills in which he participated" do
    people(:quentin).participated_bills.should be_empty
    people(:quentin).participated_bills( :include_own_bills => true ).should_not be_empty
    
    people( :aaron ).participated_bills.should_not be_empty
    people( :aaron ).participated_bills( :include_own_bills => true ).should_not be_empty
  end
end
