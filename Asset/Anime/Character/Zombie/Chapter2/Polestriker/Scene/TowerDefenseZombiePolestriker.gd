@tool
extends TowerDefenseZombie

@onready var attackComponent2: AttackComponent = %AttackComponent2
@onready var checkJumpArea: Area2D = %CheckJumpArea

var jumpOver: bool = false
var jumpMove: bool = false
var isJump: bool = false
var isBlock: bool = false
var moveTween: Tween

func _ready() -> void :
    super._ready()
    if Engine.is_editor_hint():
        return

func WalkEntered() -> void :
    if isBlock:
        isBlock = false
        if inWater:
            sprite.SetAnimation(swimAnimeClip, true, 0.0)
        else:
            sprite.SetAnimation(walkAnimeClip, true, 0.0)
    else:
        if jumpMove:
            jumpMove = false
            sprite.SetAnimation(walkAnimeClip, true, 0.0)
        else:
            sprite.SetAnimation(walkAnimeClip, true, 0.2)
    await get_tree().create_timer(0.1, false).timeout
    groundMoveComponent.alive = true

func AttackProcessing(delta: float) -> void :
    super.AttackProcessing(delta)
    sprite.timeScale = timeScale * 4.0

func DieProcessing(delta: float) -> void :
    super.DieProcessing(delta)
    sprite.timeScale = timeScale * 2.0

func RunEntered() -> void :
    sprite.SetAnimation("Run", true, 0.2)
    groundMoveComponent.alive = true

@warning_ignore("unused_parameter")
func RunProcessing(delta: float) -> void :
    sprite.timeScale = timeScale * walkSpeedScale * 2.0
    if nearDie:
        return
    if attackComponent2.CanAttack(false):
        if is_instance_valid(attackComponent2.target) && (attackComponent2.target is TowerDefensePlantBowlingBase || (attackComponent2.target.gridPos.y == gridPos.y)):
            state.send_event("ToJump")

func RunExited() -> void :
    groundMoveComponent.alive = false

func JumpEntered() -> void :
    shadowSprite.visible = false
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
                    if is_instance_valid(moveTween):
                        if moveTween.is_running():
                            moveTween.kill()

func JumpExited() -> void :
    isJump = false
    shadowSprite.visible = true
    instance.collisionFlags = TowerDefenseEnum.CHARACTER_COLLISION_FLAGS.GROUND_CHARACTRE
    instance.maskFlags = TowerDefenseEnum.CHARACTER_COLLISION_FLAGS.GROUND_CHARACTRE

func Walk() -> void :
    if jumpOver:
        state.send_event("ToWalk")
    else:
        state.send_event("ToRun")

func DamagePointReach(damangePointName: String) -> void :
    super.DamagePointReach(damangePointName)
    match damangePointName:
        "Head":
            sprite.SetFliters(["Zombie_polevaulter_innerarm_lower", "Zombie_polevaulter_innerarm_upper", "Zombie_polevaulter_innerhand", "Zombie_polevaulter_pole", "Zombie_polevaulter_pole2"], false)

func AnimeEvent(command: String, argument: Variant) -> void :
    super.AnimeEvent(command, argument)
    match command:
        "audio":
            AudioManager.AudioPlay("Polevault", AudioManagerEnum.TYPE.SFX)
        "check":
            isJump = true
            moveTween = create_tween()
            moveTween.tween_property(self, "global_position:x", global_position.x - transformPoint.scale.x * TowerDefenseManager.GetMapGridSize().x, 0.5)
        "jumpOver":
            jumpOver = true

func AnimeCompleted(clip: String) -> void :
    super.AnimeCompleted(clip)
    match clip:
        "Jump":
            jumpMove = true
            global_position.x -= transformPoint.scale.x * 148.0
            sprite.queue_redraw()
            Walk()

func HitBoxDestroy() -> void :
    super.HitBoxDestroy()
    if is_instance_valid(checkJumpArea):
        checkJumpArea.queue_free()
