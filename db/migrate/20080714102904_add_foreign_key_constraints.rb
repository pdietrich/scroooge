class AddForeignKeyConstraints < ActiveRecord::Migration
  def self.up
      execute <<-SQL
        ALTER TABLE participations
        ADD CONSTRAINT participations__bill_id
        FOREIGN KEY (bill_id)
        REFERENCES bills(id)
        ON UPDATE restrict
        ON DELETE restrict;
      SQL
    
      execute <<-SQL
        ALTER TABLE participations
        ADD CONSTRAINT participations__currency_id
        FOREIGN KEY (currency_id)
        REFERENCES currencies(id)
        ON UPDATE restrict
        ON DELETE restrict;
      SQL
    
      execute <<-SQL
        ALTER TABLE bills
        ADD CONSTRAINT bill__currency_id
        FOREIGN KEY (currency_id)
        REFERENCES currencies(id)
        ON UPDATE restrict
        ON DELETE restrict;
      SQL
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
    execute <<-SQL
      ALTER TABLE bills
      DROP FOREIGN KEY bill__currency_id
    SQL

    execute <<-SQL
      ALTER TABLE participations
      DROP FOREIGN KEY participations__bill_id
    SQL

    execute <<-SQL
      ALTER TABLE participations
      DROP FOREIGN KEY participations__currency_id
    SQL

  end
end
