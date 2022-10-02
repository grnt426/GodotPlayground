extends KinematicBody2D

const MOTION_SPEED = 600 # Pixels/second.

func _physics_process(_delta):
	var motion := Vector2()
	motion.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	motion.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	motion.y /= 2
	motion = motion.normalized() * MOTION_SPEED * (Input.get_action_strength("move_faster") * 2 + 1)
	#warning-ignore:return_value_discarde
	move_and_slide(motion)
