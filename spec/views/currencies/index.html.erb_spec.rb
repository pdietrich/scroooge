require File.dirname(__FILE__) + '/../../spec_helper'

describe "/currencies/index.html.erb" do
  include CurrenciesHelper
  
  before(:each) do
    currency_98 = mock_model(Currency)
    currency_98.should_receive(:short_code).and_return("MyString")
    currency_98.should_receive(:name).and_return("MyString")
    currency_98.should_receive(:symbol).and_return("MyString")
    currency_99 = mock_model(Currency)
    currency_99.should_receive(:short_code).and_return("MyString")
    currency_99.should_receive(:name).and_return("MyString")
    currency_99.should_receive(:symbol).and_return("MyString")

    assigns[:currencies] = [currency_98, currency_99]
  end

  it "should render list of currencies" do
    render "/currencies/index.html.erb"
    response.should have_tag("tr>td", "MyString", 2)
    response.should have_tag("tr>td", "MyString", 2)
    response.should have_tag("tr>td", "MyString", 2)
  end
end

