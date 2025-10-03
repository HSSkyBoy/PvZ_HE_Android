@tool
class_name TowerDefenseCharacterConfig extends Resource

@export var name: String = ""
@export var hitpointsNearDeath: float = 0.0
@export var hitpoints: float = 300.0
@export var smashHurt: float = -1.0
@export var spikeHurt: float = -1.0
@export_enum("Never", "Night", "Day") var sleepTime: String = "Never"
@export var height: TowerDefenseEnum.CHARACTER_HEIGHT = TowerDefenseEnum.CHARACTER_HEIGHT.NORMAL
@export var damagePointData: CharacterDamagePointData
@export var armorData: CharacterArmorData
@export var customData: CharacterCustomData
@export var ashScene: PackedScene
@export_category("Packet")
@export var homeWorld: GeneralEnum.HOMEWORLD = GeneralEnum.HOMEWORLD.NOONE
@export var costRise: int = -1
@export var cost: int = 100
@export var packetCooldown: float = 5.0
@export var startingCooldown: float = 0.0
@export var plantCover: Array[String] = []
@export var plantCoverRecycle: Array[int] = []
@export var plantGridType: Array[TowerDefenseEnum.PLANTGRIDTYPE] = [TowerDefenseEnum.PLANTGRIDTYPE.GROUND, TowerDefenseEnum.PLANTGRIDTYPE.POT, TowerDefenseEnum.PLANTGRIDTYPE.LILYPAD]
@export var plantGridOverrideType: TowerDefenseEnum.PLANTGRIDTYPE = TowerDefenseEnum.PLANTGRIDTYPE.NOONE
@export_storage var collisionFlags: int = TowerDefenseEnum.CHARACTER_COLLISION_FLAGS.GROUND_CHARACTRE
@export_storage var maskFlags: int = TowerDefenseEnum.CHARACTER_COLLISION_FLAGS.GROUND_CHARACTRE
@export_storage var unUseBuffFlags: int = 0
@export_storage var physiqueTypeFlags: int = 0
@export_storage var elementFlags: int = 0

func _get_property_list() -> Array[Dictionary]:
    var properties: Array[Dictionary] = []
    properties.append(
        {
            "name": "Flag/Collision", 
            "type": TYPE_INT, 
            "hint": PROPERTY_HINT_FLAGS, 
            "hint_string": ",".join(TowerDefenseEnum.CHARACTER_COLLISION_FLAGS.keys()), 
        }
    )
    properties.append(
        {
            "name": "Flag/Mask", 
            "type": TYPE_INT, 
            "hint": PROPERTY_HINT_FLAGS, 
            "hint_string": ",".join(TowerDefenseEnum.CHARACTER_COLLISION_FLAGS.keys()), 
        }
    )
    var hintString = ""
    for keyId in TowerDefenseEnum.CHARACTER_BUFF_FLAGS.keys().size():
        var key = TowerDefenseEnum.CHARACTER_BUFF_FLAGS.keys()[keyId]
        var value = TowerDefenseEnum.CHARACTER_BUFF_FLAGS.get(key)
        hintString += "%s:%d" % [key, value]
        if keyId != TowerDefenseEnum.CHARACTER_BUFF_FLAGS.keys().size() - 1:
            hintString += ","
    properties.append(
        {
            "name": "Flag/UnUseBuff", 
            "type": TYPE_INT, 
            "hint": PROPERTY_HINT_FLAGS, 
            "hint_string": hintString, 
        }
    )
    properties.append(
        {
            "name": "Flag/PhysiqueType", 
            "type": TYPE_INT, 
            "hint": PROPERTY_HINT_FLAGS, 
            "hint_string": ",".join(TowerDefenseEnum.CHARACTER_PHYSIQUE_TYPE.keys()), 
        }
    )
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
        "Flag/Collision":
            collisionFlags = value
            return true
        "Flag/Mask":
            maskFlags = value
            return true
        "Flag/UnUseBuff":
            unUseBuffFlags = value
            return true
        "Flag/PhysiqueType":
            physiqueTypeFlags = value
            return true
        "Flag/Elemet":
            elementFlags = value
            return true
    return false

func _get(property: StringName) -> Variant:
    match property:
        "Flag/Collision":
            return collisionFlags
        "Flag/Mask":
            return maskFlags
        "Flag/UnUseBuff":
            return unUseBuffFlags
        "Flag/PhysiqueType":
            return physiqueTypeFlags
        "Flag/Elemet":
            return elementFlags
    return null

func _property_can_revert(property: StringName):
    match property:
        "Flag/Collision":
            return true
        "Flag/Mask":
            return true
        "Flag/UnUseBuff":
            return true
        "Flag/PhysiqueType":
            return true
        "Flag/Elemet":
            return true

func _property_get_revert(property: StringName):
    match property:
        "Flag/Collision":
            return TowerDefenseEnum.CHARACTER_COLLISION_FLAGS.GROUND_CHARACTRE
        "Flag/Mask":
            return TowerDefenseEnum.CHARACTER_COLLISION_FLAGS.GROUND_CHARACTRE
        "Flag/UnUseBuff":
            return 0
        "Flag/PhysiqueType":
            return 0
        "Flag/Elemet":
            return 0
