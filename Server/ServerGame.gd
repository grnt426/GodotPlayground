extends Node

func _init():
	print("Loaded ServerGame!")

remote func moveCharacter(position) -> void:
	print("Received a mouse click command, moving character")
	return
