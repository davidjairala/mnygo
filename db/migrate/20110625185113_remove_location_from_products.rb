class RemoveLocationFromProducts < ActiveRecord::Migration
  def self.up
    remove_column :products, :location
  end

  def self.down
    add_column :products, :location, :string
  end
end
