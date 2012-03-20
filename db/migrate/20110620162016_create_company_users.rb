class CreateCompanyUsers < ActiveRecord::Migration
  def self.up
    create_table :company_users do |t|
      t.integer :company_id
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :company_users
  end
end
