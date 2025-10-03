@tool
extends TowerDefenseZombie

const DIGGER_RISING_DIRT = preload("uid://bjev0ulao283j")

var speed: float = 50.0

var digOver: bool = false

func DigEntered() -> void :
    instance.collisionFlags = TowerDefenseEnum.CHARACTER_COLLISION_FLAGS.UNDER_GROUND
    instance.maskFlags = TowerDefenseEnum.CHARACTER_COLLISION_FLAGS.UNDER_GROUND
    sprite.SetAnimation("Dig", true, 0.2)

@warning_ignore("unused_parameter")
func DigProcessing(delta: float) -> void :
    shadowSprite.visible = false
    if attackComponent.CanAttack():
        if !nearDie && !sprite.pause && useAttackDps:
            attackComponent.AttackDps(delta, config.attack)
    else:
        if global_position.x > TowerDefenseManager.GetMapGroundRight():
            global_position.x -= speed * delta * timeScale * transformPoint.scale.x * 2.0
        else:
            global_position.x -= speed * delta * timeScale * transformPoint.scale.x
    sprite.timeScale = timeScale * 1.0

    if global_position.x < TowerDefenseManager.GetMapGroundLeft() + 30:
        state.send_event("ToDrill")
        instance.ArmorDelete("Pick")
        if !instance.hypnoses:
            scale.x = - scale.x

func DigExited() -> void :
    digOver = true
    instance.unUseBuffFlags = 0

func DrillEntered() -> void :
    instance.collisionFlags = TowerDefenseEnum.CHARACTER_COLLISION_FLAGS.GROUND_CHARACTRE
    instance.maskFlags = TowerDefenseEnum.CHARACTER_COLLISION_FLAGS.GROUND_CHARACTRE + TowerDefenseEnum.CHARACTER_COLLISION_FLAGS.GRIDITEM
    shadowSprite.visible = true
    CreateEffect()
    Rise(0.5, 0.0, false, false, 0.6)
    sprite.SetAnimation("Drill", true, 0.2)

@warning_ignore("unused_parameter")
func DrillProcessing(delta: float) -> void :
    sprite.timeScale = timeScale * 2.0

func DrillExited() -> void :
    pass

func LandEntered() -> void :
    sprite.SetAnimation("Land", false, 0.0)
    sprite.AddAnimation("Dizzy", 0.0, false, 0.2)

@warning_ignore("unused_parameter")
func LandProcessing(delta: float) -> void :
    sprite.timeScale = timeScale * 1.0

func LandExited() -> void :
    pass

func Walk() -> void :
    if digOver:
        state.send_event("ToWalk")
    else:
        state.send_event("ToDig")

func AnimeCompleted(clip: String) -> void :
    super .AnimeCompleted(clip)
    match clip:
        "Drill":
            state.send_event("ToLand")
        "Dizzy":
            Walk()

func ArmorHitpointsEmpty(armorName: String) -> void :
    super .ArmorHitpointsEmpty(armorName)
    match armorName:
        "Pick":
            state.send_event("ToDrill")

func CreateEffect() -> void :
    var effect: TowerDefenseEffectSpriteOnce = TowerDefenseManager.CreateEffectSpriteOnce(DIGGER_RISING_DIRT, gridPos)
    var characterNode: Node2D = TowerDefenseManager.GetCharacterNode()
    effect.global_position = shadowSprite.global_position - Vector2(15, 0)
    characterNode.add_child(effect)
