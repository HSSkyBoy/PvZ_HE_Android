@tool
extends TowerDefensePlant

@onready var fireComponent: FireComponent = %FireComponent

@export var fireInterval: float = 3.0
@export var fireNum: int = 1

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
    sprite.timeScale = timeScale

    if fireComponent.CanFire("SpikeMelonDefault"):
        state.send_event("ToAttack")
        return

func AttackEntered() -> void :
    fireComponent.Refresh()
    sprite.SetAnimation("Fire", true, 0.2)

@warning_ignore("unused_parameter")
func AttackProcessing(delta: float) -> void :
    sprite.timeScale = timeScale * 2.0

func AttackExited() -> void :
    pass

@warning_ignore("unused_parameter")
func AnimeEvent(command: String, argument: Variant) -> void :
    super .AnimeEvent(command, argument)
    match command:
        "fire":
            AudioManager.AudioPlay("ProjectileThrow", AudioManagerEnum.TYPE.SFX)
            var projectile: TowerDefenseProjectile = fireComponent.CreateProjectile(0, Vector2(300, 0), "SpikeMelonDefault", -1, camp, Vector2.ZERO)
            projectile.gridPos = gridPos

            currentFireNum += 1
            if currentFireNum == fireNum:
                currentFireNum = 0
            else:
                sprite.SetAnimation("Fire", true, 0.1)

func AnimeCompleted(clip: String) -> void :
    super .AnimeCompleted(clip)
    match clip:
        "Fire":
            if currentFireNum == 0:
                Idle()
