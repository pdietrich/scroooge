class CreateBills < ActiveRecord::Migration
  def self.up
    create_table :bills do |t|
      t.string :name
      t.decimal :amount, :precision => 10, :scale => 2
      t.integer :currency_id
      t.integer :payer_id
      t.integer :creator_id
      t.datetime :created_at
      t.datetime :updated_at
    end
  end

  def self.down
    drop_table :bills
  end
end
