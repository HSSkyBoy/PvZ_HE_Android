@tool
class_name CharacterArmorConfig extends Resource

@export var armorName: String = ""
@export var damagePoint: float = 370.0
@export var stagePersontage: Array[float]:
    set(_stagePersontage):
        stagePersontage = _stagePersontage
        stagePersontage.sort_custom(
            func(a: float, b: float):
                return a > b
        )
@export_enum("Media", "Sprite") var replaceMethod: String = "Media"
@export var replaceSpriteSlotPath: NodePath
@export var replaceSpriteRotation: float = 0.0
@export var replaceSpriteScale: Vector2 = Vector2.ONE
@export var replaceSpriteOffset: Vector2 = Vector2.ZERO
@export var replaceMediaName: StringName
@export var stageAnimeTexture: Array[Texture2D]
@export_multiline var openFliter: String
@export_multiline var closeFliter: String
@export_multiline var destroyFliter: String
@export var impactAudio: String = ""
@export var damageAudio: String = ""

@export_group("Method")
@export var explodePersontage: float = 1.0
@export_group("")
@export_storage var armorMethodFlags: int = TowerDefenseEnum.ARMOR_METHOD_FLAGS.HELM + TowerDefenseEnum.ARMOR_METHOD_FLAGS.DAMAGEABLE + TowerDefenseEnum.ARMOR_METHOD_FLAGS.DROPABLE

func _get_property_list() -> Array[Dictionary]:
    var properties: Array[Dictionary] = []
    properties.append(
        {
            "name": "Flag/Method", 
            "type": TYPE_INT, 
            "hint": PROPERTY_HINT_FLAGS, 
            "hint_string": ",".join(TowerDefenseEnum.ARMOR_METHOD_FLAGS.keys()), 
        }
    )
    return properties

func _set(property: StringName, value: Variant) -> bool:
    match property:
        "Flag/Method":
            armorMethodFlags = value
            return true
    return false

func _get(property: StringName) -> Variant:
    match property:
        "Flag/Method":
            return armorMethodFlags
    return null

func _property_can_revert(property: StringName):
    match property:
        "Flag/Method":
            return true

func _property_get_revert(property: StringName):
    match property:
        "Flag/Method":
            return TowerDefenseEnum.ARMOR_METHOD_FLAGS.HELM + TowerDefenseEnum.ARMOR_METHOD_FLAGS.DAMAGEABLE + TowerDefenseEnum.ARMOR_METHOD_FLAGS.DROPABLE
