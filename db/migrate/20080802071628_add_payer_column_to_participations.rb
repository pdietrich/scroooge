class AddPayerColumnToParticipations < ActiveRecord::Migration
  def self.up
    add_column :participations, :payer_id, :integer
      execute <<-SQL
        UPDATE participations
        JOIN bills ON bills.id = participations.bill_id
        SET participations.payer_id = bills.payer_id
      SQL
  end

  def self.down
    remove_column :participations, :payer_id
  end
end
