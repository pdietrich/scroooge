class CreateCurrencies < ActiveRecord::Migration
  def self.up
    create_table :currencies do |t|
      t.string :short_code
      t.string :name
      t.string :symbol
    end
  end

  def self.down
    drop_table :currencies
  end
end
