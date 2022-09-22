extends Node2D

var network := NetworkedMultiplayerENet.new()
var port := 1909
var max_players := 100
var connected_players := []
var map_scene
var character

const map := preload("res://Common/Maps/SimpleTiles.tscn")
#const ServerGame := preload("res://Server/ServerGame.gd")

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
		#var game = ServerGame.new()
		#map_scene.set_script(game)
		get_tree().get_root().add_child(map_scene)
		character = map_scene.get_node("AlienChar")
		map_scene.get_node("ClientType").text = "Server"
		print("Character: " + character)
		#game.set_process(true)
		#print(get_tree().get_root())
	else:
		if(character and !character.did_arrive):
			rpc("character_update", character.position)
	
	
func _Peer_Connected(player_id):
	print("User " + str(player_id) + " connected")
	connected_players.append(player_id)
	
func _Peer_Disconnected(player_id):
	print("User " + str(player_id) + " disconnected")

remote func moveCharacter(position) -> void:
	print("Received a mouse click command, moving character")
	character.set_target(position)
	return
