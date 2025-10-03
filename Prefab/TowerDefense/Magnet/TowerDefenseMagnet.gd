@tool
class_name TowerDefenseMagnet extends TowerDefenseGroundItemBase

const TOWER_DEFENSE_MAGNET = preload("uid://baxlrxaix6r2b")

var armorInstance: TowerDefenseArmorInstance

var adsorbedObject: Node

static func Create(_armorInstance: TowerDefenseArmorInstance) -> TowerDefenseMagnet:
    var _instance = TOWER_DEFENSE_MAGNET.instantiate() as TowerDefenseMagnet
    _instance.armorInstance = _armorInstance
    return _instance

func Init(node: Node2D) -> void :
    add_child(node)

@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void :
    if !is_instance_valid(adsorbedObject):
        queue_free()
