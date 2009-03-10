require File.dirname(__FILE__) + '/../../spec_helper'

describe "/bills/index.html.erb" do
  include BillsHelper
  
  before(:each) do
    bill_98 = mock_model(Bill)
    bill_98.should_receive(:name).and_return("MyString")
    bill_98.should_receive(:description).and_return("MyText")
    bill_98.should_receive(:amount).and_return("9.99")
    bill_98.should_receive(:currency_id).and_return("1")
    bill_98.should_receive(:payer_id).and_return("1")
    bill_98.should_receive(:creator_id).and_return("1")
    bill_98.should_receive(:payed_at).and_return(Time.now)
    bill_98.should_receive(:created_at).and_return(Time.now)
    bill_98.should_receive(:updated_at).and_return(Time.now)
    bill_99 = mock_model(Bill)
    bill_99.should_receive(:name).and_return("MyString")
    bill_99.should_receive(:description).and_return("MyText")
    bill_99.should_receive(:amount).and_return("9.99")
    bill_99.should_receive(:currency_id).and_return("1")
    bill_99.should_receive(:payer_id).and_return("1")
    bill_99.should_receive(:creator_id).and_return("1")
    bill_99.should_receive(:payed_at).and_return(Time.now)
    bill_99.should_receive(:created_at).and_return(Time.now)
    bill_99.should_receive(:updated_at).and_return(Time.now)

    assigns[:bills] = [bill_98, bill_99]
  end

  it "should render list of bills" do
    render "/bills/index.html.erb"
    response.should have_tag("tr>td", "MyString", 2)
    response.should have_tag("tr>td", "MyText", 2)
    response.should have_tag("tr>td", "9.99", 2)
  end
end

