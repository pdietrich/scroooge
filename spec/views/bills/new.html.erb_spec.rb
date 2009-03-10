require File.dirname(__FILE__) + '/../../spec_helper'

describe "/bills/new.html.erb" do
  include BillsHelper
  
  before(:each) do
    @bill = mock_model(Bill)
    @bill.stub!(:new_record?).and_return(true)
    @bill.stub!(:name).and_return("MyString")
    @bill.stub!(:description).and_return("MyText")
    @bill.stub!(:amount).and_return("9.99")
    @bill.stub!(:currency_id).and_return("1")
    @bill.stub!(:payer_id).and_return("1")
    @bill.stub!(:creator_id).and_return("1")
    @bill.stub!(:payed_at).and_return(Time.now)
    @bill.stub!(:created_at).and_return(Time.now)
    @bill.stub!(:updated_at).and_return(Time.now)
    assigns[:bill] = @bill
  end

  it "should render new form" do
    render "/bills/new.html.erb"
    
    response.should have_tag("form[action=?][method=post]", bills_path) do
      with_tag("input#bill_name[name=?]", "bill[name]")
      with_tag("textarea#bill_description[name=?]", "bill[description]")
      with_tag("input#bill_amount[name=?]", "bill[amount]")
    end
  end
end


