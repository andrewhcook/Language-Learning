# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
user = User.new
  user.email = "Andrew@example.com"
  user.password = "password"
  user.save

  french = Language.new
  french.name = "French"
  french.shortcode = "fr"
  french.save

  english = Language.new
  english.name = "English"
  english.shortcode = "en"
  english.save
