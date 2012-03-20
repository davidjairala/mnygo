class CreateCustomers < ActiveRecord::Migration
  def self.up
    create_table :customers do |t|
      t.integer :company_id
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :phone1
      t.string :phone2
      t.string :address1
      t.string :address2
      t.string :city
      t.string :state
      t.string :zip
      t.string :country
      t.text :comments
      t.string :account
      t.string :taxable

      t.timestamps
    end
  end

  def self.down
    drop_table :customers
  end
end
