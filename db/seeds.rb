
jon = User.create(username: "jon123")
jill = User.create(username: "jill420")
frank = User.create(username: "frank69")
alice = User.create(username: "alice666")

Game.create(user: jon, score: 43, time: 54)
Game.create(user: jon, score: 23, time: 32)
Game.create(user: jill, score: 54, time: 65)
Game.create(user: jill, score: 33, time: 22)
Game.create(user: frank, score: 23, time: 33)
Game.create(user: frank, score: 55, time: 32)
Game.create(user: alice, score: 32, time: 32)
Game.create(user: alice, score: 13, time: 15)
