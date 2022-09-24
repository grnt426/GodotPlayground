extends Camera2D

var min_zoom := 0.5
var max_zoom := 3.0
var zoom_duration := 0.2
var _zoom_step = 0.5
var _zoom_level := 1.0 setget _set_zoom_level

onready var tween: Tween = $Tween

func _unhandled_input(event):
	if event.is_action_pressed("zoom_out"):
		_set_zoom_level(_zoom_level + _zoom_step)
	elif event.is_action_pressed("zoom_in"):
		_set_zoom_level(_zoom_level - _zoom_step)

func _set_zoom_level(value: float) -> void:
	_zoom_level = clamp(value, min_zoom, max_zoom)
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
