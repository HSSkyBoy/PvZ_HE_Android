class_name TowerDefenseArmorInstance extends Resource

var character: TowerDefenseCharacter
var config: CharacterArmorConfig
var sprite: Sprite2D = null

var hitPoints: float
var armorMethodFlags: int

var stagePersontage: Array[float]
var stageIndex: int = 0

var hitpointScale: float = 1.0:
    set(_hitpointScale):
        hitpointScale = _hitpointScale
        hitPoints *= _hitpointScale

signal damagePointReach(instance: TowerDefenseArmorInstance, stage: int)
signal hitpointsEmpty(instance: TowerDefenseArmorInstance)
signal remove(instance: TowerDefenseArmorInstance)

func _init(_character: TowerDefenseCharacter, _config: CharacterArmorConfig) -> void :
    character = _character
    config = _config

    hitPoints = config.damagePoint

    armorMethodFlags = config.armorMethodFlags

    if armorMethodFlags & TowerDefenseEnum.ARMOR_METHOD_FLAGS.DAMAGEABLE:
        stagePersontage = config.stagePersontage

    match config.replaceMethod:
        "Media":
            character.SetArmor(config.armorName, 0)
        "Sprite":
            var slot: AdobeAnimateSlot = character.get_node(character.damagePartSlot[config.armorName])
            sprite = Sprite2D.new()
            sprite.texture = config.stageAnimeTexture[0]
            sprite.position = config.replaceSpriteOffset
            sprite.rotation = config.replaceSpriteRotation
            sprite.scale = config.replaceSpriteScale
            slot.add_child(sprite)

func Hurt(num: float, playSplatAudio: bool = true, velocity: Vector2 = Vector2.ZERO, createDamagePart: bool = true) -> float:
    num = DealHurt(num, playSplatAudio, velocity, createDamagePart)
    return num

func DealHurt(num: float, playSplatAudio: bool = true, velocity: Vector2 = Vector2.ZERO, createDamagePart: bool = true) -> float:
    if hitPoints > num:
        character.armmorHurt.emit(num)
        hitPoints -= num
        num = 0
    else:
        character.armmorHurt.emit(hitPoints)
        num -= hitPoints
        hitPoints = 0
    var impactAudio: String = config.impactAudio
    if playSplatAudio && impactAudio != "":
        AudioManager.AudioPlay(impactAudio, AudioManagerEnum.TYPE.SFX)
    if hitPoints > 0:
        if armorMethodFlags & TowerDefenseEnum.ARMOR_METHOD_FLAGS.DAMAGEABLE:
            var persontage: float = hitPoints / (config.damagePoint * hitpointScale)
            if stageIndex < stagePersontage.size():
                while persontage <= stagePersontage[stageIndex]:
                    stageIndex += 1
                    match config.replaceMethod:
                        "Media":
                            character.SetArmor(config.armorName, stageIndex)
                        "Sprite":
                            sprite.texture = config.stageAnimeTexture[stageIndex]
                    damagePointReach.emit(self, stageIndex)
                    if stageIndex >= stagePersontage.size():
                        break
    else:
        if createDamagePart && armorMethodFlags & TowerDefenseEnum.ARMOR_METHOD_FLAGS.DROPABLE:
            if velocity == Vector2.ZERO:
                velocity = Vector2(randf_range(-100, 100) * randf_range(0.75, 1.25), -300 * randf_range(0.75, 1.25))
            else:
                velocity = Vector2(velocity.x * randf_range(0.75, 1.25), velocity.y * randf_range(0.75, 1.25))
            DamagePartCreate(velocity)
        Remove()
        hitpointsEmpty.emit(self)
    if armorMethodFlags & TowerDefenseEnum.ARMOR_METHOD_FLAGS.ABSORBOVERFLOW:
        return 0
    else:
        return num

func IsMetallic() -> bool:
    return armorMethodFlags & TowerDefenseEnum.ARMOR_METHOD_FLAGS.METALLIC

func Remove() -> void :
    var damageAudio: String = config.damageAudio
    if damageAudio != "":
        AudioManager.AudioPlay(damageAudio, AudioManagerEnum.TYPE.SFX)
    match config.replaceMethod:
        "Media":
            character.ClearArmor(config.armorName)
        "Sprite":
            sprite = null

func Draw() -> TowerDefenseMagnet:
    var magnet: TowerDefenseMagnet = character.MagnetCreate(self, sprite)
    Remove()
    remove.emit(self)
    return magnet

func DamagePartCreate(velocity: Vector2 = Vector2.ZERO) -> void :
    character.DamagePartCreate(config.armorName, sprite, velocity)
