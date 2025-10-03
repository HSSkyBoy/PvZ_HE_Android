@tool
class_name TowerDefenseCharacterEventHurt extends TowerDefenseCharacterEventBase

@export var num: float = 20.0
@export var playSplatAudio: bool = true

@export_storage var damageFlags: int = TowerDefenseEnum.PROJECTILE_DAMAGE_FLAG.HITBODY + TowerDefenseEnum.PROJECTILE_DAMAGE_FLAG.HITSHIELD
@export_storage var collisionFlags: int = TowerDefenseEnum.CHARACTER_COLLISION_FLAGS.GROUND_CHARACTRE + TowerDefenseEnum.CHARACTER_COLLISION_FLAGS.GRIDITEM

func Execute(pos: Vector2, target: TowerDefenseCharacter) -> void :
    Run(pos, target, num, damageFlags, playSplatAudio)

func ExecuteDps(pos: Vector2, target: TowerDefenseCharacter, delta: float) -> void :
    Run(pos, target, num * delta, damageFlags, playSplatAudio)

func ExecuteProject(projectile: TowerDefenseProjectile, target: TowerDefenseCharacter) -> void :
    Run(projectile.global_position, target, num, damageFlags, playSplatAudio)

@warning_ignore("unused_parameter")
static func Run(pos: Vector2, target: TowerDefenseCharacter, _num = 20.0, _damageFlags: int = TowerDefenseEnum.PROJECTILE_DAMAGE_FLAG.HITBODY + TowerDefenseEnum.PROJECTILE_DAMAGE_FLAG.HITSHIELD, _playSplatAudio: bool = true) -> void :
    target.FlagHurt(_num, _damageFlags, _playSplatAudio)

func _get_property_list() -> Array[Dictionary]:
    var properties: Array[Dictionary] = []
    properties.append(
        {
            "name": "Flag/Damage", 
            "type": TYPE_INT, 
            "hint": PROPERTY_HINT_FLAGS, 
            "hint_string": ",".join(TowerDefenseEnum.PROJECTILE_DAMAGE_FLAG.keys()), 
        }
    )
    properties.append(
        {
            "name": "Flag/Collision", 
            "type": TYPE_INT, 
            "hint": PROPERTY_HINT_FLAGS, 
            "hint_string": ",".join(TowerDefenseEnum.CHARACTER_COLLISION_FLAGS.keys()), 
        }
    )

    return properties

func _set(property: StringName, value: Variant) -> bool:
    match property:
        "Flag/Damage":
            damageFlags = value
            return true
        "Flag/Collision":
            collisionFlags = value
            return true
    return false

func _get(property: StringName) -> Variant:
    match property:
        "Flag/Damage":
            return damageFlags
        "Flag/Collision":
            return collisionFlags
    return null

func _property_can_revert(property: StringName):
    match property:
        "Flag/Damage":
            return true
        "Flag/Collision":
            return true

func _property_get_revert(property: StringName):
    match property:
        "Flag/Damage":
            return TowerDefenseEnum.PROJECTILE_DAMAGE_FLAG.HITBODY + TowerDefenseEnum.PROJECTILE_DAMAGE_FLAG.HITSHIELD
        "Flag/Collision":
            return TowerDefenseEnum.CHARACTER_COLLISION_FLAGS.GROUND_CHARACTRE + TowerDefenseEnum.CHARACTER_COLLISION_FLAGS.GRIDITEM
