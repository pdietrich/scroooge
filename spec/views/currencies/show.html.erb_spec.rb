require File.dirname(__FILE__) + '/../../spec_helper'

describe "/currencies/show.html.erb" do
  include CurrenciesHelper
  
  before(:each) do
    @currency = mock_model(Currency)
    @currency.stub!(:short_code).and_return("MyString")
    @currency.stub!(:name).and_return("MyString")
    @currency.stub!(:symbol).and_return("MyString")

    assigns[:currency] = @currency
  end

  it "should render attributes in <p>" do
    render "/currencies/show.html.erb"
    response.should have_text(/MyString/)
    response.should have_text(/MyString/)
    response.should have_text(/MyString/)
  end
end

