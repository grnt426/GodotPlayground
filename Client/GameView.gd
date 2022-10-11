extends Node2D

onready var UnitMoverManager := get_node("/root/UnitMoverManager")
onready var unitContextualPopup := get_node("UnitContextualPopup")

var character
var target
var selectedCharacter

var networkNode = null

var actionButtonGroup = null

func init(networkNode) -> void:
	self.networkNode = networkNode

func _ready():
	print("UnitContext Children: %s " % unitContextualPopup)
	actionButtonGroup = unitContextualPopup.get_node("GridContainer/Move").group

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
		var action = _get_selected_action()
		networkNode.moveCharacter(target, selectedCharacter.uid, action)
	else:
		print("Nothing selected, moving nothing...")

func _get_selected_action() -> String:
	var button :String = actionButtonGroup.get_pressed_button().text
	print("%s is the selected button" % button)
	return button
