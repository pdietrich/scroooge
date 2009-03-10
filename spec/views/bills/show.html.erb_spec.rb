require File.dirname(__FILE__) + '/../../spec_helper'

describe "/bills/show.html.erb" do
  include BillsHelper
  
  before(:each) do
    @bill = mock_model(Bill)
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

  it "should render attributes in <p>" do
    render "/bills/show.html.erb"
    response.should have_text(/MyString/)
    response.should have_text(/MyText/)
    response.should have_text(/9\.99/)
  end
end

