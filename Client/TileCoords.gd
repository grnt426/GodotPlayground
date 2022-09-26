# This isn't super great. The coordinate of the square grid doesn't line up with
# the hexes in a clean way. Maybe this can be fixed.

extends Label
onready var tilemap = $"../WorldMap/TileMap"

func _ready():
	self.text = ""

func _process(delta):
	var globalMouseLoc: Vector2 = get_global_mouse_position()
	var mouseLoc = get_canvas_transform().affine_inverse() * globalMouseLoc
	var coords = tilemap.world_to_map(mouseLoc)
	self.text = "%s" % coords
	globalMouseLoc.x += 15
	globalMouseLoc.y += 5
	self.rect_position = globalMouseLoc
