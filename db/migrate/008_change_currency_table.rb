class ChangeCurrencyTable < ActiveRecord::Migration
  def self.up
    drop_table :currencies
    create_table :currencies do |t|
      t.string :name, :limit => 20
      t.string :short_code, :limit => 4
      t.string :format_options_string
    end
    Currency.create(
      :name => 'British Pounds',
      :short_code => 'GBP',
      :format_options_string => { :unit => "&pound;", :format => "%u%n" }.inspect
    )
    Currency.create(
      :name => 'Euro',
      :short_code => 'EUR',
      :format_options_string => { :unit => "&euro;", :format => "%n&nbsp;%u" }.inspect
    )
    Currency.create(
      :name => 'US Dollars',
      :short_code => 'USD',
      :format_options_string => { :unit => "$", :format => "%u%n" }.inspect
    )
  end

  def self.down
    #raise ActiveRecord::IrreversibleMigration
  end
end
