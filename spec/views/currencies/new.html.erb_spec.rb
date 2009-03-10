require File.dirname(__FILE__) + '/../../spec_helper'

describe "/currencies/new.html.erb" do
  include CurrenciesHelper
  
  before(:each) do
    @currency = mock_model(Currency)
    @currency.stub!(:new_record?).and_return(true)
    @currency.stub!(:short_code).and_return("MyString")
    @currency.stub!(:name).and_return("MyString")
    @currency.stub!(:symbol).and_return("MyString")
    assigns[:currency] = @currency
  end

  it "should render new form" do
    render "/currencies/new.html.erb"
    
    response.should have_tag("form[action=?][method=post]", currencies_path) do
      with_tag("input#currency_short_code[name=?]", "currency[short_code]")
      with_tag("input#currency_name[name=?]", "currency[name]")
      with_tag("input#currency_symbol[name=?]", "currency[symbol]")
    end
  end
end


