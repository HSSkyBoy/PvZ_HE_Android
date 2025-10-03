@tool
extends TowerDefenseZombie

var over: bool = false

@warning_ignore("unused_parameter")
func WalkProcessing(delta: float) -> void :
    if global_position.x > TowerDefenseManager.GetMapGroundRight():
        sprite.timeScale = timeScale * walkSpeedScale * 2.0
    else:
        sprite.timeScale = timeScale * walkSpeedScale

    if attackComponent.CanAttack():
        if !attackComponent.target.instance.physiqueTypeFlags & TowerDefenseEnum.CHARACTER_PHYSIQUE_TYPE.SPIKE:
            attackComponent.SmashAttackCell(config.smashAttack)
        else:
            if attackComponent.target.config.spikeHurt != -1:
                attackComponent.target.Hurt(attackComponent.target.config.spikeHurt)
            Die()

func DieEntered() -> void :
    super.DieEntered()
    DestroySet()

func DestroySet() -> void :
    if over:
        return
    over = true
    var packetConfig: TowerDefensePacketConfig = TowerDefenseManager.GetPacketConfig("ZombieSleeper")
    var sleeper = packetConfig.Create(global_position + Vector2(45, 0), gridPos, 50)
    var characterNode: Node2D = TowerDefenseManager.GetCharacterNode()
    characterNode.add_child.call_deferred(sleeper)
    if instance.hypnoses:
        sleeper.Hypnoses.call_deferred()
    var tween = sleeper.create_tween()
    tween.tween_property(sleeper, ^"rotation_degrees", 0, 0.2).from(90 * scale.x)
    get_tree().create_timer(0.1, false).timeout.connect(sleeper.Walk)
