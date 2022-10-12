# This isn't super great. The coordinate of the square grid doesn't line up with
# the hexes in a clean way. Maybe this can be fixed.

extends Label
onready var tilemap:TileMap = $"../WorldMap/WorldTiles"

func _ready():
	self.text = ""

func _process(delta):

	var mousePos = get_global_mouse_position()
	var coords = tilemap.world_to_map(mousePos)
	self.text = "%s" % coords
	mousePos.x += 15
	mousePos.y += 5
	self.rect_position = mousePos
