class ChangeFactorColumnForParticipation < ActiveRecord::Migration
  def self.up
    change_column_default :participations, :factor, 1.0
  end

  def self.down
  end
end
