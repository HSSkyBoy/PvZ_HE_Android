@tool
class_name TowerDefenseProjectile extends TowerDefenseGroundItemBase

@onready var projectileBodyNode: Node2D = %ProjectileBodyNode
@onready var shadowSprite: Sprite2D = %ShadowSprite
@onready var hitBox: Area2D = %HitBox

var rememberPos: Vector2 = Vector2.ZERO

var checkAll: bool = false
var useFall: bool = false:
    set(_useFall):
        useFall = _useFall
        if useFall:
            projectileBodyNode.rotation = Vector2(velocity.x, ySpeed).angle()
            shadowSprite.position.y = height
            shadowSprite.scale = Vector2.ZERO
var useGravity: bool = false:
    set(_useGravity):
        useGravity = _useGravity
        if useGravity:
            projectileBodyNode.rotation = Vector2(velocity.x, ySpeed).angle()
            shadowSprite.position.y = height
            shadowSprite.scale = Vector2.ZERO
var fireCharacter: TowerDefenseCharacter = null
var velocity: Vector2 = Vector2.ZERO
var speed: float = 0.0
var config: TowerDefenseProjectileConfig
var camp: TowerDefenseEnum.CHARACTER_CAMP = TowerDefenseEnum.CHARACTER_CAMP.ALL
var projectileHeight: TowerDefenseEnum.CHARACTER_HEIGHT = TowerDefenseEnum.CHARACTER_HEIGHT.NORMAL
var height: float = 0.0
var target: TowerDefenseCharacter = null

var catapultTime: float = 0.0
var catapultTimer: float = 0.0
var catapultTargetPos: Vector2 = Vector2.ZERO
var catapultControlPoint: Vector2 = Vector2.ZERO

var penetrateNum: int = 0

var projectileSprite: Node2D

var hitOver: bool = false

var savePos: Vector2 = Vector2.ZERO
var checkDistance: float = 0.0

var fireLength: float = -1

var rect: Rect2

var trackOpen: bool = false
var catapultOpen: bool = false

var shadowScaleSave: Vector2 = Vector2.ONE

var initSet: bool = false
var initHitList: Array[Area2D]

var setZInterval: int = 2

var moveTween: Tween

func Refresh() -> void :
    add_to_group("Projectile", true)

    gravityUse = true
    ySpeed = 0
    z = 0
    scale = Vector2.ONE
    checkAll = false
    useFall = false
    useGravity = false
    fireCharacter = null
    velocity = Vector2.ZERO
    speed = 0.0
    camp = TowerDefenseEnum.CHARACTER_CAMP.NOONE
    projectileHeight = TowerDefenseEnum.CHARACTER_HEIGHT.NORMAL
    height = 0.0
    target = null
    catapultTargetPos = Vector2.ZERO
    catapultTimer = 0.0
    penetrateNum = 0

    projectileSprite = null

    savePos = Vector2.ZERO

    checkDistance = 0.0
    fireLength = -1

    projectileBodyNode.rotation = 0.0
    projectileBodyNode.position = Vector2.ZERO

    shadowSprite.scale = Vector2.ZERO
    shadowSprite.position.y = 0
    hitBox.position.y = shadowSprite.position.y - 40

    trackOpen = false
    catapultOpen = false

    hitOver = false

    for node in projectileBodyNode.get_children():
        node.queue_free()

    await get_tree().physics_frame
    if !useFall:
        hitBox.process_mode = Node.PROCESS_MODE_INHERIT

func Recycle() -> void :
    if is_instance_valid(moveTween):
        if moveTween.is_running():
            moveTween.kill()
    hitBox.set_deferred("process_mode", Node.PROCESS_MODE_DISABLED)
    hitOver = true
    for node in projectileBodyNode.get_children():
        if config.projectileObject != ObjectManagerConfig.OBJECT.NOONE:
            ObjectManager.PoolPush(config.projectileObject, node)
        else:
            node.queue_free()
    remove_from_group("Projectile")
    ySpeed = 0

func Init(_fireCharacter: TowerDefenseCharacter, _velocity: Vector2, _config: TowerDefenseProjectileConfig, _camp: TowerDefenseEnum.CHARACTER_CAMP, _height: float = height, _target: TowerDefenseCharacter = target):
    config = _config
    if config.projectileObject != ObjectManagerConfig.OBJECT.NOONE:
        ObjectManager.PoolPop(config.projectileObject, projectileBodyNode)
    else:
        projectileSprite = config.projectileScene.instantiate()
        projectileBodyNode.add_child(projectileSprite)

    rememberPos = global_position

    fireCharacter = _fireCharacter

    camp = _camp
    height = _height
    velocity = _velocity
    speed = velocity.length()
    target = _target

    shadowSprite.position.y = height
    hitBox.position.y = shadowSprite.position.y - 40

    shadowSprite.scale = config.size / Vector2(65, 65)
    shadowScaleSave = shadowSprite.scale
    fireLength = config.fireLength
    savePos = global_position

    if fireCharacter:
        projectileHeight = min(TowerDefenseEnum.CHARACTER_HEIGHT.NORMAL, fireCharacter.instance.height)

    if config.fireLength != -1:
        checkDistance = TowerDefenseManager.GetMapGridSize().x * config.fireLength

    if config.fireMethodFlags & TowerDefenseEnum.PROJECTILE_FIRE_METHOD_FLAG.TRACK:
        gridPos.y = 10
        trackOpen = true
        checkAll = true

    if config.fireMethodFlags & TowerDefenseEnum.PROJECTILE_FIRE_METHOD_FLAG.PENETRATE:
        penetrateNum = config.penetrateNum

    initSet = false
    await get_tree().physics_frame
    initSet = true
    for hit in initHitList:
        if is_instance_valid(hit):
            HitCheck(hit)
    initHitList.clear()
    if config.fireMethodFlags & TowerDefenseEnum.PROJECTILE_FIRE_METHOD_FLAG.CATAPULT:
        var targePos = Vector2(TowerDefenseManager.GetMapGroundRight(), global_position.y)
        catapultTargetPos = targePos + Vector2(120, -60)
        if is_instance_valid(target):
            catapultTargetPos = target.shadowSprite.global_position + Vector2(10, -10)




        catapultTime = 1.0
        catapultControlPoint = (catapultTargetPos + global_position) / 2 + Vector2(0, - config.catapultHeight)
        velocity = Vector2.ZERO
        catapultOpen = true

func Change(_config: TowerDefenseProjectileConfig) -> void :
    if !is_instance_valid(fireCharacter):
        fireCharacter = null
    for node in projectileBodyNode.get_children():
        if config.projectileObject != ObjectManagerConfig.OBJECT.NOONE:
            ObjectManager.PoolPush(config.projectileObject, node)
        else:
            node.queue_free()
    Init(fireCharacter, velocity, _config, camp, height, target)

func _ready() -> void :
    rect = get_viewport().get_visible_rect()
    rect.position.x = -100
    rect.size.x += 200

@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void :
    if Engine.is_editor_hint():
        return
    if useGravity:
        super._physics_process(delta)
        for area in hitBox.get_overlapping_areas():
            HitCheck(area)
    if useFall:
        if z > groundHeight:
            z -= ySpeed * delta
            if z < groundHeight + 20:
                hitBox.process_mode = Node.PROCESS_MODE_INHERIT
        else:
            Land()
            return

    if trackOpen:
        gridPos = TowerDefenseManager.GetMapGridPos(global_position)
        hitBox.position.y = 0.0
        if is_instance_valid(target):
            if target.nearDie || target.die || !CanTarget(target) || !CanCollision(target.instance.maskFlags):
                target = null
        if !is_instance_valid(target):
            var getTargetList: Array = TowerDefenseManager.GetProjectileTargetNear(self, TowerDefenseEnum.TARGET_NEAR_METHOD.POSITION, false, true)
            if getTargetList.size() > 0:
                target = getTargetList[0]
            else:
                target = null
        if is_instance_valid(target):
            velocity = (target.global_position - global_position).normalized() * speed
            projectileBodyNode.rotation = lerp_angle(projectileBodyNode.rotation, velocity.angle(), delta * 5.0)
        for area in hitBox.get_overlapping_areas():
            HitCheck(area)

    if !catapultOpen:
        global_position += velocity * delta
        if !rect.has_point(global_position):
            global_position = Vector2.ZERO
            Over()
            return

    if fireLength != -1:
        if savePos.distance_to(global_position) > checkDistance:
            Over()
            return

    if catapultOpen:
        projectileBodyNode.rotation += delta * config.rotateScale
        catapultTimer += delta
        var weight: float = catapultTimer / catapultTime
        if weight < 0.5:
            if is_instance_valid(target):
                catapultTargetPos = target.global_position + Vector2(10, -10)
        var u: float = 1.0 - weight
        global_position = u * u * savePos + 2 * u * weight * catapultControlPoint + weight * weight * catapultTargetPos
        if weight >= 1.0:
            HitEffect(null)
            Over()
            return

func SetZ() -> void :
    projectileBodyNode.position.y = - z
    shadowSprite.scale = shadowScaleSave * max(1.0 - z / 600, 0)

func HitCheck(area: Area2D) -> void :
    if !initSet:
        if useGravity:
            return
        initHitList.append(area)
        return
    if hitOver:
        return
    var character = area.get_parent()
    if is_instance_valid(target) && target != character:
        return

    if character is TowerDefenseCharacter:
        if !config.CanCollision(character.instance.maskFlags):
            return

        if !character.CheckDifferentCamp(camp):
            return

        if !checkAll && !character.CheckSameLine(gridPos.y) && !(config.fireMethodFlags & TowerDefenseEnum.PROJECTILE_FIRE_METHOD_FLAG.TRACK):
            return
        if !config.fireMethodFlags & TowerDefenseEnum.PROJECTILE_FIRE_METHOD_FLAG.TRACK:
            if projectileHeight > character.instance.height:
                return
        character.ProjectileHurt(self, config)
        if !(character.HasShield() && (config.damageFlags & TowerDefenseEnum.PROJECTILE_DAMAGE_FLAG.HITSHIELD)):
            for event: TowerDefenseCharacterEventBase in config.hitTargetEventList:
                event.ExecuteProject(self, character)
            for event: TowerDefenseCharacterEventBase in config.hitCharacterEventList:
                event.ExecuteProject(self, character)
        if config.useRange:
            var pos: Vector2 = TowerDefenseManager.GetMapCellPosCenter(TowerDefenseManager.GetMapGridPos(character.global_position))
            pos.x = character.global_position.x
            TowerDefenseExplode.CreateProjectileExplode(pos, config, [character], camp)
        HitEffect(character)
        var over: bool = true
        if config.fireMethodFlags & TowerDefenseEnum.PROJECTILE_FIRE_METHOD_FLAG.PENETRATE:
            penetrateNum -= 1
            if penetrateNum > 0:
                over = false
        if over:
            hitOver = true
            Over()
            return

func HitEffect(character: TowerDefenseCharacter) -> void :
    if config.hitEffect:
        var characterNode: Node2D = TowerDefenseManager.GetCharacterNode()
        var effect = config.hitEffect.instantiate()
        effect.Init(gridPos, camp, config.collisionFlags)
        effect.global_position = shadowSprite.global_position - Vector2(0, 20)
        characterNode.add_child(effect)
    CreatSplat(character)
    if config.splatAudio != "SplatNormal" || (character && character.instance.armorList.size() <= 0):
        PlaySplat()

func CreatSplat(character: TowerDefenseCharacter) -> void :
    if !config.splatScene && config.splatObject == ObjectManagerConfig.OBJECT.NOONE:
        return
    var characterNode: Node2D = TowerDefenseManager.GetCharacterNode()
    var splatEffect
    if config.splatObject == ObjectManagerConfig.OBJECT.NOONE:
        match config.splatSceneType:
            "Particles":
                splatEffect = TowerDefenseManager.CreateEffectParticlesOnce(config.splatScene, gridPos)
            "Sprite":
                splatEffect = TowerDefenseManager.CreateEffectSpriteOnce(config.splatScene, gridPos)
        characterNode.add_child(splatEffect)
    else:
        splatEffect = ObjectManager.PoolPop(config.splatObject, characterNode)

    if character:
        splatEffect.gridPos.y = character.gridPos.y
    else:
        splatEffect.gridPos.y = gridPos.y
    if !config.hitBody || !is_instance_valid(character):
        splatEffect.global_position = projectileBodyNode.global_position
    else:
        splatEffect.global_position = character.global_position - Vector2(0, 20)

func PlaySplat() -> void :
    AudioManager.AudioPlay(config.splatAudio, AudioManagerEnum.TYPE.SFX)

func CanCollision(maskFlags: int) -> bool:
    return maskFlags & config.collisionFlags

func CanTarget(character: TowerDefenseCharacter) -> bool:
    return CheckDifferentCamp(character.camp)

func CheckDifferentCamp(_camp: TowerDefenseEnum.CHARACTER_CAMP) -> bool:
    return camp != _camp

func CheckSameLine(line: int) -> bool:
    return line == gridPos.y

func Land() -> void :
    for area in hitBox.get_overlapping_areas():
        HitCheck(area)

    HitEffect(null)
    PlaySplat()
    gridPos = TowerDefenseManager.GetMapGridPos(global_position)
    var cell: TowerDefenseCellInstance = TowerDefenseManager.GetMapCell(gridPos)
    if is_instance_valid(cell):
        if cell.IsWater():
            CreateSplash()
            Over()
            return
    Over()

func Over() -> void :
    global_position = Vector2(-100, -100)
    ObjectManager.PoolPush(ObjectManagerConfig.OBJECT.PROJECTILE, self)

func CreateSplash() -> TowerDefenseEffectSpriteOnce:
    var characterNode: Node2D = TowerDefenseManager.GetCharacterNode()
    var effect = ObjectManager.PoolPop(ObjectManagerConfig.OBJECT.PARTICLES_SPLASH, characterNode)
    effect.gridPos = gridPos
    effect.global_position = shadowSprite.global_position
    return effect
