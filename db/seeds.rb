# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create(email: "max@konow.ski", password: "hello_you", password_confirmation: "hello_you")
User.create(email: "dude@konow.ski", password: "dude_pw", password_confirmation: "dude_pw")
User.create(email: "guy@konow.ski", password: "guy_pw", password_confirmation: "guy_pw")
