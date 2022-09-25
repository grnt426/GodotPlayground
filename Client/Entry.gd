extends Node2D

const gameview := preload("res://Client/GameView.tscn")
const server_ip := "127.0.0.1"
const port := 1909

onready var UnitMoverManager = get_node("/root/UnitMoverManager")
onready var camera = get_node("/root/Client/GameView/CameraMover/WorldCamera")

var network := NetworkedMultiplayerENet.new()
var map_scene
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

remote func SyncMovedUnits(data) -> void:
	for d in data:
		UnitMoverManager.getUnit(d.uid).set_target(d.pos)

remote func SyncAllUnitPositions(data) -> void:
	for d in data:
		var unit = UnitMoverManager.registerUnit(d.oid, d.pos, d.uid)
		map_scene.add_child(unit)

func _unhandled_input(event: InputEvent) -> void:	
	if event is InputEventMouseButton and event.pressed:
		target = event.global_position
		
		var target = get_canvas_transform().affine_inverse() * target
		if event.button_index == BUTTON_LEFT:
			_handle_left_click(event)
		elif event.button_index == BUTTON_RIGHT:
			_handle_right_click(event)

func _handle_left_click(event) -> void:
	print("Trying to select!")

	var space_state = get_world_2d().direct_space_state
	var collision_objects = space_state.intersect_point(target, 1)
	if(collision_objects):
		if selectedCharacter:
			selectedCharacter.deselect()
		selectedCharacter = collision_objects[0].collider
		selectedCharacter.become_selected()
	else:
		if(selectedCharacter):
			selectedCharacter.deselect()
			selectedCharacter = false
		print("Clicked on nothing!")

func _handle_right_click(event) -> void:
	if selectedCharacter:
		print("Got a mouse click, sending to server")
		rpc_id(1, "moveCharacter", target, selectedCharacter.uid)
	else:
		print("Nothing selected, moving nothing...")
