extends Node

# Based on; https://github.com/Wavesonics/GodotClientServer
func _ready():
	print("Application started")
	if OS.get_environment("IS_SERVER") or OS.has_feature("server"):
		print("Is server")
		get_tree().change_scene("res://server/Entry.tscn")
	elif OS.has_feature("client"):
		print("Is client")
		get_tree().change_scene("res://client/Entry.tscn")

	# When running from the editor, this is how we'll default to being a client
	else:
		print("Could not detect application type! Defaulting to client.")
		get_tree().change_scene("res://client/Entry.tscn")
		#get_tree().change_scene("res://server/Entry.tscn")
