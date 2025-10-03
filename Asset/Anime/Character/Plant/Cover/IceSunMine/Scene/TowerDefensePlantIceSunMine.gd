@tool
extends TowerDefensePlant

const MINE_EXPLOSION = preload("uid://dqcu2ycvf4u72")
const MINE_RISE_DIRT = preload("uid://cov352ltsv2sg")
@onready var attackComponent: AttackComponent = %AttackComponent
@onready var attackComponent2: AttackComponent = %AttackComponent2

@export var readyTime: float = 15.0
@export var explodeEventList: Array[TowerDefenseCharacterEventBase] = []
@export var eventList: Array[TowerDefenseCharacterEventBase] = []
var rise: bool = false
var timer: float = 0.0
var over: bool = false

func ReadyEntered() -> void :
    if !inGame:
        return
    sprite.SetAnimation("Ready", true)

@warning_ignore("unused_parameter")
func ReadyProcessing(delta: float) -> void :
    sprite.timeScale = timeScale
    if timer < readyTime:
        timer += delta * timeScale
    else:
        ReadyRise()

func ReadyExited() -> void :
    pass

func IdleEntered() -> void :
    super.IdleEntered()
    instance.invincible = true
    sprite.SetAnimation("Rise", false, 0.2)
    sprite.AddAnimation("Idle", 0.0, true, 0.2)

@warning_ignore("unused_parameter")
func IdleProcessing(delta: float) -> void :
    super.IdleProcessing(delta)
    if sprite.clip == "Idle":
        instance.invincible = false
        if attackComponent.CanAttack():
            Explode()

        if attackComponent2.CanAttack():
            sprite.timeScale = timeScale * 2.0

func IdleExited() -> void :
    super.IdleExited()

func ReadyRise() -> void :
    if rise:
        return
    rise = true
    Idle()
    var effect: TowerDefenseEffectParticlesOnce = TowerDefenseManager.CreateEffectParticlesOnce(MINE_RISE_DIRT, gridPos)
    var characterNode: Node2D = TowerDefenseManager.GetCharacterNode()
    effect.global_position = global_position
    characterNode.add_child(effect)

func Explode() -> void :
    if over:
        return
    over = true
    ViewManager.CameraShake(Vector2(randf_range(-1, 1), randf_range(-1, 1)), 3.0, 0.05, 4)
    ViewManager.FullScreenColorBlink(Color(0.117647, 0.564706, 1, 0.5), 0.2)
    var effect: TowerDefenseEffectParticlesOnce = TowerDefenseManager.CreateEffectParticlesOnce(MINE_EXPLOSION, gridPos)
    var characterNode: Node2D = TowerDefenseManager.GetCharacterNode()
    effect.global_position = global_position
    characterNode.add_child(effect)
    TowerDefenseExplode.CreateExplode(global_position, Vector2(1.0, 0.25), explodeEventList, [], camp, instance.collisionFlags)
    AudioManager.AudioPlay("MineExplosion", AudioManagerEnum.TYPE.SFX)
    var targetList = TowerDefenseManager.GetCharacterTarget(self, false, false)
    for target: TowerDefenseCharacter in targetList:
        for event: TowerDefenseCharacterEventBase in eventList:
            event.Execute(target.global_position, target)
    SunCreate(global_position, 50, TowerDefenseEnum.SUN_MOVING_METHOD.GRAVITY, Vector2(randf_range(-50.0, 50.0), -400.0), 980.0)
    Destroy()

func Cover(character: TowerDefenseCharacter) -> void :
    if character.config.name == "PlantSunMine":
        rise = character.rise
        timer = character.timer
        if rise:
            rise = false
            await get_tree().physics_frame
            ReadyRise()
