extends Node2D

onready var line_2d : Line2D = $ComputedPath
onready var character := $Common/Units/MovingUnit

func _unhandled_input(event: InputEvent) -> void:
	if not event is InputEventMouseButton:
		return
	
	if event.button_index != BUTTON_LEFT or not event.pressed:
		return
		
	character.set_target(event.global_position)
	line_2d.points = character.nav_agent.get_nav_path()
