extends Node

const players := {}
const playersByConn := {}

func _ready():
	pass

# For the Server to create new units to give to clients to track
func createPlayer(username:String, id:int, connId:int) -> Player:
	var player = Player.new()
	player.init(username, id, connId)
	players[player.id] = player
	if connId != -1:
		playersByConn[connId] = player
	return player

# For use when a client receives a new unit from the Server
func registerPlayer(username:String, id:int) -> Player:
	return createPlayer(username, id, -1)

func getPlayer(id: int) -> Player:
	return players[id]
	
func getPlayerByConnId(connId: int) -> Player:
	return playersByConn[connId]

func serializeAll():
	print("Serializing %d units" % players.values().size())
	var res = []
	for p in players.values():
		print(p.id)
		print(p.username)
		res.append({"id":p.id, "user":p.username})
	return res
