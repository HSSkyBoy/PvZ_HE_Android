@tool
extends TowerDefensePlant

@onready var fireComponent: FireComponent = %FireComponent

@export var fireInterval: float = 1.5
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
    sprite.head.timeScale = timeScale * 2.0

func AttackExited() -> void :
    pass

@warning_ignore("unused_parameter")
func AnimeEvent(command: String, argument: Variant) -> void :
    super.AnimeEvent(command, argument)
    match command:
        "fire":
            AudioManager.AudioPlay("ProjectileThrow", AudioManagerEnum.TYPE.SFX)
            var projectile: TowerDefenseProjectile = fireComponent.CreateProjectile(0, Vector2(300, 0), "PeaDefault", camp, Vector2.ZERO)
            projectile.gridPos = gridPos

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
