class AddAlreadyProcessedToRestocks < ActiveRecord::Migration
  def self.up
    add_column :restocks, :already_processed, :string
  end

  def self.down
    remove_column :restocks, :already_processed
  end
end
