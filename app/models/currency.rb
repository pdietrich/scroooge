class Currency < ActiveRecord::Base
  
  validates_presence_of :name, :short_code, :format_options_string
  
  # for currency options see API doc for number_to_currency
  def format_options
    @format_options ||= eval( self.format_options_string )
  end
  
end
