class AddAmountCacheToParticipations < ActiveRecord::Migration
  def self.up
    add_column :participations, :amount, :decimal, :precision => 10, :scale => 2
  end

  def self.down
    remove_column :participations, :amount
  end
end
