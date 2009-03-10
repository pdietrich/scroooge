require File.dirname(__FILE__) + '/../../spec_helper'

describe "/bills/edit.html.erb" do
  include BillsHelper
  
  before do
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

  it "should render edit form" do
    render "/bills/edit.html.erb"
    
    response.should have_tag("form[action=#{bill_path(@bill)}][method=post]") do
      with_tag('input#bill_name[name=?]', "bill[name]")
      with_tag('textarea#bill_description[name=?]', "bill[description]")
      with_tag('input#bill_amount[name=?]', "bill[amount]")
    end
  end
end


