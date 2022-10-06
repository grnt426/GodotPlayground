extends Node2D

const gameview := preload("res://Client/GameView.tscn")
const server_ip := "127.0.0.1"
const port := 1909

var network := NetworkedMultiplayerENet.new()
var map_scene
var connected := false

func _ready():
	ConnectToServer()
	
func ConnectToServer():
	print("Attempting connection to server...")
	network.create_client(server_ip, port)
	get_tree().set_network_peer(network)
	network.connect("connection_failed", self, "_OnConnectionFailed")
	network.connect("connection_succeeded", self, "_OnConnectionSucceeded")
	
func _OnConnectionFailed():
	connected = false
	print("failed to connect")
	
func _OnConnectionSucceeded():
	print("connected!")
	print(self.get_path())
	connected = true
	if(!map_scene):
		print("Building map")
		map_scene = gameview.instance()
		get_tree().get_root().add_child(map_scene)
		map_scene.get_node("WorldMap/ClientType").text = "Client"
		print("Children:")
		for c in get_tree().get_root().get_children():
			print("Child: %s" % c)
		print("Tree: %s"  % get_tree())

remote func SyncMovedUnits(data) -> void:
	for d in data:
		UnitMoverManager.getUnit(d.uid).set_target(d.pos)

remote func SyncAllUnitPositions(data) -> void:
	for d in data:
		var unit = UnitMoverManager.registerUnit(d.oid, d.pos, d.uid)
		map_scene.add_child(unit)
