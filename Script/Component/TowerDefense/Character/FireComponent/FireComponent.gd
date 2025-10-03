class_name FireComponent extends ComponentBase

const TOWER_DEFENSE_PROJECTILE: PackedScene = preload("res://Prefab/TowerDefense/Projectile/TowerDefenseProjectile.tscn")

@export var firePosMarker: Array[Marker2D]
@export var checkArea: Area2D
@export var checkAllLine: bool = false
@export var checkLength: float = -1

@export var checkIntervalMax: int = 2

@export var fireInterval: float = 1.0
@export var fireIntervalOffset: float = 0.1

var parent: TowerDefenseCharacter
var timer: float = 0.25

var canFire: bool = false

var isCheck: bool = false
var checkIntreval: int = 0

func _ready() -> void :
    parent = get_parent()
    if checkLength != -1:
        var shape: CollisionShape2D = checkArea.get_child(0)
        shape.shape.b.x = checkLength * TowerDefenseManager.GetMapGridSize().x

func _physics_process(delta: float) -> void :
    if !alive:
        return
    if timer > 0:
        timer -= delta

    if isCheck:
        checkIntreval -= 1
        isCheck = false

func GetTarget() -> TowerDefenseCharacter:
    var targetList = TowerDefenseManager.GetCharacterTargetNearFromArray(parent, TowerDefenseManager.GetCharacterTargetLineFromArea(parent, checkArea, false), TowerDefenseEnum.TARGET_NEAR_METHOD.POSITION, false, true)
    if targetList.size() > 0:
        return targetList[0]
    return null

func CanFire(projectileName: String, collectionFlag: int = -1) -> bool:
    if !is_instance_valid(TowerDefenseManager.currentControl) || !TowerDefenseManager.currentControl.isGameRunning:
        return false
    if timer > 0:
        return false
    isCheck = true
    if checkIntreval > 0:
        return false
    set_deferred("checkIntreval", checkIntervalMax)
    if collectionFlag == -1:
        collectionFlag = parent.instance.collisionFlags
    if checkArea:
        if checkArea.has_overlapping_areas():
            var mapControl: TowerDefenseMapControl = TowerDefenseManager.GetMapControl()
            var areas: Array[Area2D] = checkArea.get_overlapping_areas()
            for area: Area2D in areas:
                var character = area.get_parent()
                if character is TowerDefenseCharacter:
                    if !mapControl || (mapControl && character.global_position.x <= mapControl.config.edge.z):
                        if !(collectionFlag & character.instance.maskFlags):
                            continue
                        if parent.CanTarget(character) && (checkAllLine || parent.CheckSameLine(character.gridPos.y)):
                            if character.instance.height >= min(TowerDefenseEnum.CHARACTER_HEIGHT.NORMAL, parent.instance.height) || character.instance.height > parent.instance.height:
                                return true
    else:
        var mapControl: TowerDefenseMapControl = TowerDefenseManager.GetMapControl()
        var projectileConfig: TowerDefenseProjectileConfig = TowerDefenseManager.GetProjectileConfig(projectileName)
        if projectileConfig.fireMethodFlags & TowerDefenseEnum.PROJECTILE_FIRE_METHOD_FLAG.TRACK:
            var characterList: Array = TowerDefenseManager.GetCharacterTarget(parent)
            for character in characterList:
                if character is TowerDefenseCharacter:
                    if !mapControl || (mapControl && character.global_position.x <= mapControl.config.edge.z):
                        if !(collectionFlag & character.instance.maskFlags):
                            continue
                        if parent.CanTarget(character):
                            return true
    return false

func Refresh() -> void :
    timer = fireInterval + randf_range( - fireIntervalOffset * 2.0, - fireIntervalOffset)
    canFire = false

func CreateProjectile(posId: int, velocity: Vector2, projectileName: String, collisionFlags: int = -1, camp: TowerDefenseEnum.CHARACTER_CAMP = parent.camp, offset: Vector2 = Vector2.ZERO) -> TowerDefenseProjectile:
    if collisionFlags == -1:
        collisionFlags = parent.instance.collisionFlags
    var projectileConfig: TowerDefenseProjectileConfig = TowerDefenseManager.GetProjectileConfig(projectileName)
    var pos: Vector2 = parent.global_position
    if firePosMarker.size() > posId:
        pos = firePosMarker[posId].global_position
    var height: float = parent.GetGroundHeight(pos.y)
    var target: TowerDefenseCharacter = null

    var projectile: TowerDefenseProjectile = CreateProjectilePosition(parent, null, height - parent.groundHeight, pos, velocity * sign(parent.scale * parent.transformPoint.scale), projectileName, collisionFlags, camp, offset)
    projectile.gridPos.y = parent.gridPos.y

    if projectileConfig.fireMethodFlags & TowerDefenseEnum.PROJECTILE_FIRE_METHOD_FLAG.TRACK:
        var targetList = TowerDefenseManager.GetProjectileTargetNearProjectile(projectile, collisionFlags, TowerDefenseEnum.TARGET_NEAR_METHOD.POSITION, false)
        if targetList.size() > 0:
            target = targetList[0]

    if projectileConfig.fireMethodFlags & TowerDefenseEnum.PROJECTILE_FIRE_METHOD_FLAG.CATAPULT:
        var targetList = TowerDefenseManager.GetCharacterTargetNearFromArray(parent, TowerDefenseManager.GetCharacterTargetLineFromArea(parent, checkArea, false), TowerDefenseEnum.TARGET_NEAR_METHOD.POSITION, false, true)
        if targetList.size() > 0:
            target = targetList[0]
    projectile.target = target
    return projectile

static func CreateProjectilePosition(character: TowerDefenseCharacter, target: TowerDefenseCharacter, height: float, pos: Vector2, velocity: Vector2, projectileName: String, collisionFlags = -1, camp: TowerDefenseEnum.CHARACTER_CAMP = TowerDefenseEnum.CHARACTER_CAMP.ALL, offset: Vector2 = Vector2.ZERO) -> TowerDefenseProjectile:
    var projectileConfig: TowerDefenseProjectileConfig = TowerDefenseManager.GetProjectileConfig(projectileName)
    var charcaterNode: Node2D = TowerDefenseManager.GetCharacterNode()
    var projectile: TowerDefenseProjectile = ObjectManager.PoolPop(ObjectManagerConfig.OBJECT.PROJECTILE, charcaterNode) as TowerDefenseProjectile
    if is_instance_valid(character):
        projectile.global_position = character.global_position + Vector2(pos.x - character.global_position.x, 20.0)
    else:
        projectile.global_position = pos
    projectile.Init(character, velocity, projectileConfig, collisionFlags, camp, height + offset.y + 20, target)
    return projectile
