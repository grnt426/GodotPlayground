extends Node2D

var network := NetworkedMultiplayerENet.new()
var server_ip := "127.0.0.1"
var port := 1909
var map_scene
const map := preload("res://Common/Maps/SimpleTiles.tscn")
#const ClientGame := preload("res://Client/ClientGame.gd")
var connected := false
var character
var target
var selectedCharacter

func _ready():
	ConnectToServer()
	
func ConnectToServer():
	print("Attempting connection to server...")
	network.create_client(server_ip, port)
	get_tree().set_network_peer(network)
	network.connect("connection_failed", self, "_OnConnectionFailed")
	network.connect("connection_succeeded", self, "_OnConnectionSucceeded")
	
func _OnConnectionFailed():
	print("failed to connect")
	
func _OnConnectionSucceeded():
	print("connected!")
	print(self.get_path())
	connected = true
	if(!map_scene):
		print("Building map")
		map_scene = map.instance()
		#var game = ClientGame.new()
		#map_scene.set_script(game)
		get_tree().get_root().add_child(map_scene)
		character = map_scene.get_node("AlienChar")
		map_scene.get_node("ClientType").text = "Client"
		#game.set_process_unhandled_input(true)
		#print("Handling Unprocessed? " + str(game.is_processing_unhandled_input()))

remote func character_update(position) -> void:
	print("Got character data")
	character.position = position

func _physics_process(_dt: float) -> void:
	return

func _unhandled_input(event: InputEvent) -> void:
	if not event is InputEventMouseButton:
		return
		
	if not event.pressed:
		return
		
	target = event.global_position
	
	if event.button_index == BUTTON_LEFT:
		print("Trying to select!")
		
		var space_state = get_world_2d().direct_space_state
		var collision_objects = space_state.intersect_point(target, 1)
		if(collision_objects):
			selectedCharacter = collision_objects[0].collider
			selectedCharacter.become_selected()
		else:
			if(selectedCharacter):
				selectedCharacter.deselect()
				selectedCharacter = false
			print("Clicked on nothing!")
	elif event.button_index == BUTTON_RIGHT:
		if selectedCharacter:
			print("Got a mouse click, sending to server")
			rpc_id(1, "moveCharacter", target)
		else:
			print("Nothing selected, moving nothing...")
	#character.set_target(event.global_position)
	#line_2d.points = character.nav_agent.get_nav_path()
