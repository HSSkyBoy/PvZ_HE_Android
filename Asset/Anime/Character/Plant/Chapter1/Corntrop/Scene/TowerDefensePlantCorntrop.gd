@tool
extends TowerDefensePlant

@onready var fireComponent: FireComponent = %FireComponent
@onready var attackComponent: AttackComponent = %AttackComponent

@export var attack: float = 20.0
@export var fireInterval: float = 1.5

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

    if fireComponent.timer <= 0 && attackComponent.CanAttack(true):
        state.send_event("ToAttack")
        return

func IdleExited() -> void :
    super.IdleExited()

func AttackEntered() -> void :
    fireComponent.Refresh()
    sprite.SetAnimation("Attack", true, 0.2)

@warning_ignore("unused_parameter")
func AttackProcessing(delta: float) -> void :
    sprite.timeScale = timeScale * 2.0

func AttackExited() -> void :
    pass

@warning_ignore("unused_parameter")
func AnimeEvent(command: String, argument: Variant) -> void :
    super.AnimeEvent(command, argument)
    match command:
        "attack":
            attackComponent.AttackAll(attack)
            AudioManager.AudioPlay("ProjectileThrow", AudioManagerEnum.TYPE.SFX)
            var projectileName: String = "KernalDefault"
            if randf() < 0.15:
                projectileName = "ButterDefault"
            for i in range(4):
                var projectile: TowerDefenseProjectile = FireComponent.CreateProjectilePosition(self, null, 0, global_position + Vector2(randf_range(-30, 30), 30), Vector2(randf_range(-20, 20), 0.0), projectileName, camp, Vector2.ZERO)
                projectile.useGravity = true
                projectile.ySpeed = -200.0
                projectile.gridPos = gridPos

func AnimeCompleted(clip: String) -> void :
    super.AnimeCompleted(clip)
    match clip:
        "Attack":
            Idle()
