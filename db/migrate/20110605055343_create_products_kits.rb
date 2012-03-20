class CreateProductsKits < ActiveRecord::Migration
  def self.up
    create_table :products_kits do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :products_kits
  end
end
