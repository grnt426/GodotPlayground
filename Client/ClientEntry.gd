extends Node

var network := NetworkedMultiplayerENet.new()
var server_ip := "127.0.0.1"
var port := 1909
var map_scene
const map := preload("res://SimpleTiles.tscn")
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
	print("failed to connect")
	
func _OnConnectionSucceeded():
	print("connected!")
	connected = true

func _physics_process(_dt: float) -> void:
	if(connected and !map_scene):
		print("Building map")
		map_scene = map.instance()
		get_tree().get_root().add_child(map_scene)
