# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

#rails db:drop db:create db:migrate db:seed
User.create!(email: 'admin@example.com', password: 'admin@example.com', password_confirmation: 'admin@example.com')
Tenant.create!(name: "Microsoft")
Member.create!(tenant: Tenant.first, user: User.first, admin: true)
User.update_all confirmed_at: DateTime.now
#Member.first.update!(admin: true)