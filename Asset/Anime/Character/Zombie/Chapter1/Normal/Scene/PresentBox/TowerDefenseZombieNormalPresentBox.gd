@tool
extends TowerDefenseZombie

@export var packetBank: String

const IMITATER_CLOUD = preload("uid://djvfnrjg7vtqn")

var halfHp: bool = false
var isAttack: bool = false

var over: bool = false

func _ready() -> void :
    super ._ready()
    if Engine.is_editor_hint():
        return
    if TowerDefenseMapControl.instance && TowerDefenseMapControl.instance.LineHasType(gridPos.y, TowerDefenseEnum.PLANTGRIDTYPE.WATER):
        sprite.SetFliters(["Zombie_duckytube", "Zombie_whitewater", "Zombie_whitewater2"], true)

func AttackEntered():
    super .AttackEntered()
    isAttack = true
    if HasShield():
        sprite.SetFliters(["Zombie_outerarm_upper"], true)
        if !halfHp:
            sprite.SetFliters(["Zombie_outerarm_hand", "Zombie_outerarm_lower"], true)

func AttackExited() -> void :
    super .AttackExited()
    isAttack = false
    if HasShield():
        sprite.SetFliters(["Zombie_outerarm_upper", "Zombie_outerarm_hand", "Zombie_outerarm_lower"], false)

func DieProcessing(delta: float) -> void :
    super .DieProcessing(delta)
    sprite.timeScale = timeScale * 2.0

func DamagePointReach(damangePointName: String) -> void :
    super .DamagePointReach(damangePointName)
    match damangePointName:
        "Arm":
            halfHp = true
            sprite.SetFliters(["Zombie_outerarm_upper"], true)
        "Head":
            sprite.head.visible = false

func ArmorDamagePointReach(armorName: String, stage: int) -> void :
    super .ArmorDamagePointReach(armorName, stage)
    if isAttack && HasShield() && stage > 0:
        sprite.SetFliters(["Zombie_outerarm_upper"], true)
        if !halfHp:
            sprite.SetFliters(["Zombie_outerarm_hand", "Zombie_outerarm_lower"], true)

func HitpointsNearDie() -> void :
    super .HitpointsNearDie()
    CreateRandom()

func HitpointsEmpty() -> void :
    super .HitpointsEmpty()
    CreateRandom()

func CreateRandom() -> void :
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
            if instance.hypnoses:
                zombie.Hypnoses()
            TowerDefenseInGameWaveManager.instance.currentHpPointTotal += zombie.GetTotalHitPoint() / 3
            TowerDefenseInGameWaveManager.instance.currentHpPoint += zombie.GetTotalHitPoint() / 3
    Destroy.call_deferred()
