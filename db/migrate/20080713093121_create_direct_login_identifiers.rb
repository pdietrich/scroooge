class CreateDirectLoginIdentifiers < ActiveRecord::Migration
  def self.up
    create_table :direct_login_identifiers, :force => true do |t|
      t.integer :identified_person_id, :null => false
      t.integer :invitor_id
      t.string  :code
      t.boolean :obsolete, :default => false
      t.datetime :created_at
    end
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
