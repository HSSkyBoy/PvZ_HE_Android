@tool
extends TowerDefensePlant

const SNOW_FLAKES = preload("uid://b1ba7ajcvcgj8")

@onready var fireComponent: FireComponent = %FireComponent

@export var fireInterval: float = 1.5
@export var fireNum: int = 2

@export var eventList: Array[TowerDefenseCharacterEventBase] = []

var currentFireNum: int = 0

func _ready() -> void :
    if Engine.is_editor_hint():
        return
    super ._ready()
    fireComponent.fireInterval = fireInterval

func _physics_process(delta: float) -> void :
    if Engine.is_editor_hint():
        return
    super ._physics_process(delta)
    fireComponent.fireInterval = fireInterval

func IdleEntered() -> void :
    super .IdleEntered()
    fireComponent.alive = true

@warning_ignore("unused_parameter")
func IdleProcessing(delta: float) -> void :
    super .IdleProcessing(delta)

    if fireComponent.CanFire("SnowPea"):
        state.send_event("ToAttack")

func IdleExited() -> void :
    super .IdleExited()

func AttackEntered() -> void :
    fireComponent.Refresh()
    sprite.SetAnimation("Fire", true, 0.2 * (fireInterval + 4.5) / 6.0)

@warning_ignore("unused_parameter")
func AttackProcessing(delta: float) -> void :
    sprite.timeScale = timeScale * 3.0 * (1.75 / (fireInterval + 0.25))

func AttackExited() -> void :
    pass

@warning_ignore("unused_parameter")
func AnimeEvent(command: String, argument: Variant) -> void :
    super .AnimeEvent(command, argument)
    match command:
        "fire":
            AudioManager.AudioPlay("ProjectileThrow", AudioManagerEnum.TYPE.SFX)
            var projectile: TowerDefenseProjectile = fireComponent.CreateProjectile(0, Vector2(300, 0), "SnowPea", -1, camp, Vector2.ZERO)
            projectile.gridPos = gridPos

func AnimeCompleted(clip: String) -> void :
    super .AnimeCompleted(clip)
    match clip:
        "Fire":
            currentFireNum += 1
            if currentFireNum == fireNum:
                currentFireNum = 0
                Idle()

func DestroySet() -> void :
    ViewManager.FullScreenColorBlink(Color(0.117647, 0.564706, 1, 0.5), 0.1)
    AudioManager.AudioPlay("Frozen", AudioManagerEnum.TYPE.SFX)
    await get_tree().physics_frame
    TowerDefenseExplode.CreateExplode(global_position, Vector2(1.5, 1.5), eventList, [], camp, -1)
    var characterNode = TowerDefenseManager.GetCharacterNode()
    var effect = TowerDefenseManager.CreateEffectParticlesOnce(SNOW_FLAKES, gridPos)
    effect.global_position = global_position
    characterNode.add_child(effect)
