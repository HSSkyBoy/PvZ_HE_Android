@tool
extends TowerDefensePlant

@onready var fireComponent: FireComponent = %FireComponent

@export var fireInterval: float = 2.0
@export var fireNum: int = 1

var currentFireNum: int = 0

func _ready() -> void :
    if Engine.is_editor_hint():
        return
    super._ready()
    fireComponent.fireInterval = fireInterval

    sprite.head.animeCompleted.connect(HeadAnimeCompleted)
    sprite.head.animeEvent.connect(AnimeEvent)

func _physics_process(delta: float) -> void :
    if Engine.is_editor_hint():
        return
    super._physics_process(delta)
    fireComponent.fireInterval = fireInterval

func IdleEntered() -> void :
    sprite.head.SetAnimation("HeadIdle", true, 0.5)
    fireComponent.alive = true

@warning_ignore("unused_parameter")
func IdleProcessing(delta: float) -> void :
    super.IdleProcessing(delta)
    sprite.head.timeScale = timeScale

    if fireComponent.CanFire("PeaDefault"):
        state.send_event("ToAttack")
        return

func IdleExited() -> void :
    pass

func AttackEntered() -> void :
    fireComponent.Refresh()
    sprite.head.SetAnimation("HeadFire", true, 0.2)

@warning_ignore("unused_parameter")
func AttackProcessing(delta: float) -> void :
    sprite.head.timeScale = timeScale * 3.0

func AttackExited() -> void :
    pass

@warning_ignore("unused_parameter")
func AnimeEvent(command: String, argument: Variant) -> void :
    super.AnimeEvent(command, argument)
    match command:
        "fire":
            AudioManager.AudioPlay("ProjectileThrow", AudioManagerEnum.TYPE.SFX)
            for i in 5:
                var angle: float = deg_to_rad(15 - i * 7.5)
                var dir: Vector2 = Vector2.from_angle(angle)
                var projectile: TowerDefenseProjectile = fireComponent.CreateProjectile(0, dir * 300.0, "PeaDefault", camp, Vector2.ZERO)
                projectile.gridPos = gridPos
                projectile.checkAll = true

            currentFireNum += 1
            if currentFireNum == fireNum:
                currentFireNum = 0
            else:
                sprite.head.SetAnimation("HeadFire", true, 0.1)

func HeadAnimeCompleted(clip: String) -> void :
    match clip:
        "HeadFire":
            if currentFireNum == 0:
                Idle()
