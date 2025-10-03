@tool
extends TowerDefenseZombie

@onready var attackComponent2: AttackComponent = %AttackComponent2
@onready var checkJumpArea: Area2D = %CheckJumpArea

var jumpOver: bool = false
var jumpMove: bool = false
var isJump: bool = false
var isBlock: bool = false

func _ready() -> void :
    super ._ready()
    if Engine.is_editor_hint():
        return
    if TowerDefenseMapControl.instance && TowerDefenseMapControl.instance.LineHasType(gridPos.y, TowerDefenseEnum.PLANTGRIDTYPE.WATER):
        sprite.SetFliters(["Zombie_duckytube", "Zombie_duckytube1"], true)

func WalkEntered() -> void :
    if jumpMove:
        jumpMove = false
        if inWater:
            sprite.SetAnimation(swimAnimeClip, true, 0.0)
        else:
            sprite.SetAnimation(walkAnimeClip, true, 0.0)
    else:
        if isBlock:
            isBlock = false
            if inWater:
                sprite.SetAnimation(swimAnimeClip, true, 0.0)
            else:
                sprite.SetAnimation(walkAnimeClip, true, 0.0)
        else:
            if inWater:
                sprite.SetAnimation(swimAnimeClip, true, 0.2)
            else:
                sprite.SetAnimation(walkAnimeClip, true, 0.2)
    await get_tree().create_timer(0.1, false).timeout
    groundMoveComponent.alive = true

func WalkProcessing(delta: float) -> void :
    super .WalkProcessing(delta)
    if jumpOver:
        if inWater:
            sprite.timeScale = timeScale * walkSpeedScale * 1.0
        else:
            sprite.timeScale = timeScale * walkSpeedScale * 0.5

func AttackProcessing(delta: float) -> void :
    super .AttackProcessing(delta)
    sprite.timeScale = timeScale * 2.0

func DieProcessing(delta: float) -> void :
    super .DieProcessing(delta)
    sprite.timeScale = timeScale * 2.0

func RunEntered() -> void :
    if inWater:
        sprite.SetAnimation("SwimRun", true, 0.2)
    else:
        sprite.SetAnimation("Run", true, 0.2)
    groundMoveComponent.alive = true

@warning_ignore("unused_parameter")
func RunProcessing(delta: float) -> void :
    sprite.timeScale = timeScale * walkSpeedScale * 3.0
    if nearDie:
        return
    if attackComponent2.CanAttack(false):
        if is_instance_valid(attackComponent2.target):
            state.send_event("ToJump")

func RunExited() -> void :
    groundMoveComponent.alive = false

func JumpEntered() -> void :
    shadowSprite.visible = false
    if inWater:
        sprite.SetAnimation("SwimJump", false, 0.2)
    else:
        sprite.SetAnimation("Jump", false, 0.2)

    instance.collisionFlags = 0
    instance.maskFlags = 0

@warning_ignore("unused_parameter")
func JumpProcessing(delta: float) -> void :
    sprite.timeScale = timeScale * 2.0
    if isJump:
        if attackComponent2.CanAttack(false):
            if is_instance_valid(attackComponent2.target):
                if attackComponent2.target.config.height >= TowerDefenseEnum.CHARACTER_HEIGHT.TALL:
                    jumpOver = true
                    global_position.x = attackComponent2.target.global_position.x + 40
                    isBlock = true
                    AudioManager.AudioPlay("Bonk", AudioManagerEnum.TYPE.SFX)
                    Walk()

func JumpExited() -> void :
    isJump = false
    if !inWater:
        shadowSprite.visible = true
    instance.collisionFlags = TowerDefenseEnum.CHARACTER_COLLISION_FLAGS.GROUND_CHARACTRE
    instance.maskFlags = TowerDefenseEnum.CHARACTER_COLLISION_FLAGS.GROUND_CHARACTRE

func Walk() -> void :
    if jumpOver:
        state.send_event("ToWalk")
    else:
        state.send_event("ToRun")

func DamagePointReach(damangePointName: String) -> void :
    super .DamagePointReach(damangePointName)
    match damangePointName:
        "Head":
            sprite.SetFliters(["Zombie_polevaulter_innerarm_lower", "Zombie_polevaulter_innerarm_upper", "Zombie_polevaulter_innerhand", "Zombie_polevaulter_pole", "Zombie_polevaulter_pole2", "Zombie_polevaulter_pole 复制", "Zombie_polevaulter_pole2 复制"], false)

func AnimeEvent(command: String, argument: Variant) -> void :
    super .AnimeEvent(command, argument)
    match command:
        "audio":
            AudioManager.AudioPlay("Polevault", AudioManagerEnum.TYPE.SFX)
        "check":
            isJump = true
        "jumpOver":
            jumpOver = true

func AnimeCompleted(clip: String) -> void :
    super .AnimeCompleted(clip)
    match clip:
        "Jump":
            jumpMove = true
            global_position.x -= scale.x * transformPoint.scale.x * 148.0
            sprite.queue_redraw()
            Walk()
        "SwimJump":
            jumpMove = true
            global_position.x -= scale.x * transformPoint.scale.x * 148.0
            sprite.queue_redraw()
            Walk()

func HitBoxDestroy() -> void :
    super .HitBoxDestroy()
    if is_instance_valid(checkJumpArea):
        checkJumpArea.queue_free()

func InWater() -> void :
    super .InWater()
    sprite.SetFliters(["Zombie_whitewater", "Zombie_whitewater1"], true)

func OutWater() -> void :
    super .OutWater()
    sprite.SetFliters(["Zombie_whitewater", "Zombie_whitewater1"], false)
