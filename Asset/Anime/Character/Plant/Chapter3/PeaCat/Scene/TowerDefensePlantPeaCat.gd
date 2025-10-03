@tool
extends TowerDefensePlant

@onready var fireComponent: FireComponent = %FireComponent

@export var fireInterval: float = 3.0

func _ready() -> void :
    if Engine.is_editor_hint():
        return
    super._ready()
    fireComponent.fireInterval = fireInterval

func _physics_process(delta: float) -> void :
    if Engine.is_editor_hint():
        return
    super._physics_process(delta)
    fireComponent.fireInterval = fireInterval

func IdleEntered() -> void :
    if Engine.is_editor_hint():
        return
    super.IdleEntered()
    fireComponent.alive = true

@warning_ignore("unused_parameter")
func IdleProcessing(delta: float) -> void :
    super.IdleProcessing(delta)

    if fireComponent.CanFire("PeaTrack"):
        state.send_event("ToAttack")
        return

func IdleExited() -> void :
    super.IdleExited()

func AttackEntered() -> void :
    fireComponent.Refresh()
    sprite.SetAnimation("Fire", true, 0.2)

@warning_ignore("unused_parameter")
func AttackProcessing(delta: float) -> void :
    sprite.timeScale = timeScale * 3.0

func AttackExited() -> void :
    pass

@warning_ignore("unused_parameter")
func AnimeEvent(command: String, argument: Variant) -> void :
    super.AnimeEvent(command, argument)
    match command:
        "fire":
            AudioManager.AudioPlay("ProjectileThrow", AudioManagerEnum.TYPE.SFX)
            var projectile1: TowerDefenseProjectile
            projectile1 = fireComponent.CreateProjectile(0, Vector2(300, 0), "PeaTrack", camp, Vector2.ZERO)
            projectile1.gridPos = gridPos
            var projectile2: TowerDefenseProjectile
            projectile2 = fireComponent.CreateProjectile(1, Vector2(300, 0), "PeaTrack", camp, Vector2.ZERO)
            projectile2.gridPos = gridPos

func AnimeCompleted(clip: String) -> void :
    super.AnimeCompleted(clip)
    match clip:
        "Fire":
            Idle()
