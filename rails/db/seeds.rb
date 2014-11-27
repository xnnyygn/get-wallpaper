# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Category.create({name: 'Nature'})
Category.create({name: 'Game'})
Category.create({name: 'Food'})
Category.create({name: 'Motor'})
Category.create({name: 'Computer'})
Category.create({name: 'City'})