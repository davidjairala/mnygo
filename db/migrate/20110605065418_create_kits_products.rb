class CreateKitsProducts < ActiveRecord::Migration
  def self.up
    create_table :kits_products do |t|
      t.integer :product_kit_id
      t.integer :product_id

      t.timestamps
    end
  end

  def self.down
    drop_table :kits_products
  end
end
