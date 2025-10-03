@tool
extends TowerDefenseZombie

var pop: bool = false

var speed: float = 30.0

var audioPlay: bool = false

func FlyEntered() -> void :
    sprite.SetAnimation("Idle", true, 0.2)

@warning_ignore("unused_parameter")
func FlyProcessing(delta: float) -> void :
    sprite.timeScale = timeScale
    global_position.x -= speed * delta * sprite.timeScale * transformPoint.scale.x
    if global_position.x < TowerDefenseManager.GetMapGroundLeft() + 20:
        instance.ArmorDelete("Balloon")
        return
    if !audioPlay:
        if global_position.x < TowerDefenseManager.GetMapGroundRight():
            AudioManager.AudioPlay("BalloonInflate", AudioManagerEnum.TYPE.SFX)
            audioPlay = true
    if !sprite.pause && attackComponent.CanAttack():
        state.send_event("ToFlyAttack")

func FlyExited() -> void :
    pass

func PopEntered() -> void :
    sprite.SetAnimation("Pop", false, 0.2)

@warning_ignore("unused_parameter")
func PopProcessing(delta: float) -> void :
    sprite.timeScale = timeScale * 2.0

func PopExited() -> void :
    pass

func FlyAttackEntered():
    sprite.SetAnimation("FlyEat", true, 0.2)
    startAttack = false
    await get_tree().create_timer(0.1 / sprite.timeScale, false).timeout
    startAttack = true

@warning_ignore("unused_parameter")
func FlyAttackProcessing(delta: float) -> void :
    if !attackComponent.CanAttack():
        state.send_event("ToFly")
    else:
        if startAttack && !nearDie && !sprite.pause && useAttackDps:
            attackComponent.AttackDps(delta, config.attack)
    sprite.timeScale = timeScale * 2.0

func FlyAttackExited() -> void :
    pass

func AttackProcessing(delta: float) -> void :
    super .AttackProcessing(delta)
    sprite.timeScale = timeScale * 2.0

func DieProcessing(delta: float) -> void :
    super .DieProcessing(delta)
    sprite.timeScale = timeScale * 2.0

func Walk() -> void :
    if pop:
        state.send_event("ToWalk")
    else:
        state.send_event("ToFly")

func Blow() -> void :
    if !pop:
        HitBoxDestroy()
        var tween = create_tween()
        tween.tween_property(self, ^"global_position:x", global_position.x + TowerDefenseManager.GetMapGridSize().y * TowerDefenseManager.GetMapGridNum().y * 2.0, 1.0)
        await tween.finished
        Destroy()

func AnimeCompleted(clip: String) -> void :
    super .AnimeCompleted(clip)
    match clip:
        "Pop":
            Walk()

func ArmorHitpointsEmpty(armorName: String) -> void :
    super .ArmorHitpointsEmpty(armorName)
    match armorName:
        "Balloon":
            pop = true
            AudioManager.AudioPlay("BalloonPop", AudioManagerEnum.TYPE.SFX)
            instance.collisionFlags = TowerDefenseEnum.CHARACTER_COLLISION_FLAGS.GROUND_CHARACTRE
            instance.maskFlags = TowerDefenseEnum.CHARACTER_COLLISION_FLAGS.GROUND_CHARACTRE + TowerDefenseEnum.CHARACTER_COLLISION_FLAGS.GRIDITEM
            instance.unUseBuffFlags = 0
            state.send_event("ToPop")

func DamagePointReach(damangePointName: String) -> void :
    super .DamagePointReach(damangePointName)
    match damangePointName:
        "Head":
            sprite.head = false
            DamagePartCreate("Head", sprite.propeller)
