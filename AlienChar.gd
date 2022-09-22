extends KinematicBody2D

onready var nav_agent := $NavigationAgent2D
onready var ring := self.get_node("SelectionRing")

var speed := 400
var did_arrive = true

func _ready() -> void:
	set_process(false)

func _process(delta:float) -> void:
	var move_dir := position.direction_to(nav_agent.get_next_location())
	var velocity := move_dir * speed
	nav_agent.set_velocity(velocity)
	
	if not _arrived_at_location():
		velocity = move_and_slide(velocity)
	elif not did_arrive:
		did_arrive = true

func become_selected() -> void:
	ring.playing = true
	ring.visible = true
	
func deselect() -> void:
	ring.playing = false
	ring.visible = false

func _arrived_at_location() -> bool:
	return nav_agent.is_navigation_finished()

func set_target(value) -> void:
	did_arrive = false
	nav_agent.set_target_location(value)
	set_process(true)
