# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

free_package = Package.find_or_initialize_by_slug('Free')

if free_package.new_record?
  free_package.title = 'Free'
  free_package.slug = 'free'
  free_package.price = 0
  free_package.description = 'Free Package'
  free_package.companies = 1
  free_package.locations = 1
  free_package.users = 1
  free_package.save
end

admin_user = User.find_or_initialize_by_username('admin')

if admin_user.new_record?
  admin_user.email = 'info@mnygo.com'
  admin_user.password = '6669e95ac202eefa9d3f947ec00990ce'
  admin_user.level = 'admin'
  admin_user.first_name = 'mnygo'
  admin_user.last_name = 'admininistrator'
  admin_user.save
end