@tool
class_name TowerDefenseCharacter extends TowerDefenseGroundItemBase

const SLEEP_Z = preload("uid://bynt7ha6s6wvb")
const FIRE = preload("res://Asset/Anime/Effect/Fire/Base/Fire.tscn")

@onready var backEffectNode: Node2D = %BackEffectNode
@onready var frontEffectNode: Node2D = %FrontEffectNode
@onready var spriteMask: ColorRect = %SpriteMask

@onready var spriteGroup: CanvasGroup = %SpriteGroup
@onready var transformPoint: Marker2D = $SpriteGroup / TransformPoint

@onready var shadowSprite: Sprite2D = %ShadowSprite
@onready var icetrapSprite: Sprite2D = %IcetrapSprite
@onready var hitBox: Area2D = %HitBox
@onready var collisionShape2D: CollisionShape2D = %CollisionShape2D

@onready var state: StateChart = %StateChart
@onready var buff: BuffComponent = %BuffComponent
@onready var showHealthComponent: ShowHealthComponent = %ShowHealthComponent

@export var idleAnimeClip: String = "Idle"
@export var sleepAnimeClip: String = "Idle"

@export var config: TowerDefenseCharacterConfig:
    set(_config):
        config = _config
        currentCustom = []
        DamagePartInit()
        notify_property_list_changed()
@export var sprite: AdobeAnimateSprite:
    set(_sprite):
        sprite = _sprite
        if config && config.customData && sprite:
            SetCustoms(currentCustom)
        DamagePartInit()
        notify_property_list_changed()
@export var headSlot: AdobeAnimateSlot:
    set(_headSlot):
        headSlot = _headSlot
        DamagePartInit()
        notify_property_list_changed()
@export var camp: TowerDefenseEnum.CHARACTER_CAMP = TowerDefenseEnum.CHARACTER_CAMP.PLANT
@export var damagePartClip: String = "particles":
    set(_damagePartClip):
        damagePartClip = _damagePartClip
        DamagePartInit()
        notify_property_list_changed()

@export var damagePart: Dictionary = {}
var damagePartList: Array[String] = []
var damagePartSlot: Dictionary = {}

var previewDamagePointPersontage: float = 1.0:
    set(_previewDamagePointPersontage):
        previewDamagePointPersontage = _previewDamagePointPersontage
        if config && config.damagePointData && sprite:
            PreviewDamagePoint(previewDamagePointPersontage)
            pass

var currentArmor: Array[String] = []:
    set(armor):
        currentArmor = armor
        if config && config.armorData && sprite:
            SetArmors(currentArmor)

var currentCustom: Array[String] = []:
    set(custom):
        currentCustom = custom
        if config && config.customData && sprite:
            SetCustoms(currentCustom)

var instance: TowerDefenseCharacterInstance

var characterFilter: bool = false

var timeScaleInit: float = 1.0
var timeScale: float = 1.0

var dieEvent: Array[TowerDefenseCharacterEventBase] = []

var brightTween: Tween
var whiteTween: Tween
var sleepSprite: AdobeAnimateSprite

var inGame: bool = true
var packet: TowerDefensePacketConfig
var cost: float = 0.0
var nearDie: bool = false
var die: bool = false

var canMowerMove: bool = false

var baseSpriteScale: Vector2
var saveShadowScale: Vector2
var saveShadowPosition: Vector2

var shadowFollowHeight: bool = false:
    set(_shadowFollowHeight):
        shadowFollowHeight = _shadowFollowHeight
        if !shadowFollowHeight:
            shadowSprite.global_position.y = saveShadowPosition.y
var showHealthComponentPosYSave: float = 0.0

var isRise: bool = false
var isSmash: bool = false
var isExplode: bool = false
var isChomp: bool = false

var inWater: bool = false:
    set(_inWater):
        if inWater != _inWater:
            inWater = _inWater
            if inGame:
                if _inWater:
                    InWater()
                else:
                    OutWater()

var outFromWater: bool = false

var blowBack: bool = false
var blowBackNum: float = 0.0

var isDestroy: bool = false

signal destroy(character: TowerDefenseCharacter)
@warning_ignore("unused_signal")
signal bodyHurt(num: int)
@warning_ignore("unused_signal")
signal armmorHurt(num: int)
@warning_ignore("unused_signal")
signal riseOver()

func _get_property_list() -> Array[Dictionary]:
    var properties: Array[Dictionary] = []

    if config:
        if config.damagePointData:
            properties.append(
                {
                    "name": "PreviewDamagePointPersontage", 
                    "type": TYPE_FLOAT, 
                    "hint": PROPERTY_HINT_RANGE, 
                    "hint_string": "0.0,1.0,0.01", 
                }
            )
        if config.armorData:
            properties.append(
                {
                    "name": "Armor", 
                    "type": TYPE_ARRAY, 
                    "hint": PROPERTY_HINT_ENUM, 
                    "hint_string": "%d/%d:%s" % [TYPE_STRING, PROPERTY_HINT_ENUM, ",".join(config.armorData.armorDictionary.keys())], 
                }
            )
        if config.customData:
            properties.append(
                {
                    "name": "Custom", 
                    "type": TYPE_ARRAY, 
                    "hint": PROPERTY_HINT_ENUM, 
                    "hint_string": "%d/%d:%s" % [TYPE_STRING, PROPERTY_HINT_ENUM, ",".join(config.customData.customDictionary.keys())], 
                }
            )

    if damagePartList.size() > 0:
        for damagePartName in damagePartList:
            properties.append(
                {
                    "name": "DamagePartSlot/" + damagePartName, 
                    "type": TYPE_NODE_PATH, 
                    "hint": PROPERTY_HINT_NODE_PATH_VALID_TYPES, 
                    "hint_string": "AdobeAnimateSlot"
                }
            )
    return properties

func _set(property: StringName, value: Variant) -> bool:
    match property:
        "PreviewDamagePointPersontage":
            previewDamagePointPersontage = value
            return true
        "Armor":
            currentArmor = value
            return true
        "Custom":
            currentCustom = value
            return true
    if property.begins_with("DamagePartSlot"):
        damagePartSlot[property.trim_prefix("DamagePartSlot/")] = value
        return true
    return false

func _get(property: StringName) -> Variant:
    match property:
        "PreviewDamagePointPersontage":
            return previewDamagePointPersontage
        "Armor":
            return currentArmor
        "Custom":
            return currentCustom
    if property.begins_with("DamagePartSlot"):
        return damagePartSlot.get(property.trim_prefix("DamagePartSlot/"))
    return null

func _property_can_revert(property: StringName) -> bool:
    match property:
        "PreviewDamagePointPersontage":
            return true
        "Armor":
            return true
        "Custom":
            return true
    if property.begins_with("DamagePartSlot"):
        return true
    return false

func _property_get_revert(property: StringName) -> Variant:
    match property:
        "PreviewDamagePointPersontage":
            return 1.0
        "Custom":
            return Array([], TYPE_STRING, "", null)
        "Armor":
            return Array([], TYPE_STRING, "", null)
    if property.begins_with("DamagePartSlot"):
        return null
    return null

func _ready() -> void :
    if Engine.is_editor_hint():
        return
    super ._ready()
    if inGame:
        state.process_mode = Node.PROCESS_MODE_INHERIT

    if !is_instance_valid(TowerDefenseManager.currentControl) || !TowerDefenseManager.currentControl.isGameRunning:
        state.process_mode = Node.PROCESS_MODE_DISABLED

    saveShadowScale = shadowSprite.scale
    saveShadowPosition = shadowSprite.global_position

    instance = TowerDefenseCharacterInstance.new(self, config)
    instance.damagePointReach.connect(DamagePointReach)
    instance.hitpointsNearDie.connect(HitpointsNearDie)
    instance.hitpointsEmpty.connect(HitpointsEmpty)
    instance.armorDamagePointReach.connect(ArmorDamagePointReach)
    instance.armorHitpointsEmpty.connect(ArmorHitpointsEmpty)
    sprite.animeCompleted.connect(AnimeCompleted)
    sprite.animeEvent.connect(AnimeEvent)

    spriteGroup.material = spriteGroup.material.duplicate()
    spriteGroup.position.y = - z
    add_to_group("Character", true)

    if config.customData:
        var packetValue: Dictionary = GameSaveManager.GetTowerDefensePacketValue(packet.saveKey)
        if packetValue.get_or_add("Key", {}).get_or_add("Custom", "") != "":
            currentCustom = [packetValue["Key"]["Custom"]]

    if CanSleep():
        Sleep()

    await get_tree().physics_frame
    showHealthComponentPosYSave = showHealthComponent.position.y

@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void :
    if Engine.is_editor_hint():
        return
    super ._physics_process(delta)
    if blowBack:
        global_position.x += blowBackNum * delta

    gridPos = TowerDefenseManager.GetMapGridPos(global_position)
    if !self is TowerDefenseZombie && !self is TowerDefenseVase:
        if is_instance_valid(cell):
            groundHeight = lerpf(groundHeight, cell.GetGroundHeight(cellPercentage), 3.0 * delta)
    shadowSprite.scale = saveShadowScale * (1.0 - z / 900.0)
    if shadowFollowHeight:
        shadowSprite.global_position.y = transformPoint.global_position.y

    timeScale = timeScaleInit
    spriteGroup.position.y = - z
    if inWater:
        showHealthComponent.position.y = showHealthComponentPosYSave
    else:
        showHealthComponent.position.y = spriteGroup.position.y + showHealthComponentPosYSave
    shadowSprite.global_position.y = saveShadowPosition.y - groundHeight * transformPoint.global_scale.y
    if !IsDie():
        if nearDie:
            instance.DealHurt(config.hitpointsNearDeath * delta / 3.0, false)

    if !hitBox:
        hitBox = null

func IdleEntered() -> void :
    if idleAnimeClip != "":
        sprite.SetAnimation(idleAnimeClip, true, 0.2)

@warning_ignore("unused_parameter")
func IdleProcessing(delta: float) -> void :
    sprite.timeScale = timeScale
    if CanSleep():
        Sleep()

func IdleExited() -> void :
    pass

func SleepEntered() -> void :
    sleepSprite = SLEEP_Z.instantiate()
    sleepSprite.position = Vector2(20, 25)
    frontEffectNode.add_child(sleepSprite)
    instance.sleep = true
    if sleepAnimeClip != "":
        sprite.SetAnimation(sleepAnimeClip, true, 0.2)

@warning_ignore("unused_parameter")
func SleepProcessing(delta: float) -> void :
    sprite.timeScale = timeScale
    if !CanSleep():
        Idle()

func SleepExited() -> void :
    var saveScale: Vector2 = transformPoint.scale
    var tween = create_tween()
    tween.set_ease(Tween.EASE_OUT)
    tween.set_trans(Tween.TRANS_QUART)
    tween.tween_property(transformPoint, ^"scale:y", saveScale.y - 0.25, 0.25)
    tween.tween_property(transformPoint, ^"scale:y", saveScale.y + 0.1, 0.25)
    tween.tween_property(transformPoint, ^"scale:y", saveScale.y, 0.25)
    if is_instance_valid(sleepSprite):
        sleepSprite.queue_free()
    instance.sleep = false

@warning_ignore("unused_parameter")
func AnimeCompleted(clip: String) -> void :
    pass



@warning_ignore("unused_parameter")
func AnimeEvent(command: String, argument: Variant) -> void :
    pass

@warning_ignore("unused_parameter")
func DamagePointReach(damangePointName: String) -> void :
    pass

func HitpointsNearDie() -> void :
    nearDie = true

func HitpointsEmpty() -> void :
    die = true

@warning_ignore("unused_parameter")
func ArmorDamagePointReach(armorName: String, stage: int) -> void :
    pass

@warning_ignore("unused_parameter")
func ArmorHitpointsEmpty(armorName: String) -> void :
    pass

@warning_ignore("unused_parameter")
func AttackDeal(character: TowerDefenseCharacter, type: String) -> void :
    pass



func DamagePartInit() -> void :
    damagePartList = []
    damagePart = {}
    if sprite:
        if config:
            if config.damagePointData:
                var damagePointList: Array[CharacterDamagePointConfig] = config.damagePointData.damagePointList
                for damagePoint: CharacterDamagePointConfig in damagePointList:
                    if !damagePoint.isDrop:
                        continue
                    var damagePointName: String = damagePoint.damagePointName
                    damagePart[damagePointName] = damagePoint
                    damagePartList.append(damagePointName)
            if config.armorData:
                var armorList: Array[CharacterArmorConfig] = config.armorData.armorList
                for armor: CharacterArmorConfig in armorList:
                    if !armor.armorMethodFlags & TowerDefenseEnum.ARMOR_METHOD_FLAGS.DROPABLE:
                        continue
                    var armorName: String = armor.armorName
                    damagePart[armorName] = armor
                    damagePartList.append(armorName)

func PreviewDamagePoint(persontage: float) -> void :
    config.damagePointData.ClearDamagePointFliters(sprite)
    for damagePointName: String in config.damagePointData.damagePointDictionary.keys():
        var damagePointConfig: CharacterDamagePointConfig = config.damagePointData.damagePointDictionary[damagePointName]["Config"]
        if persontage <= damagePointConfig.damagePersontage:
            config.damagePointData.SetDamagePointFliters(sprite, damagePointConfig.damagePointName)
            if config.customData:
                for customName: String in currentCustom:
                    config.customData.SetDamagePoint(sprite, customName, config.damagePointData.damagePointDictionary.keys().find(damagePointName))

func ClearArmor(armor: String) -> void :
    config.armorData.ClearArmorFliters(sprite, armor)

func ClearArmorAll() -> void :
    config.armorData.ClearArmorFlitersAll(sprite)

func SetArmor(armor: String, stage: int) -> void :
    ClearArmor(armor)
    config.armorData.OpenArmorFliters(sprite, armor)
    config.armorData.SetArmorReplace(sprite, armor, stage)

func SetArmors(armorList: Array[String]) -> void :
    ClearArmorAll()
    for armor: String in armorList:
        if armor != "":
            SetArmor(armor, 0)

func ClearCustom() -> void :
    config.customData.ClearCustomFliters(sprite)

func SetCustom(custom: String) -> void :
    ClearCustom()
    config.customData.SetCustomFliters(sprite, custom)

func SetCustoms(customList: Array[String]) -> void :
    ClearCustom()
    for custom: String in customList:
        if custom != "":
            SetCustom(custom)



func Idle() -> void :
    state.send_event("ToIdle")

func Sleep() -> void :
    state.send_event("ToSleep")

func IsDie() -> bool:
    return die

func GetTotalHitPoint() -> float:
    var hitPoint: float = config.hitpoints
    var armorList: Array[TowerDefenseArmorInstance] = GetArmor()
    for armor: TowerDefenseArmorInstance in armorList:
        hitPoint += armor.hitPoints
    return hitPoint

func Destroy(freeInsance: bool = true) -> void :
    if isDestroy:
        return
    remove_from_group("Character")
    if Global.isEditor && SceneManager.currentScene == "LevelEditorStage":
        queue_free()
        return
    HitBoxDestroy()
    destroy.emit(self)
    if isExplode && !config.ashScene:
        AshDestroy()
        return
    if isSmash:
        SmashDestroy()
        return
    if freeInsance:
        isDestroy = true
    await DestroySet()
    for event: TowerDefenseCharacterEventBase in dieEvent:
        event.Execute(global_position, self)
    if freeInsance:
        queue_free()

func AshDestroy() -> void :
    if isDestroy:
        return
    isDestroy = true
    await DestroySet()
    if inWater:
        queue_free()
        return
    SetSpriteGroupShaderParameter("ash", true)
    sprite.pause = true
    await get_tree().create_timer(1.0, false).timeout
    queue_free()

func SmashDestroy() -> void :
    if isDestroy:
        return
    isDestroy = true
    await DestroySet()
    if inWater:
        queue_free()
        return
    sprite.pause = true
    shadowSprite.visible = false
    transformPoint.scale.y = 0.25
    await get_tree().create_timer(1.0, false).timeout
    queue_free()

func DestroySet() -> void :
    await get_tree().physics_frame

func HitBoxDestroy() -> void :
    if is_instance_valid(hitBox):
        hitBox.queue_free()

func DamagePartCreate(damagePointName: StringName, node: Node2D, velocity: Vector2 = Vector2(randf_range(-100, 100), -300)) -> void :
    if !damagePartList.has(damagePointName):
        return
    var slot: AdobeAnimateSlot = get_node(damagePartSlot[damagePointName]) as AdobeAnimateSlot
    if !slot:
        return
    var charcaterNode: Node2D = TowerDefenseManager.GetCharacterNode()
    var damagePartInstance: DamagePartDrop = ObjectManager.PoolPop(ObjectManagerConfig.OBJECT.DAMAGEPART, charcaterNode) as DamagePartDrop
    if !node:
        var damageData = damagePart[damagePointName]
        if damageData is CharacterDamagePointConfig:
            node = slot.CreatePart(damagePart[damagePointName].animeFliterClose.split("&", false))
        if damageData is CharacterArmorConfig:
            node = slot.CreatePart(damagePart[damagePointName].destroyFliter.split("&", false))
    else:
        if node.get_parent():
            node.get_parent().remove_child(node)
            damagePartInstance.scale = slot.scale
    damagePartInstance.Init(node, GetGroundHeight(slot.global_position.y) + shadowSprite.position.y - 16, velocity)
    damagePartInstance.scale *= scale * transformPoint.scale * sprite.scale
    damagePartInstance.global_position = slot.global_position
    damagePartInstance.gridPos = gridPos

func MagnetCreate(armorInstance: TowerDefenseArmorInstance, node: Node2D) -> TowerDefenseMagnet:
    var damagePointName: String = armorInstance.config.armorName
    var slot: AdobeAnimateSlot = get_node(damagePartSlot[damagePointName]) as AdobeAnimateSlot
    if !slot:
        return
    var magnetInstance: TowerDefenseMagnet = TowerDefenseMagnet.Create(armorInstance)
    var characterNode: Node2D = TowerDefenseManager.GetCharacterNode()
    characterNode.add_child(magnetInstance)
    if !node:
        var damageData = damagePart[damagePointName]
        if damageData is CharacterDamagePointConfig:
            node = slot.CreatePart(damagePart[damagePointName].animeFliterClose.split("&", false))
        if damageData is CharacterArmorConfig:
            node = slot.CreatePart(damagePart[damagePointName].destroyFliter.split("&", false))
    else:
        if node.get_parent():
            node.get_parent().remove_child(node)
            magnetInstance.scale = slot.scale
    magnetInstance.Init(node)

    magnetInstance.global_position = slot.global_position
    node.rotation = slot.rotation
    magnetInstance.gridPos = gridPos
    return magnetInstance

func ArmorDraw(armor: TowerDefenseArmorInstance) -> TowerDefenseMagnet:
    return instance.ArmorDraw(armor)

func HasShield() -> bool:
    return instance.armorShield.size() > 0

func HasHelm() -> bool:
    return instance.armorHelm.size() > 0

func GetArmor() -> Array[TowerDefenseArmorInstance]:
    return instance.armorList

func GetArmorShield() -> Array[TowerDefenseArmorInstance]:
    return instance.armorShield

func GetArmorHelment() -> Array[TowerDefenseArmorInstance]:
    return instance.armorHelm

func CanCollision(maskFlags: int) -> bool:
    return maskFlags & instance.collisionFlags

func CanTarget(character: TowerDefenseCharacter) -> bool:
    return CheckDifferentCamp(character.camp)

func CheckDifferentCamp(_camp: TowerDefenseEnum.CHARACTER_CAMP) -> bool:
    return camp != _camp

func CheckSameLine(line: int) -> bool:
    return line == gridPos.y

func GetGroundHeight(posHieght: float) -> float:
    return global_position.y - posHieght + groundHeight

@warning_ignore("unused_parameter")
func Cover(character: TowerDefenseCharacter) -> void :
    pass

func Hurt(num: float, playSplatAudio: bool = true, velocity: Vector2 = Vector2.ZERO, createDamagePart: bool = true) -> float:
    Bright()
    return instance.Hurt(num, playSplatAudio, velocity, createDamagePart)

func SmashHurt(num: float, playSplatAudio: bool = true, velocity: Vector2 = Vector2.ZERO) -> float:
    Bright()
    return instance.SmashHurt(num, playSplatAudio, velocity)

func ExplodeHurt(num: float, type: String = "Bomb", playSplatAudio: bool = true, velocity: Vector2 = Vector2.ZERO) -> float:
    Bright()
    var _num = instance.ExplodeHurt(num, type, playSplatAudio, velocity)
    return _num

func FlagHurt(num: float, damageFlags: int, playSplatAudio: bool = true, velocity: Vector2 = Vector2.ZERO) -> float:
    Bright()
    return instance.FlagHurt(num, damageFlags, playSplatAudio, velocity)

func ProjectileHurt(projectile: TowerDefenseProjectile, projectileConfig: TowerDefenseProjectileConfig, playSplatAudio: bool = true, velocity: Vector2 = Vector2.ZERO, isRange: bool = false) -> float:
    Bright()
    return instance.ProjectileHurt(projectile, projectileConfig, playSplatAudio, velocity, isRange)

func Bright(init: float = 0.5, delay: float = 0.0, rise: float = 0.5, riseDuration: float = 0.0, duration: float = 0.2) -> void :
    spriteGroup.material.set("shader_parameter/brightStrength", init)
    await get_tree().create_timer(delay, false).timeout
    if riseDuration != 0.0:
        brightTween = create_tween()
        brightTween.tween_property(spriteGroup.material, "shader_parameter/brightStrength", rise, riseDuration).from(init)
        await brightTween.finished
    brightTween = create_tween()
    brightTween.tween_property(spriteGroup.material, "shader_parameter/brightStrength", 0, duration).from(rise)

func White(init: float = 1.0, delay: float = 0.0, duration: float = 0.5) -> void :
    spriteGroup.material.set("shader_parameter/whiteStrength", init)
    await get_tree().create_timer(delay, false).timeout
    whiteTween = create_tween()
    whiteTween.tween_property(spriteGroup.material, "shader_parameter/whiteStrength", 0, duration).from(init)

func BuffAdd(buffConfig: TowerDefenseCharacterBuffConfig) -> void :
    buff.BuffAdd(buffConfig)

func BuffDelete(key: String) -> void :
    buff.BuffDelete(key)

func SunCreate(pos: Vector2, sunNum: int, movingMethod: TowerDefenseEnum.SUN_MOVING_METHOD = TowerDefenseEnum.SUN_MOVING_METHOD.GRAVITY, _velocity: Vector2 = Vector2.ZERO, _gravity: float = 0.0, _moveStopTime: float = -1) -> TowerDefenseSun:
    return TowerDefenseManager.SunCreate(pos, sunNum, movingMethod, GetGroundHeight(pos.y) - groundHeight * 2, _velocity, _gravity, _moveStopTime)

func BrainSunCreate(pos: Vector2, sunNum: int, movingMethod: TowerDefenseEnum.SUN_MOVING_METHOD = TowerDefenseEnum.SUN_MOVING_METHOD.GRAVITY, _velocity: Vector2 = Vector2.ZERO, _gravity: float = 0.0, _moveStopTime: float = -1) -> TowerDefenseBrainSun:
    return TowerDefenseManager.BrainSunCreate(pos, sunNum, movingMethod, GetGroundHeight(pos.y) - groundHeight * 2, _velocity, _gravity, _moveStopTime)

func JalapenoSunCreate(pos: Vector2, sunNum: int, movingMethod: TowerDefenseEnum.SUN_MOVING_METHOD = TowerDefenseEnum.SUN_MOVING_METHOD.GRAVITY, _velocity: Vector2 = Vector2.ZERO, _gravity: float = 0.0, _moveStopTime: float = -1) -> TowerDefenseSunJalapeno:
    var jalapenoSun: TowerDefenseSunJalapeno = TowerDefenseManager.JalapenoSunCreate(pos, sunNum, movingMethod, GetGroundHeight(pos.y) - groundHeight * 2, _velocity, _gravity, _moveStopTime) as TowerDefenseSunJalapeno
    jalapenoSun.gridPos = gridPos
    return jalapenoSun

func ExplodeSunCreate(pos: Vector2, sunNum: int, sunOnce: int, movingMethod: TowerDefenseEnum.SUN_MOVING_METHOD = TowerDefenseEnum.SUN_MOVING_METHOD.GRAVITY, _speed: float = 0.0, _gravity: float = 0.0, _moveStopTime: float = -1) -> void :
    while sunNum > 0:
        SunCreate(pos, sunOnce, movingMethod, Vector2.from_angle(PI / 2.0 + randf_range( - PI / 12.0, PI / 12.0)) * _speed * randf_range(0.5, 1.5), _gravity, _moveStopTime)
        sunNum -= sunOnce

func CraterCreate(nolimit: bool = false) -> void :
    if is_instance_valid(cell):
        if nolimit || cell.CanCraterCreate():
            var craterPacket: TowerDefensePacketConfig = TowerDefenseManager.GetPacketConfig("CraterDayGround")
            craterPacket.Plant(gridPos, false, true)

func BlowBack(num: float, time: float = 1.0) -> void :
    if instance.collisionFlags & TowerDefenseEnum.CHARACTER_COLLISION_FLAGS.UNDER_GROUND:
        return
    blowBack = true
    blowBackNum = TowerDefenseManager.GetMapGridSize().x * num
    await get_tree().create_timer(time, false).timeout
    blowBack = false

func Blow() -> void :
    pass

func Garlic() -> void :
    pass

func Hypnoses(time: float = -1) -> void :
    if instance.unUseBuffFlags & TowerDefenseEnum.CHARACTER_BUFF_FLAGS.HYPNOSES:
        return
    AudioManager.AudioPlay("Floop", AudioManagerEnum.TYPE.SFX)
    var buffHypnoses: TowerDefenseCharacterBuffHypnoses = TowerDefenseCharacterBuffHypnoses.new()
    buffHypnoses.time = time
    BuffAdd(buffHypnoses)

func InWater() -> void :
    shadowSprite.visible = false

func OutWater() -> void :
    shadowSprite.visible = true
    outFromWater = true

func Rise(duration: float = randf_range(0.75, 1.25), delay: float = 0.0, createDirt: bool = true, changeState: bool = true, from: float = 0.0) -> void :
    isRise = true
    var rememberShadowVisible: bool = shadowSprite.visible
    shadowSprite.visible = false
    SetSpriteGroupShaderParameter("surfacePos", 0.0)
    if changeState && self is TowerDefenseZombie:
        call("Idle")
        set("attackComponent:alive", false)
    await get_tree().create_timer(delay, false).timeout
    var riseTween = create_tween()
    riseTween.tween_property(spriteGroup.material, "shader_parameter/surfacePos", 1.0, duration).from(from)
    await get_tree().create_timer(0.1, false).timeout
    if createDirt:
        if !inWater:
            CreateDirt()
        else:
            CreateSplash()
    await riseTween.finished
    isRise = false
    if changeState && self is TowerDefenseZombie:
        call("Walk")
        set("attackComponent:alive", true)
    if !inWater:
        shadowSprite.visible = rememberShadowVisible

func Recycle(percentage: float = 0.2, _destroy: bool = true) -> void :
    SunCreate(global_position, int(cost * percentage), TowerDefenseEnum.SUN_MOVING_METHOD.GRAVITY, Vector2(randf_range(-50.0, 50.0), -400.0), 980.0)
    if _destroy:
        Destroy()

static func CreateJalapenoFire(_gridPos: Vector2i) -> void :
    ViewManager.CameraShake(Vector2(randf_range(-1, 1), randf_range(-1, 1)), 5.0, 0.05, 4)
    AudioManager.AudioPlay("ExplodeJalapeno", AudioManagerEnum.TYPE.SFX)
    var characterNode: Node2D = TowerDefenseManager.GetCharacterNode()
    for i in TowerDefenseManager.GetMapGridNum().x:
        var flag: bool = true
        if i == 0:
            var getCell: TowerDefenseCellInstance = TowerDefenseManager.GetMapCell(_gridPos)
            var effect = TowerDefenseManager.CreateEffectSpriteOnce(FIRE, _gridPos, "Flame|Done")
            effect.global_position = TowerDefenseManager.GetMapCellPlantPos(_gridPos) + Vector2(0, 30)
            if is_instance_valid(getCell):
                effect.global_position.y -= getCell.GetGroundHeight(0.5)
            characterNode.add_child(effect)
            flag = false
        else:
            if _gridPos.x - i > 0:
                var getCell: TowerDefenseCellInstance = TowerDefenseManager.GetMapCell(_gridPos - Vector2i(i, 0))
                var effectLeft = TowerDefenseManager.CreateEffectSpriteOnce(FIRE, _gridPos - Vector2i(i, 0), "Flame|Done")
                effectLeft.global_position = TowerDefenseManager.GetMapCellPlantPos(_gridPos - Vector2i(i, 0)) + Vector2(0, 30)
                if is_instance_valid(getCell):
                    effectLeft.global_position.y -= getCell.GetGroundHeight(0.5)
                characterNode.add_child(effectLeft)
                flag = false

            if _gridPos.x + i <= TowerDefenseManager.GetMapGridNum().x:
                var getCell: TowerDefenseCellInstance = TowerDefenseManager.GetMapCell(_gridPos + Vector2i(i, 0))
                var effectRight = TowerDefenseManager.CreateEffectSpriteOnce(FIRE, _gridPos + Vector2i(i, 0), "Flame|Done")
                effectRight.global_position = TowerDefenseManager.GetMapCellPlantPos(_gridPos + Vector2i(i, 0)) + Vector2(0, 30)
                if is_instance_valid(getCell):
                    effectRight.global_position.y -= getCell.GetGroundHeight(0.5)
                characterNode.add_child(effectRight)
                flag = false
        if flag:
            break
        await TowerDefenseManager.currentControl.get_tree().create_timer(0.025, false).timeout

func CreateDirt() -> TowerDefenseEffectParticlesOnce:
    var characterNode: Node2D = TowerDefenseManager.GetCharacterNode()
    var effect: TowerDefenseEffectParticlesOnce = ObjectManager.PoolPop(ObjectManagerConfig.OBJECT.PARTICLES_RISE_DIRT, characterNode)
    effect.gridPos = gridPos
    effect.global_position = Vector2(shadowSprite.global_position.x, saveShadowPosition.y)
    return effect

func CreateSplash() -> TowerDefenseEffectSpriteOnce:
    var characterNode: Node2D = TowerDefenseManager.GetCharacterNode()
    var effect: TowerDefenseEffectSpriteOnce = ObjectManager.PoolPop(ObjectManagerConfig.OBJECT.PARTICLES_SPLASH, characterNode)
    effect.gridPos = gridPos
    effect.global_position = Vector2(shadowSprite.global_position.x, saveShadowPosition.y)
    return effect

func CreateIceTrap() -> TowerDefenseEffectParticlesOnce:
    var characterNode: Node2D = TowerDefenseManager.GetCharacterNode()
    var effect: TowerDefenseEffectParticlesOnce = ObjectManager.PoolPop(ObjectManagerConfig.OBJECT.PARTICLES_ICE_TRAP, characterNode)
    effect.gridPos = gridPos
    effect.global_position = Vector2(shadowSprite.global_position.x, saveShadowPosition.y)
    return effect

func CanSleep() -> bool:
    if instance.wakeUp:
        return false

    var sleepFlag: bool = true
    match config.sleepTime:
        "Never":
            sleepFlag = false
        "Day":
            if TowerDefenseManager.GetMapIsNight():
                sleepFlag = false
        "Night":
            if !TowerDefenseManager.GetMapIsNight():
                sleepFlag = false
    if is_instance_valid(TowerDefenseMapControl.instance):
        if cell:
            if cell.elementFlags & instance.elementFlags:
                sleepFlag = false
            if cell.HasCoffee():
                sleepFlag = false
    return sleepFlag

func IsSleep() -> bool:
    return instance.sleep

func SetSpriteGroupShaderParameter(property: String, value: Variant) -> void :
    var _material: ShaderMaterial = spriteGroup.material as ShaderMaterial
    _material.set_shader_parameter(property, value)

func SetZ() -> void :
    super .SetZ()
    if is_instance_valid(spriteGroup):
        spriteGroup.position.y = - z
