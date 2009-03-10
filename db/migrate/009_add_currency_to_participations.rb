class AddCurrencyToParticipations < ActiveRecord::Migration
  def self.up
    add_column :participations, :currency_id, :integer
  end

  def self.down
    #raise ActiveRecord::IrreversibleMigration
    remove_column :participations, :currency_id
  end
end
