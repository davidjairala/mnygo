class CreateLocations < ActiveRecord::Migration
  def self.up
    create_table :locations do |t|
      t.integer :company_id
      t.string :name
      t.string :address1
      t.string :address2
      t.string :city
      t.string :state
      t.string :zip
      t.string :country
      t.string :website
      t.string :phone1
      t.string :phone2
      t.string :email

      t.timestamps
    end
  end

  def self.down
    drop_table :locations
  end
end
