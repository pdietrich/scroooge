class ChangePeopleNaming < ActiveRecord::Migration
  def self.up
    add_column :people, :name, :string
    execute(
              "UPDATE people
               SET name = CONCAT( first_name, ' ', last_name )"
            )
    remove_column :people, :first_name
    remove_column :people, :last_name
    remove_column :people, :nick
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration  
  end
end
