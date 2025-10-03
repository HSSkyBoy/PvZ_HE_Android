@tool
extends TowerDefenseZombie

@export var grab: AdobeAnimateSprite
var over: bool = false

func _ready() -> void :
    super ._ready()
    sprite.animeStarted.connect(AnimeStarted)

func AttackEntered() -> void :
    super .AttackEntered()
    if inWater:
        if !over && attackComponent.CanAttack():
            sprite.pause = true
            Drag(attackComponent.GetTarget(true, true))
            return
        instance.maskFlags = TowerDefenseEnum.CHARACTER_COLLISION_FLAGS.GROUND_CHARACTRE | TowerDefenseEnum.CHARACTER_COLLISION_FLAGS.GRIDITEM

func AttackExited() -> void :
    super .AttackEntered()
    if inWater:
        instance.maskFlags = TowerDefenseEnum.CHARACTER_COLLISION_FLAGS.UNDER_WATER

func InWater() -> void :
    super .InWater()
    instance.maskFlags = TowerDefenseEnum.CHARACTER_COLLISION_FLAGS.UNDER_WATER




func OutWater() -> void :
    groundHeight = -100
    z = -100
    SetSpriteGroupShaderParameter("surfaceDownPos", 0.4)
    super .OutWater()
    var tween = create_tween()
    tween.tween_property(sprite, ^"offset", Vector2(-50, -80), 0.25)
    global_position.x -= scale.x * 20.0
    instance.maskFlags = TowerDefenseEnum.CHARACTER_COLLISION_FLAGS.GROUND_CHARACTRE | TowerDefenseEnum.CHARACTER_COLLISION_FLAGS.GRIDITEM

func DieEntered() -> void :
    super .DieEntered()
    sprite.offset = Vector2(-50, -80)
    if inWater:
        var tween = create_tween()
        tween.set_parallel(true)
        tween.set_ease(Tween.EASE_OUT)
        tween.set_trans(Tween.TRANS_CUBIC)
        tween.tween_property(self, "groundHeight", -100.0, 1.0)
        tween.tween_property(spriteGroup.material, "shader_parameter/surfaceDownPos", 0.0, 2.0)

func AnimeStarted(clip: String) -> void :
    match clip:
        "Swim":
            sprite.offset = Vector2(-10, -100)

func AnimeCompleted(clip: String) -> void :
    super .AnimeCompleted(clip)
    match clip:
        "Jump":
            instance.maskFlags = TowerDefenseEnum.CHARACTER_COLLISION_FLAGS.UNDER_WATER
            sprite.offset = Vector2(-10, -100)
            global_position.x -= scale.x * 40.0

func DamagePointReach(damangePointName: String) -> void :
    super .DamagePointReach(damangePointName)
    match damangePointName:
        "Head":
            over = true
            sprite.head.visible = false

func Drag(character: TowerDefenseCharacter) -> void :
    if over:
        return
    over = true
    var dragFlag: bool = true
    if is_instance_valid(character):
        if !character.config.canDragIntoWater:
            dragFlag = false

    instance.invincible = true
    AudioManager.AudioPlay("Floop", AudioManagerEnum.TYPE.SFX)
    grab.visible = true
    grab.SetAnimation("Grab", false)
    grab.global_position = character.global_position
    if dragFlag:
        character.Destroy(false)
        character.sprite.pause = true
        character.HitBoxDestroy()
    itemLayer = TowerDefenseEnum.LAYER_GROUNDITEM.EFFECT
    await get_tree().create_timer(0.5).timeout








    CreateSplash()
    if dragFlag:
        if is_instance_valid(character):
            character.Destroy()

    Destroy()
