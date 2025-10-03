@tool
extends TowerDefenseZombie

func _ready() -> void :
    super ._ready()
    sprite.animeStarted.connect(AnimeStarted)

func AttackEntered() -> void :
    super .AttackEntered()
    if inWater:
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
