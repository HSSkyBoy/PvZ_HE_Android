@tool
extends TowerDefenseZombie

var over: bool = false

func DieProcessing(delta: float) -> void :
    super .DieProcessing(delta)
    sprite.timeScale = timeScale * 2.0


func DestroySet() -> void :
    if over:
        return
    over = true
    SpawnShadowBlack()

func SpawnShadowBlack() -> void :
    var packetConfig: TowerDefensePacketConfig = TowerDefenseManager.GetPacketConfig("ZombieShadowBlack")
    var shadow = packetConfig.Create(global_position, gridPos, 0)
    var characterNode: Node2D = TowerDefenseManager.GetCharacterNode()
    characterNode.add_child.call_deferred(shadow)
    shadow.set_deferred("instance:hitpointScale", instance.hitpointScale)
    shadow.set_deferred("scale", scale)
    if instance.hypnoses:
        shadow.Hypnoses.call_deferred()
    await get_tree().physics_frame
