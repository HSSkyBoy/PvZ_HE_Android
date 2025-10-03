@tool
class_name TowerDefenseProjectileConfig extends Resource

@export var name: String
@export var size: Vector2 = Vector2(65, 65)

@export var baseDamage: float = 20.0

@export var projectileScene: PackedScene
@export var projectileObject: ObjectManagerConfig.OBJECT = ObjectManagerConfig.OBJECT.NOONE
@export_enum("Particles", "Sprite") var splatSceneType: String = "Particles"
@export var splatAudio: String = "SplatNormal"
@export var splatScene: PackedScene
@export var splatObject: ObjectManagerConfig.OBJECT = ObjectManagerConfig.OBJECT.NOONE

@export var hitEffect: PackedScene

@export var hitTargetEventList: Array[TowerDefenseCharacterEventBase]
@export var hitCharacterEventList: Array[TowerDefenseCharacterEventBase]
@export var hitGroundEventList: Array[TowerDefenseCharacterEventBase]

@export_group("Init")
@export var rotateScale: float = 0.0
@export var hitBody: bool = false
@export var fireLength: float = -1

@export_group("Range")
@export var useRange: bool = false
@export var rangeSize: Vector2 = Vector2(0.5, 0.5)
@export var hitPesontage: float = 0.25

@export_group("")

@export_storage var damageFlags: int = TowerDefenseEnum.PROJECTILE_DAMAGE_FLAG.HITBODY + TowerDefenseEnum.PROJECTILE_DAMAGE_FLAG.HITSHIELD
@export_storage var fireMethodFlags: int = TowerDefenseEnum.PROJECTILE_FIRE_METHOD_FLAG.SHOOTER
@export_storage var collisionFlags: int = TowerDefenseEnum.CHARACTER_COLLISION_FLAGS.GROUND_CHARACTRE + TowerDefenseEnum.CHARACTER_COLLISION_FLAGS.GRIDITEM

@export_storage var catapultHeight: float = 300.0

@export_storage var penetrateNum: int = 3
@export_storage var penetrateOverBack: bool = true

@export_storage var backOutGround: bool = true
@export_storage var backDuration: float = 1.0

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
            "name": "Flag/FireMethod", 
            "type": TYPE_INT, 
            "hint": PROPERTY_HINT_FLAGS, 
            "hint_string": ",".join(TowerDefenseEnum.PROJECTILE_FIRE_METHOD_FLAG.keys()), 
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


    var catpultFlag: bool = fireMethodFlags & TowerDefenseEnum.PROJECTILE_FIRE_METHOD_FLAG.CATAPULT
    var penetrateFlag: bool = fireMethodFlags & TowerDefenseEnum.PROJECTILE_FIRE_METHOD_FLAG.PENETRATE
    var backFlag: bool = fireMethodFlags & TowerDefenseEnum.PROJECTILE_FIRE_METHOD_FLAG.BACK
    if catpultFlag:
        properties.append(
            {
                "name": "Catapult/Height", 
                "type": TYPE_FLOAT
            }
        )
    if penetrateFlag:
        properties.append(
            {
                "name": "Penetrate/Num", 
                "type": TYPE_INT
            }
        )
        if backFlag:
            properties.append(
                {
                    "name": "Penetrate/OverBack", 
                    "type": TYPE_BOOL
                }
            )
    if backFlag:
        properties.append(
            {
                "name": "Back/OutOfGround", 
                "type": TYPE_BOOL
            }
        )
        properties.append(
            {
                "name": "Back/Duration", 
                "type": TYPE_FLOAT
            }
        )
    return properties

func _set(property: StringName, value: Variant) -> bool:
    match property:
        "Flag/Damage":
            damageFlags = value
            return true
        "Flag/FireMethod":
            fireMethodFlags = value
            notify_property_list_changed()
            return true
        "Flag/Collision":
            collisionFlags = value
            return true

        "Catapult/Height":
            catapultHeight = value
            return true
        "Penetrate/Num":
            penetrateNum = value
            return true
        "Penetrate/OverBack":
            penetrateOverBack = value
            return true
        "Back/OutOfGround":
            backOutGround = value
            return true
        "Back/Duration":
            backDuration = value
            return true
    return false

func _get(property: StringName) -> Variant:
    match property:
        "Flag/Damage":
            return damageFlags
        "Flag/FireMethod":
            return fireMethodFlags
        "Flag/Collision":
            return collisionFlags

        "Catapult/Height":
            return catapultHeight
        "Penetrate/Num":
            return penetrateNum
        "Penetrate/OverBack":
            return penetrateOverBack
        "Back/OutOfGround":
            return backOutGround
        "Back/Duration":
            return backDuration
    return null

func _property_can_revert(property: StringName):
    match property:
        "Flag/Damage":
            return true
        "Flag/FireMethod":
            return true
        "Flag/Collision":
            return true

        "Catapult/Height":
            return true
        "Penetrate/Num":
            return true
        "Penetrate/OverBack":
            return true
        "Back/OutOfGround":
            return true
        "Back/Duration":
            return true

func _property_get_revert(property: StringName):
    match property:
        "Flag/Damage":
            return TowerDefenseEnum.PROJECTILE_DAMAGE_FLAG.HITBODY + TowerDefenseEnum.PROJECTILE_DAMAGE_FLAG.HITSHIELD
        "Flag/FireMethod":
            return TowerDefenseEnum.PROJECTILE_FIRE_METHOD_FLAG.SHOOTER
        "Flag/Collision":
            return TowerDefenseEnum.CHARACTER_COLLISION_FLAGS.GROUND_CHARACTRE


        "Catapult/Height":
            return 400.0
        "Penetrate/Num":
            return 3
        "Penetrate/OverBack":
            return true
        "Back/OutOfGround":
            return true
        "Back/Duration":
            return 1.0

func CanCollision(maskFlags: int) -> bool:
    return maskFlags & collisionFlags
