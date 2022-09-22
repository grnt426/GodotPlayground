extends Node2D

#onready var line_2d : Line2D = $ComputedPath
onready var character := $AlienChar
var target

func _init():
	print("Loaded ClientGame!")

func _unhandled_input(event: InputEvent) -> void:
	print("Got unhandled input")
	if not event is InputEventMouseButton:
		return
	
	if event.button_index != BUTTON_LEFT or not event.pressed:
		return
	
	print("Got a mouse click, sending to server")
	target = event.global_position
	rpc_id(1, "moveCharacter", target)
	#character.set_target(event.global_position)
	#line_2d.points = character.nav_agent.get_nav_path()
