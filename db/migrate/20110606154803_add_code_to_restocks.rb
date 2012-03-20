class AddCodeToRestocks < ActiveRecord::Migration
  def self.up
    add_column :restocks, :code, :string
  end

  def self.down
    remove_column :restocks, :code
  end
end
