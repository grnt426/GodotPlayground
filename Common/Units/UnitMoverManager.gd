extends Node2D

const UnitEntity := preload("res://Common/Units/MovingUnit.tscn")

const units := {}

func _ready():
	pass

# For the Server to create new units to give to clients to track
func createUnit(ownerId, position) -> MovingUnit:
	return registerUnit(ownerId, position, null)

# For use when a client receives a new unit from the Server
func registerUnit(ownerId, position, uid) -> MovingUnit:
	var unit = UnitEntity.instance()
	unit.init(ownerId, position, uid)
	units[unit.uid] = unit
	return unit

func getUnit(uid: int) -> MovingUnit:
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
