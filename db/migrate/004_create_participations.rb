class CreateParticipations < ActiveRecord::Migration
  def self.up
    create_table :participations do |t|
      t.integer :bill_id
      t.integer :participant_id
      t.integer :factor
      t.integer :creator_id
      t.datetime :created_at
      t.datetime :updated_at
    end
  end

  def self.down
    drop_table :participations
  end
end
