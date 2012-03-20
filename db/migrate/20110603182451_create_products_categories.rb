class CreateProductsCategories < ActiveRecord::Migration
  def self.up
    create_table :products_categories do |t|
      t.integer :company_id
      t.integer :product_id
      t.string :category

      t.timestamps
    end
  end

  def self.down
    drop_table :products_categories
  end
end
