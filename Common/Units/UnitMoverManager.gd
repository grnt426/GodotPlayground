extends Node2D

const UnitEntity := preload("res://AlienChar.tscn")

const units := {}

func _ready():
	pass

# For the Server to create new units to give to clients to track
func createUnit(ownerId, position) -> UnitMover:
	return registerUnit(ownerId, position, null)

# For use when a client receives a new unit from the Server
func registerUnit(ownerId, position, uid) -> UnitMover:
	var unit = UnitEntity.instance()
	unit.init(ownerId, position, uid)
	units[unit.uid] = unit
	return unit

func getUnit(uid: int) -> UnitMover:
	return units[uid]

func serializeAll():
	print("Serializing %d units" % units.values().size())
	var res = []
	for u in units.values():
		print(u.ownerId)
		print(u.position)
		print(u.uid)
		res.append({"oid":u.ownerId, "pos":u.position, "uid":u.uid})
	return res
