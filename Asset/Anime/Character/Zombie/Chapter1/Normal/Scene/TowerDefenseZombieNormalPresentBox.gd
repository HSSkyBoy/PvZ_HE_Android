@tool
extends TowerDefenseZombie

@export var packetBank: String

const IMITATER_CLOUD = preload("uid://djvfnrjg7vtqn")

const WALLNUT_BODY = preload("uid://d20t0jo6fekeu")
const WALLNUT_CRACKED_1 = preload("uid://dpnwmtm6ypomi")
const WALLNUT_CRACKED_2 = preload("uid://dq2ayfqxj5mfx")

var halfHp: bool = false
var isAttack: bool = false

var over: bool = false

func _ready() -> void :
    super._ready()
    if Engine.is_editor_hint():
        return
    if TowerDefenseMapControl.instance && TowerDefenseMapControl.instance.LineHasType(gridPos.y, TowerDefenseEnum.PLANTGRIDTYPE.WATER):
        sprite.SetFliters(["Zombie_duckytube", "Zombie_whitewater", "Zombie_whitewater2"], true)

func AttackEntered():
    super.AttackEntered()
    isAttack = true
    if HasShield():
        sprite.SetFliters(["Zombie_outerarm_upper"], true)
        if !halfHp:
            sprite.SetFliters(["Zombie_outerarm_hand", "Zombie_outerarm_lower"], true)

func AttackExited() -> void :
    super.AttackExited()
    isAttack = false
    if HasShield():
        sprite.SetFliters(["Zombie_outerarm_upper", "Zombie_outerarm_hand", "Zombie_outerarm_lower"], false)

func DieProcessing(delta: float) -> void :
    super.DieProcessing(delta)
    sprite.timeScale = timeScale * 2.0

func DamagePointReach(damangePointName: String) -> void :
    super.DamagePointReach(damangePointName)
    match damangePointName:
        "Arm":
            halfHp = true
            sprite.SetFliters(["Zombie_outerarm_upper"], true)
        "Head":
            sprite.head.visible = false
        "Damage1":
            sprite.head.SetReplace("Wallnut_body.png", WALLNUT_CRACKED_1)
        "Damage2":
            sprite.head.SetReplace("Wallnut_body.png", WALLNUT_CRACKED_2)

func ArmorDamagePointReach(armorName: String, stage: int) -> void :
    super.ArmorDamagePointReach(armorName, stage)
    if isAttack && HasShield() && stage > 0:
        sprite.SetFliters(["Zombie_outerarm_upper"], true)
        if !halfHp:
            sprite.SetFliters(["Zombie_outerarm_hand", "Zombie_outerarm_lower"], true)

func HitpointsNearDie() -> void :
    super.HitpointsNearDie()
    if over:
        return
    over = true


    await get_tree().physics_frame
    var effect: TowerDefenseEffectParticlesOnce = TowerDefenseManager.CreateEffectParticlesOnce(IMITATER_CLOUD, gridPos)
    var characterNode: Node2D = TowerDefenseManager.GetCharacterNode()
    effect.global_position = global_position
    characterNode.add_child(effect)
    var packetBankData: TowerDefensePacketBankData = TowerDefenseManager.GetPacketBankData(packetBank)
    if is_instance_valid(packetBankData):
        var zombieList: Array = packetBankData.GetZombieList()
        var zombieRandom: String = zombieList.pick_random()
        var packetConfig: TowerDefensePacketConfig = TowerDefenseManager.GetPacketConfig(zombieRandom)
        if is_instance_valid(packetConfig):
            var zombie = packetConfig.Plant(gridPos, true)
            zombie.global_position = global_position
            TowerDefenseInGameWaveManager.instance.currentHpPointTotal += zombie.GetTotalHitPoint()
            TowerDefenseInGameWaveManager.instance.currentHpPoint += zombie.GetTotalHitPoint()
    Destroy.call_deferred()
