class CreatePackages < ActiveRecord::Migration
  def self.up
    create_table :packages do |t|
      t.string :title
      t.string :slug
      t.float :price
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :packages
  end
end
