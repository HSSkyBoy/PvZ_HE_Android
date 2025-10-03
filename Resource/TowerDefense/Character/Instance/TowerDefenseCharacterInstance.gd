class_name TowerDefenseCharacterInstance extends Resource

var character: TowerDefenseCharacter
var config: TowerDefenseCharacterConfig

var zombiePhysique: TowerDefenseEnum.ZOMBIE_PHYSIQUE = TowerDefenseEnum.ZOMBIE_PHYSIQUE.NORMAL

var hitpoints: float = 200.0
var height: TowerDefenseEnum.CHARACTER_HEIGHT = TowerDefenseEnum.CHARACTER_HEIGHT.NORMAL
var collisionFlags: int = TowerDefenseEnum.CHARACTER_COLLISION_FLAGS.GROUND_CHARACTRE
var maskFlags: int = TowerDefenseEnum.CHARACTER_COLLISION_FLAGS.GROUND_CHARACTRE
var unUseBuffFlags: int = 0
var physiqueTypeFlags: int = 0
var elementFlags: int = 0

var damagePointData: CharacterDamagePointData
var damagePoints: Array[Dictionary] = []
var damagePointIndex = 0

var canCollection: bool = true

var die: bool = false
var nearDie: bool = false
var invincible: bool = false
var sleep: bool = false
var wakeUp: bool = false
var hypnoses: bool = false

var hitpointScale: float = 1.0:
    set(_hitpointScale):
        hitpointScale = _hitpointScale
        hitpoints *= _hitpointScale
        for armor in armorList:
            armor.hitpointScale = hitpointScale

var armorOverrideUnUseBuffFlagSave: int = 0

var armorList: Array[TowerDefenseArmorInstance] = []
var armorShield: Array[TowerDefenseArmorInstance] = []
var armorHelm: Array[TowerDefenseArmorInstance] = []
var armorBody: Array[TowerDefenseArmorInstance] = []

signal damagePointReach(name: String)
signal armorDamagePointReach(name: String, stage: int)
signal hitpointsNearDie()
signal hitpointsEmpty()
signal armorHitpointsEmpty()

func _init(_character: TowerDefenseCharacter, _config: TowerDefenseCharacterConfig) -> void :
    character = _character
    config = _config

    hitpoints = config.hitpoints + config.hitpointsNearDeath
    height = config.height

    collisionFlags = config.collisionFlags
    maskFlags = config.maskFlags
    unUseBuffFlags = config.unUseBuffFlags
    physiqueTypeFlags = config.physiqueTypeFlags
    elementFlags = config.elementFlags

    damagePointData = config.damagePointData
    if damagePointData:
        for damagePointConfig: CharacterDamagePointConfig in damagePointData.damagePointList:
            var damageDictionary: Dictionary = {}
            damageDictionary["Persontage"] = damagePointConfig.damagePersontage
            damageDictionary["Name"] = damagePointConfig.damagePointName
            damageDictionary["DamageAudio"] = damagePointConfig.damageAudio
            damagePoints.append(damageDictionary)

    for armorName: String in character.currentArmor:
        ArmorAdd(armorName)

    if _config is TowerDefenseZombieConfig:
        zombiePhysique = _config.physique

func ProjectileHurt(projectile: TowerDefenseProjectile, projectileConfig: TowerDefenseProjectileConfig, playSplatAudio: bool = true, velocity: Vector2 = Vector2.ZERO, isRange: bool = false, createDamagePart: bool = true) -> float:
    if die:
        return 1000000.0
    var num: float = projectileConfig.baseDamage
    var damageFlags: int = projectileConfig.damageFlags
    var hitShieldFlag: bool = false
    if isRange:
        num *= projectileConfig.hitPesontage
    else:
        if projectileConfig.useRange:
            if !(projectileConfig.damageFlags & TowerDefenseEnum.PROJECTILE_DAMAGE_FLAG.HITSHIELD):
                hitShieldFlag = true
    if projectileConfig.fireMethodFlags & TowerDefenseEnum.PROJECTILE_FIRE_METHOD_FLAG.PENETRATE:
        hitShieldFlag = true
        if is_instance_valid(projectile):
            for armor in armorList:
                if armor.armorMethodFlags & TowerDefenseEnum.ARMOR_METHOD_FLAGS.CANT_PENETRATE:
                    projectile.Over()
                    if !(damageFlags & TowerDefenseEnum.PROJECTILE_DAMAGE_FLAG.HITSHIELD):
                        damageFlags += TowerDefenseEnum.PROJECTILE_DAMAGE_FLAG.HITSHIELD
                        hitShieldFlag = false
    if hitShieldFlag:
        FlagHurt(num, TowerDefenseEnum.PROJECTILE_DAMAGE_FLAG.HITSHIELD, playSplatAudio, velocity, createDamagePart, isRange)
    return FlagHurt(num, damageFlags, playSplatAudio, velocity, createDamagePart, isRange)

func FlagHurt(num: float, damageFlags: int, playSplatAudio: bool = true, velocity: Vector2 = Vector2.ZERO, createDamagePart: bool = true, isRange: bool = false) -> float:
    if invincible:
        return 0
    if die:
        return 1000000.0
    var passFlag: bool = false
    if damageFlags & TowerDefenseEnum.PROJECTILE_DAMAGE_FLAG.FIRE:
        if character.buff.BuffHas("RedHeat"):
            num *= 2
    if num > 0 && (isRange || damageFlags & TowerDefenseEnum.PROJECTILE_DAMAGE_FLAG.HITSHIELD):
        if armorShield.size() > 0:
            for armorInstance: TowerDefenseArmorInstance in armorShield:
                if armorInstance.config.armorMethodFlags & TowerDefenseEnum.ARMOR_METHOD_FLAGS.INVINCIBLE:
                    num = 0
                if armorInstance.config.armorMethodFlags & TowerDefenseEnum.ARMOR_METHOD_FLAGS.PASSDAMAGE:
                    DealHurt(num, playSplatAudio, velocity, createDamagePart)
                    passFlag = true
                if isRange:
                    armorInstance.Hurt(num, playSplatAudio, velocity, createDamagePart)
                else:
                    num = armorInstance.Hurt(num, playSplatAudio, velocity, createDamagePart)
                if num <= 0:
                    break
    if damageFlags == TowerDefenseEnum.PROJECTILE_DAMAGE_FLAG.HITSHIELD:
        return 0
    if num > 0 && damageFlags & TowerDefenseEnum.PROJECTILE_DAMAGE_FLAG.HITBODY:
        if damageFlags & TowerDefenseEnum.PROJECTILE_DAMAGE_FLAG.FIRE:
            character.buff.BuffAdd(TowerDefenseCharacterBuffFireHit.new())
        if armorHelm.size() > 0:
            for armorInstance: TowerDefenseArmorInstance in armorHelm:
                if armorInstance.config.armorMethodFlags & TowerDefenseEnum.ARMOR_METHOD_FLAGS.INVINCIBLE:
                    num = 0
                if armorInstance.config.armorMethodFlags & TowerDefenseEnum.ARMOR_METHOD_FLAGS.PASSDAMAGE:
                    DealHurt(num, playSplatAudio, velocity, createDamagePart)
                    passFlag = true
                num = armorInstance.Hurt(num, playSplatAudio, velocity, createDamagePart)
                if num <= 0:
                    break
        if armorBody.size() > 0:
            for armorInstance: TowerDefenseArmorInstance in armorBody:
                if armorInstance.config.armorMethodFlags & TowerDefenseEnum.ARMOR_METHOD_FLAGS.INVINCIBLE:
                    num = 0
                if armorInstance.config.armorMethodFlags & TowerDefenseEnum.ARMOR_METHOD_FLAGS.PASSDAMAGE:
                    DealHurt(num, playSplatAudio, velocity, createDamagePart)
                    passFlag = true
                num = armorInstance.Hurt(num, playSplatAudio, velocity, createDamagePart)
                if num <= 0:
                    break
    if num > 0:
        if !passFlag:
            num = DealHurt(num, playSplatAudio, velocity, createDamagePart)
    return num

func ExplodeHurt(num: float, type: String = "Bomb", playSplatAudio: bool = true, velocity: Vector2 = Vector2.ZERO) -> float:
    if invincible:
        return 0
    if config.explosionHurt != -1:
        num = min(config.explosionHurt, num)
    character.isExplode = true
    character.buff.BuffAdd(TowerDefenseCharacterBuffFireHit.new())
    if character.buff.BuffHas("RedHeat"):
        num *= 2
    for armor: TowerDefenseArmorInstance in armorShield:
        armor.DealHurt(num * armor.config.explodePersontage, playSplatAudio, velocity)
        if armor.config.explodePersontage == 0.0:
            num = 0.0
        if num > 0:
            break
    for armor: TowerDefenseArmorInstance in armorHelm:
        num = armor.DealHurt(num * armor.config.explodePersontage, playSplatAudio, velocity)
        if armor.config.explodePersontage == 0.0:
            num = 0.0
        if num > 0:
            break
    for armor: TowerDefenseArmorInstance in armorBody:
        num = armor.DealHurt(num, playSplatAudio, velocity)
        if num > 0:
            break
    var createDamagePart: bool = true
    match type:
        "Bomb":
            createDamagePart = false
    if num != 0:
        num = DealHurt(num, playSplatAudio, velocity, createDamagePart)
    if num > 0:
        hitpointsNearDie.emit()
        nearDie = true
        Die()
        match type:
            "Bomb":
                if !character.inWater:
                    if config.ashScene:
                        var effect = TowerDefenseManager.CreateEffectSpriteOnce(config.ashScene, character.gridPos, "Idle")
                        var charaterNode: Node2D = TowerDefenseManager.GetCharacterNode()
                        effect.global_position = character.sprite.global_position
                        effect.scale = character.scale * character.transformPoint.scale
                        charaterNode.add_child(effect)
                        effect.z_index -= 6
                character.Destroy()
    character.isExplode = false
    return num

func Hurt(num: float, playSplatAudio: bool = true, velocity: Vector2 = Vector2.ZERO, hitShield: bool = true, createDamagePart: bool = true) -> float:
    if invincible:
        return 0
    if character is TowerDefensePlant:
        if character.plantfoodMode:
            return 0
    if die:
        return 1000000.0
    var passFlag: bool = false
    if num > 0:
        if hitShield && armorShield.size() > 0:
            for armorInstance: TowerDefenseArmorInstance in armorShield:
                if armorInstance.config.armorMethodFlags & TowerDefenseEnum.ARMOR_METHOD_FLAGS.INVINCIBLE:
                    num = 0
                if armorInstance.config.armorMethodFlags & TowerDefenseEnum.ARMOR_METHOD_FLAGS.PASSDAMAGE:
                    DealHurt(num, playSplatAudio, velocity, createDamagePart)
                    passFlag = true
                num = armorInstance.Hurt(num, playSplatAudio, velocity, createDamagePart)
                if num <= 0:
                    break
        if armorHelm.size() > 0:
            for armorInstance: TowerDefenseArmorInstance in armorHelm:
                if armorInstance.config.armorMethodFlags & TowerDefenseEnum.ARMOR_METHOD_FLAGS.INVINCIBLE:
                    num = 0
                if armorInstance.config.armorMethodFlags & TowerDefenseEnum.ARMOR_METHOD_FLAGS.PASSDAMAGE:
                    DealHurt(num, playSplatAudio, velocity, createDamagePart)
                    passFlag = true
                num = armorInstance.Hurt(num, playSplatAudio, velocity, createDamagePart)
                if num <= 0:
                    break
        if armorBody.size() > 0:
            for armorInstance: TowerDefenseArmorInstance in armorBody:
                if armorInstance.config.armorMethodFlags & TowerDefenseEnum.ARMOR_METHOD_FLAGS.INVINCIBLE:
                    num = 0
                if armorInstance.config.armorMethodFlags & TowerDefenseEnum.ARMOR_METHOD_FLAGS.PASSDAMAGE:
                    DealHurt(num, playSplatAudio, velocity, createDamagePart)
                    passFlag = true
                num = armorInstance.Hurt(num, playSplatAudio, velocity, createDamagePart)
                if num <= 0:
                    break
        if num > 0:
            if !passFlag:
                num = DealHurt(num, playSplatAudio, velocity, createDamagePart)
    return num

func SmashHurt(num: float, playSplatAudio: bool = true, velocity: Vector2 = Vector2.ZERO) -> float:
    if invincible:
        return 0
    character.isSmash = true
    if character is TowerDefensePlant:
        num = 100000
        if character.plantfoodMode:
            return 0
    if config.smashHurt != -1:
        num = DealHurt(min(config.smashHurt, num), playSplatAudio, velocity)
    else:
        num = DealHurt(num, playSplatAudio, velocity)
    character.isSmash = false
    return num

func DealHurt(num: float, playSplatAudio: bool = true, velocity: Vector2 = Vector2.ZERO, createDamagePart: bool = true) -> float:
    if invincible:
        return 0
    if character is TowerDefensePlant:
        if character.plantfoodMode:
            return 0
    if character is TowerDefenseZombie:
        if playSplatAudio:
            if config.impactAudio != "":
                AudioManager.AudioPlay(config.impactAudio, AudioManagerEnum.TYPE.SFX)
            else:
                AudioManager.AudioPlay("SplatNormal", AudioManagerEnum.TYPE.SFX)

    if hitpoints > num:
        character.bodyHurt.emit(num)
        hitpoints -= num
        num = 0
    else:
        character.bodyHurt.emit(hitpoints)
        num -= hitpoints
        hitpoints = 0
    if damagePointData:
        var persontage: float = (hitpoints - config.hitpointsNearDeath) / config.hitpoints
        if damagePointIndex < damagePoints.size():
            while persontage <= damagePoints[damagePointIndex]["Persontage"]:
                var damagePointName: String = damagePoints[damagePointIndex]["Name"]
                var damageAudio: String = damagePoints[damagePointIndex]["DamageAudio"]
                if createDamagePart:
                    if velocity == Vector2.ZERO:
                        velocity = Vector2(randf_range(-100, 100) * randf_range(0.75, 1.25), -300 * randf_range(0.75, 1.25))
                    else:
                        velocity = Vector2(velocity.x * randf_range(0.75, 1.25), velocity.y * randf_range(0.75, 1.25))
                    character.DamagePartCreate(damagePointName, null, velocity)
                damagePointData.CreateEffect(character.sprite, damagePointName, character.gridPos)
                damagePointData.SetDamagePointFliters(character.sprite, damagePointName)
                if character.config.customData:
                    for customName: String in character.currentCustom:
                        character.config.customData.SetDamagePoint(character.sprite, customName, damagePointIndex)

                if playSplatAudio && damageAudio != "":
                    AudioManager.AudioPlay(damageAudio, AudioManagerEnum.TYPE.SFX)
                damagePointReach.emit(damagePointName)
                damagePointIndex += 1
                if damagePointIndex >= damagePoints.size():
                    break
    if !nearDie:
        if hitpoints <= config.hitpointsNearDeath:
            hitpointsNearDie.emit()
            nearDie = true
    if hitpoints <= 0:
        Die()
        hitpointsEmpty.emit()
    return num

func ArmorAdd(armorName: String) -> void :
    if armorName == "SpecialHelmet":
        armorOverrideUnUseBuffFlagSave = unUseBuffFlags
        unUseBuffFlags = TowerDefenseEnum.CHARACTER_BUFF_FLAGS.ALL
    if !is_instance_valid(config.armorData):
        return
    if !config.armorData.armorDictionary.has(armorName):
        return
    var armorConfig: CharacterArmorConfig = config.armorData.armorDictionary[armorName]
    var armorInstance: TowerDefenseArmorInstance = TowerDefenseArmorInstance.new(character, armorConfig)
    armorInstance.remove.connect(ArmorDestroy)
    armorInstance.hitpointsEmpty.connect(ArmorDestroy)
    armorInstance.damagePointReach.connect(ArmorDamagePointReach)
    armorList.append(armorInstance)
    if armorConfig.armorMethodFlags & TowerDefenseEnum.ARMOR_METHOD_FLAGS.SHIELD:
        armorShield.append(armorInstance)
    if armorConfig.armorMethodFlags & TowerDefenseEnum.ARMOR_METHOD_FLAGS.HELM:
        armorHelm.append(armorInstance)
    if armorConfig.armorMethodFlags & TowerDefenseEnum.ARMOR_METHOD_FLAGS.BODY:
        armorBody.append(armorInstance)

func ArmorDelete(armorName: String, createDamagePart: bool = true) -> void :
    for armorInstance: TowerDefenseArmorInstance in armorList:
        if armorInstance.config.armorName == armorName:
            armorInstance.Hurt(10000000.0, false, Vector2.ZERO, createDamagePart)

func ArmorDamagePointReach(instance: TowerDefenseArmorInstance, stage: int):
    armorDamagePointReach.emit(instance.config.armorName, stage)

func ArmorDestroy(instance: TowerDefenseArmorInstance) -> void :
    if instance.config.armorName == "SpecialHelmet":
        unUseBuffFlags = armorOverrideUnUseBuffFlagSave
    armorHitpointsEmpty.emit(instance.config.armorName)
    armorList.erase(instance)
    armorShield.erase(instance)
    armorHelm.erase(instance)
    armorBody.erase(instance)

func ArmorClear() -> void :
    for armorInstance: TowerDefenseArmorInstance in armorList:
        armorInstance.Hurt(10000000.0, false, Vector2.ZERO)

func ArmorDraw(instance: TowerDefenseArmorInstance) -> TowerDefenseMagnet:
    if !armorList.has(instance):
        return null
    var draw: TowerDefenseMagnet = instance.Draw()
    character.armmorHurt.emit(instance.hitPoints)
    armorHitpointsEmpty.emit(instance.config.armorName)
    return draw

func RefeshHitPoint() -> void :
    hitpoints = config.hitpoints

func Die() -> void :
    collisionFlags = 0
    maskFlags = TowerDefenseEnum.CHARACTER_COLLISION_FLAGS.DYING_CHARACTER
    ArmorClear()
    die = true
