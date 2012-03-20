class CreatePackages < ActiveRecord::Migration
  def self.up
    create_table :packages do |t|
      t.string :title
      t.string :slug
      t.float :price
      t.text :description

      t.timestamps
    end

    Package.create :title => 'Free', :slug => 'free', :price => 0, :description => 'Free Package', :companies => 1, :locations => 1, :users => 1
  end

  def self.down
    drop_table :packages
  end
end
