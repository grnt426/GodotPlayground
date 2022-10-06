extends Node2D

onready var UnitMoverManager := get_node("/root/UnitMoverManager")
onready var unitContextualPopup := $UnitContextualPopup

var character
var target
var selectedCharacter

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		target = event.global_position
		target = get_canvas_transform().affine_inverse() * target
		if event.button_index == BUTTON_LEFT:
			_handle_left_click(target)
		elif event.button_index == BUTTON_RIGHT:
			_handle_right_click(target)

func _handle_left_click(target: Vector2) -> void:
	print("Trying to select!")

	var space_state = get_world_2d().direct_space_state
	var collision_objects = space_state.intersect_point(target, 1)
	if(collision_objects):
		if selectedCharacter:
			selectedCharacter.deselect()
		selectedCharacter = collision_objects[0].collider
		selectedCharacter.become_selected()
		unitContextualPopup.visible = true
	else:
		if(selectedCharacter):
			selectedCharacter.deselect()
			selectedCharacter = false
			unitContextualPopup.visible = false
		print("Clicked on nothing!")

func _handle_right_click(target: Vector2) -> void:
	if selectedCharacter:
		print("Got a mouse click, sending to server")
		rpc_id(1, "moveCharacter", target, selectedCharacter.uid)
	else:
		print("Nothing selected, moving nothing...")
