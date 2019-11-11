# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

jon = User.create(username: "jon123")
jill = User.create(username: "jill420")
frank = User.create(username: "frank69")
alice = User.create(username: "alice666")

Game.create(user: jon, score: 500, time: 30)
Game.create(user: jon, score: 435, time: 56)
Game.create(user: jill, score: 234, time: 34)
Game.create(user: jill, score: 555, time: 22)
Game.create(user: frank, score: 3443, time: 123)
Game.create(user: frank, score: 232, time: 40)
Game.create(user: alice, score: 112, time: 3)
Game.create(user: alice, score: 443, time: 123)

