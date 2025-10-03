@tool
extends TowerDefenseZombie

var useCone: bool = false
var useBucket: bool = false
var over: bool = false

var carryCharacter: TowerDefenseCharacter

func _ready() -> void :
    super ._ready()
    if Engine.is_editor_hint():
        return
    var rand = randf()
    if rand < 0.1:
        useBucket = true
        sprite.SetFliters(["anim_bucket"], true)
    elif rand < 0.3:
        useCone = true
        sprite.SetFliters(["anim_cone"], true)

func _physics_process(delta: float) -> void :
    super ._physics_process(delta)
    if Engine.is_editor_hint():
        return
    if !is_instance_valid(TowerDefenseManager.currentControl) || !TowerDefenseManager.currentControl.isGameRunning:
        return
    if !inGame:
        return
    if over:
        return
    if die || nearDie:
        return
    if is_instance_valid(carryCharacter):
        carryCharacter.global_position.x = global_position.x + 30

@warning_ignore("unused_parameter")
func WalkProcessing(delta: float) -> void :
    sprite.timeScale = timeScale * walkSpeedScale

    if attackComponent.CanAttack():
        if !attackComponent.target.instance.physiqueTypeFlags & TowerDefenseEnum.CHARACTER_PHYSIQUE_TYPE.SPIKE:
            attackComponent.SmashAttackCell(config.smashAttack)
        else:
            if attackComponent.target.config.spikeHurt != -1:
                attackComponent.target.Hurt(attackComponent.target.config.spikeHurt)
            Die()

func DieEntered() -> void :
    super .DieEntered()
    DestroySet()

func DestroySet() -> void :
    if over:
        return
    over = true
    HitBoxDestroy()
    sprite.SetFliters(["anim_bucket", "anim_cone", "anim_hair", "Zombie_outerarm_lower", "Zombie_outerarm_upper", "Zombie_outerarm_hand", "anim_head2", "Zombie_tie", "Zombie_body", "Zombie_outerleg_lower", "Zombie_outerleg_foot", "Zombie_outerleg_upper", "Zombie_innerleg_foot", "Zombie_innerleg_lower", "Zombie_innerleg_upper", "anim_head1", "Zombie_neck", "anim_innerarm1", "anim_innerarm2", "anim_innerarm3"], false)
    if is_instance_valid(carryCharacter):
        carryCharacter.set_deferred("isPause", false)
        carryCharacter = null
    var packetName: String = "ZombieNormal"
    if useCone:
        packetName = "ZombieNormalCone"
    if useBucket:
        packetName = "ZombieNormalBucket"
    var packetConfig: TowerDefensePacketConfig = TowerDefenseManager.GetPacketConfig(packetName)
    var zombie = packetConfig.Create(global_position, gridPos, 40)
    var characterNode: Node2D = TowerDefenseManager.GetCharacterNode()
    characterNode.add_child.call_deferred(zombie)
    zombie.set_deferred("instance:hitpointScale", instance.hitpointScale)
    zombie.set_deferred("scale", scale)
    if instance.hypnoses:
        zombie.Hypnoses.call_deferred()
    await get_tree().create_timer(0.1, false).timeout
    if is_instance_valid(zombie):
        zombie.Walk()
    await get_tree().physics_frame

func HitBoxEntered(area: Area2D) -> void :
    if over:
        return
    if !is_instance_valid(TowerDefenseManager.currentControl) || !TowerDefenseManager.currentControl.isGameRunning:
        return
    if !inGame:
        return
    if is_instance_valid(carryCharacter):
        return
    var character = area.get_parent()
    if character is TowerDefenseZombie:
        if character.isRise:
            return
        if character.camp != camp:
            return
        if !character.CanCollision(instance.maskFlags):
            return
        if character.instance.zombiePhysique > TowerDefenseEnum.ZOMBIE_PHYSIQUE.NORMAL:
            return
        if character.camp != camp:
            return
        hitBox.disconnect("area_entered", HitBoxEntered)
        carryCharacter = character
        carryCharacter.set_deferred("isPause", true)
        carryCharacter.groundHeight = groundHeight
        carryCharacter.z = z + 40

func Hypnoses(time: float = -1) -> void :
    super .Hypnoses(time)
    if is_instance_valid(carryCharacter):
        carryCharacter.set_deferred("isPause", false)
        carryCharacter = null
