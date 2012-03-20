class CreateRestocks < ActiveRecord::Migration
  def self.up
    create_table :restocks do |t|
      t.integer :product_id
      t.integer :supplier_id
      t.integer :quantity
      t.datetime :when
      t.string :received
      t.text :comments

      t.timestamps
    end
  end

  def self.down
    drop_table :restocks
  end
end
