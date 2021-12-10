# frozen_string_literal: true
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


User.where(email: "admin@team04.com").first_or_create(password: "Password123", password_confirmation:"Password123", admin: true, role: 'admin')
User.where(email: "reporter@team04.com").first_or_create(password: "Password123", password_confirmation:"Password123", admin: false, role: 'reporter')
User.where(email: "customer@team04.com").first_or_create(password: "Password123", password_confirmation:"Password123", admin: false, role: 'customer')
User.where(email: "business@team04.com").first_or_create(password: "Password123", password_confirmation:"Password123", admin: false, role: 'customer')