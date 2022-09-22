extends Node

var network := NetworkedMultiplayerENet.new()
var port := 1909
var max_players := 100
var connected_players := []
var map_scene

const map := preload("res://SimpleTiles.tscn")

func _ready():
	StartServer()
	
func StartServer():
	network.create_server(port, max_players)
	get_tree().set_network_peer(network)
	print("Server has started")
	
	network.connect("peer_connected", self, "_Peer_Connected")
	network.connect("peer_disconnected", self, "_Peer_Disconnected")
	
func _physics_process(_dt: float) -> void:
	if(connected_players.size() >= 1 and !map_scene) :
		map_scene = map.instance()
		get_tree().get_root().add_child(map_scene)
	
	
func _Peer_Connected(player_id):
	print("User " + str(player_id) + " connected")
	connected_players.append(player_id)
	
func _Peer_Disconnected(player_id):
	print("User " + str(player_id) + " disconnected")
