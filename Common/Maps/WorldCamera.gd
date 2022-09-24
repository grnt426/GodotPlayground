extends Camera2D


export var min_zoom := 0.5
export var max_zoom := 3.0
export var zoom_duration := 0.2

var zoom_step = 0.5

# The camera's target zoom level.
var _zoom_level := 1.0 setget _set_zoom_level

# We store a reference to the scene's tween node.
onready var tween: Tween = $Tween

func _unhandled_input(event):
	var amount = 0
	if event.is_action_pressed("zoom_out"):
		amount += zoom_step
	elif event.is_action_pressed("zoom_in"):
		amount -= zoom_step
		
	if amount != 0:
		print("Zooming!")
	amount *= zoom_step
	_set_zoom_level(_zoom_level + amount)

func _set_zoom_level(value: float) -> void:
	_zoom_level = clamp(value, min_zoom, max_zoom)
	print("Zooming %d" % _zoom_level)
	tween.interpolate_property(
		self,
		"zoom",
		zoom,
		Vector2(_zoom_level, _zoom_level),
		zoom_duration,
		tween.TRANS_SINE,
		tween.EASE_OUT
	)
	tween.start()
