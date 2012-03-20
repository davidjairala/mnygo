class CreateDivisions < ActiveRecord::Migration
  def self.up
    create_table :divisions do |t|
      t.integer :company_id
      t.integer :location_id
      t.string :name
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :divisions
  end
end
