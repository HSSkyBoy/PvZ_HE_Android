@tool
class_name TowerDefenseCellConfig extends Resource

@export var pos: Vector4i = Vector4i.ZERO
@export_category("Setting")
@export var gridType: Array[TowerDefenseEnum.PLANTGRIDTYPE] = [TowerDefenseEnum.PLANTGRIDTYPE.GROUND, TowerDefenseEnum.PLANTGRIDTYPE.AIR]
@export_storage var elementFlags: int = 0

func _get_property_list() -> Array[Dictionary]:
    var properties: Array[Dictionary] = []
    properties.append(
        {
            "name": "Flag/Elemet", 
            "type": TYPE_INT, 
            "hint": PROPERTY_HINT_FLAGS, 
            "hint_string": ",".join(TowerDefenseEnum.ELEMENT_SYSTEM.keys()), 
        }
    )
    return properties

func _set(property: StringName, value: Variant) -> bool:
    match property:
        "Flag/Elemet":
            elementFlags = value
            return true
    return false

func _get(property: StringName) -> Variant:
    match property:
        "Flag/Elemet":
            return elementFlags
    return null

func _property_can_revert(property: StringName) -> bool:
    match property:
        "Flag/Elemet":
            return true
    return false

func _property_get_revert(property: StringName) -> Variant:
    match property:
        "Flag/Elemet":
            return 0
    return null
