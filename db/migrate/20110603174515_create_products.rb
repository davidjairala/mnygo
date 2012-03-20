class CreateProducts < ActiveRecord::Migration
  def self.up
    create_table :products do |t|
      t.string :code
      t.string :name
      t.string :category
      t.integer :supplier_id
      t.float :cost
      t.float :price
      t.string :tax1_name
      t.float :tax1
      t.string :tax2_name
      t.float :tax2
      t.string :tax3_name
      t.float :tax3
      t.integer :quantity
      t.integer :reorder
      t.text :description
      t.text :comments

      t.timestamps
    end
  end

  def self.down
    drop_table :products
  end
end
