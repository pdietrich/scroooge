class RenamePeopleDefaultCurrencyIdToCurrencyId < ActiveRecord::Migration
  def self.up
    rename_column :people, :default_currency_id, :currency_id
  end

  def self.down
    rename_column :people, :currency_id, :default_currency_id
  end
end
