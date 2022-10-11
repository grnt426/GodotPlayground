extends Node2D

onready var UnitMoverManager = get_node("/root/UnitMoverManager")
var network := NetworkedMultiplayerENet.new()
var port := 1909
var max_players := 100
var connected_players := []
var map_scene
onready var database = Database.new()

const map := preload("res://Common/Maps/SimpleTiles.tscn")

func _ready():
	print("Database thing %s" % database)
	print("Database running? %s" % database.isConnected())
	StartServer()
	
func StartServer():
	self.set_physics_process(false)
	
	# Load map
	map_scene = map.instance()
	get_tree().get_root().add_child(map_scene)
	map_scene.get_node("ClientType").text = "Server"

	# Spawn some units
	var pos = Vector2(300, 300)
	map_scene.add_child(UnitMoverManager.createUnit(2, pos))
	pos = Vector2(330, 290)
	map_scene.add_child(UnitMoverManager.createUnit(3, pos))
	
	
	# Prepare to receive connections
	network.create_server(port, max_players)
	get_tree().set_network_peer(network)
	print("Server has started")
	
	network.connect("peer_connected", self, "_Peer_Connected")
	network.connect("peer_disconnected", self, "_Peer_Disconnected")
	
func _physics_process(_dt: float) -> void:
	var updates = []
	for u in UnitMoverManager.units.values():
		if !u.did_arrive:
			updates.append({"uid":u.uid, "pos":u.position})
	if updates.size() > 0:
		rpc("SyncMovedUnits", updates)
	
	
func _Peer_Connected(player_id: int):
	self.set_physics_process(true)
	print("User " + str(player_id) + " connected")
	connected_players.append(player_id)
	rpc_id(player_id, "SyncAllUnitPositions", UnitMoverManager.serializeAll())
	
func _Peer_Disconnected(player_id):
	print("User " + str(player_id) + " disconnected")

remote func moveCharacter(position: Vector2, uid: int, action: String) -> void:
	action = action.to_lower()
	print("Received an action command: %s" % action)
	var unit = UnitMoverManager.getUnit(uid)
	
	if action == "move":
		print("Received move command")
		unit.set_target(position)
	elif action == "patrol":
		print("Received patrol command")
	else:
		print("Invalid action, doing nothing")
