require File.dirname(__FILE__) + '/../../spec_helper'

describe "/currencies/edit.html.erb" do
  include CurrenciesHelper
  
  before do
    @currency = mock_model(Currency)
    @currency.stub!(:short_code).and_return("MyString")
    @currency.stub!(:name).and_return("MyString")
    @currency.stub!(:symbol).and_return("MyString")
    assigns[:currency] = @currency
  end

  it "should render edit form" do
    render "/currencies/edit.html.erb"
    
    response.should have_tag("form[action=#{currency_path(@currency)}][method=post]") do
      with_tag('input#currency_short_code[name=?]', "currency[short_code]")
      with_tag('input#currency_name[name=?]', "currency[name]")
      with_tag('input#currency_symbol[name=?]', "currency[symbol]")
    end
  end
end


