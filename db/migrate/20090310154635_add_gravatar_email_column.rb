class AddGravatarEmailColumn < ActiveRecord::Migration
  def self.up
    add_column :people, :gravatar_email, :string
  end

  def self.down
    remove_column :people, :gravatar_email
  end
end
