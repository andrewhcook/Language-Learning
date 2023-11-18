# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
if User.all.length != 0
  user = User.new
    user.email = "Andrew@example.com"
    user.password = "password"
    user.save
end

if Language.find_by(:name => "French").first.nil?
  french = Language.new
  french.name = "French"
  french.shortcode = "fr"
  french.save
end
if Language.find_by(:name => "English").first.nil?
  english = Language.new
  english.name = "English"
  english.shortcode = "en"
  english.save
end
