class AddNameToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string

    User.create :username => 'admin', :email => 'info@mnygo.com', :password => '6669e95ac202eefa9d3f947ec00990ce', :level => 'admin', :first_name => 'mnygo', :last_name => 'admininistrator'
  end

  def self.down
    remove_column :users, :first_name
    remove_column :users, :last_name
  end
end
