@tool
extends TowerDefenseZombieImpBase

const IMITATER_CLOUD = preload("uid://djvfnrjg7vtqn")

@export var packetBank: String
var over: bool = false

func _ready() -> void :
    super ._ready()
    if Engine.is_editor_hint():
        return
    if TowerDefenseMapControl.instance && TowerDefenseMapControl.instance.LineHasType(gridPos.y, TowerDefenseEnum.PLANTGRIDTYPE.WATER):
        sprite.SetFliter("Zombie_duckytube", true)

func AttackProcessing(delta: float) -> void :
    super .AttackProcessing(delta)
    sprite.timeScale = timeScale * 2.0

func DieProcessing(delta: float) -> void :
    super .DieProcessing(delta)
    sprite.timeScale = timeScale * 2.0

func InWater() -> void :
    super .InWater()
    sprite.SetFliter("Zombie_whitewater", true)

func OutWater() -> void :
    super .OutWater()
    sprite.SetFliter("Zombie_whitewater", false)

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
            zombie.instance.hitpointScale = instance.hitpointScale / 2.0
            zombie.transformPoint.scale = transformPoint.scale / 1.5
            if instance.hypnoses:
                zombie.Hypnoses()
            TowerDefenseInGameWaveManager.instance.currentHpPointTotal += zombie.GetTotalHitPoint() / 3
            TowerDefenseInGameWaveManager.instance.currentHpPoint += zombie.GetTotalHitPoint() / 3
    Destroy.call_deferred()
