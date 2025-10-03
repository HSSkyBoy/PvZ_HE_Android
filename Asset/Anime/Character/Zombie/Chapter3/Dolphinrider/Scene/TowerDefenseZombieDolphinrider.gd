@tool
extends TowerDefenseZombie

@onready var attackComponent2: AttackComponent = %AttackComponent2

var dolphin: bool = true:
    set(_dolphin):
        dolphin = _dolphin
        if !dolphin:
            useAttackDps = true
            walkAnimeClip = "Walk"
            attackAnimeClip = "Eat"
            dieAnimeClip = "Death"
var jumpMove: bool = false
var isJump: bool = false
var isJumpInWater: bool = false
var isBlock: bool = false

var audioPlay: bool = false

func _ready() -> void :
    super ._ready()
    sprite.animeStarted.connect(AnimeStarted)

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
    if !audioPlay:
        if global_position.x < TowerDefenseManager.GetMapGroundRight():
            AudioManager.AudioPlay("DolphinAppears", AudioManagerEnum.TYPE.SFX)
            audioPlay = true

func Walk() -> void :
    if dolphin && inWater:
        state.send_event("ToRun")
    else:
        state.send_event("ToWalk")

func RunEntered() -> void :
    if inWater:
        if !inSwimPlay && inSwimAnimeClip != "":
            sprite.SetAnimation(inSwimAnimeClip, false, 0.2)
            sprite.AddAnimation("DolphinRun", 0.0, true, 0.2)
            inSwimPlay = true
        else:
            sprite.SetAnimation("DolphinRun", true, 0.2)
    else:
        sprite.SetAnimation(walkAnimeClip, true, 0.2)
    groundMoveComponent.alive = true

@warning_ignore("unused_parameter")
func RunProcessing(delta: float) -> void :
    if sprite.clip == inSwimAnimeClip:
        sprite.timeScale = timeScale * walkSpeedScale * 2.0
    else:
        sprite.timeScale = timeScale * walkSpeedScale * 1.0
    if nearDie:
        return
    if sprite.clip == "DolphinRun":
        if attackComponent2.CanAttack(false):
            if is_instance_valid(attackComponent2.target):
                state.send_event("ToJump")

func RunExited() -> void :
    groundMoveComponent.alive = false

func JumpEntered() -> void :
    shadowSprite.visible = false
    sprite.SetAnimation("DolphinJump", false, 0.2)
    instance.collisionFlags = 0
    instance.maskFlags = 0

@warning_ignore("unused_parameter")
func JumpProcessing(delta: float) -> void :
    sprite.timeScale = timeScale * 1.0
    global_position.x -= scale.x * delta * sprite.timeScale * 16.0
    if isJump:
        if attackComponent2.CanAttack(false):
            if is_instance_valid(attackComponent2.target):
                if attackComponent2.target.config.height >= TowerDefenseEnum.CHARACTER_HEIGHT.TALL:
                    dolphin = false
                    global_position.x = attackComponent2.target.global_position.x + 40
                    waterHeight = 60
                    groundHeight = -60
                    z = -60
                    spriteGroup.position.y = - z
                    sprite.offset.x = -40
                    isBlock = true
                    AudioManager.AudioPlay("Bonk", AudioManagerEnum.TYPE.SFX)
                    Walk()

func JumpExited() -> void :
    isJump = false
    if !inWater:
        shadowSprite.visible = true
    instance.collisionFlags = TowerDefenseEnum.CHARACTER_COLLISION_FLAGS.GROUND_CHARACTRE
    instance.maskFlags = TowerDefenseEnum.CHARACTER_COLLISION_FLAGS.GROUND_CHARACTRE

func InWater() -> void :
    super .InWater()
    if !dolphin:
        sprite.offset = Vector2(24, -97)


    useAttackDps = true

func OutWater() -> void :
    super .OutWater()
    var tween = create_tween()
    tween.tween_property(sprite, ^"offset", Vector2(-40, -92), 0.25)
    if dolphin:
        global_position.x -= scale.x * 30.0
    useAttackDps = !dolphin
    waterHeight = 0

func DieEntered() -> void :
    super .DieEntered()
    sprite.offset = Vector2(-40, -92)
    if inWater:
        waterHeight = 60
        groundHeight = -60
        z = -60
        var tween = create_tween()
        tween.set_parallel(true)
        tween.set_ease(Tween.EASE_OUT)
        tween.set_trans(Tween.TRANS_CUBIC)
        tween.tween_property(self, "groundHeight", -100.0, 1.0)
        tween.tween_property(spriteGroup.material, "shader_parameter/surfaceDownPos", 0.0, 2.0)

func AnimeEvent(command: String, argument: Variant) -> void :
    super .AnimeEvent(command, argument)
    match command:
        "hit":
            attackComponent.Attack(config.smashAttack)
        "audio":
            AudioManager.AudioPlay("DolphinBeforeJumping", AudioManagerEnum.TYPE.SFX)
        "check":
            isJump = true
        "jumpOver":
            dolphin = false

func AnimeStarted(clip: String) -> void :
    match clip:
        "DolphinRun":
            pass

            sprite.offset.x = 24

func AnimeCompleted(clip: String) -> void :
    super .AnimeCompleted(clip)
    match clip:
        "DolphinJump":
            jumpMove = true
            waterHeight = 60
            groundHeight = -60
            z = -60
            spriteGroup.position.y = - z
            sprite.offset.x = -40
            global_position.x -= scale.x * transformPoint.scale.x * 104.0
            sprite.queue_redraw()
            Walk()
        "JumpInWater":
            global_position.x -= scale.x * transformPoint.scale.x * 64.0
            sprite.offset.x = 24
