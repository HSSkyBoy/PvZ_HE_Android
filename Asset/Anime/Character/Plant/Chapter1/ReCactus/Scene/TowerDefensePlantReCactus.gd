@tool
extends TowerDefensePlant

@onready var fireComponent: FireComponent = %FireComponent

@export var fireInterval: float = 1.5
@export var fireNum: int = 2

var currentFireNum: int = 0

var attackAir: bool = false

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

    shadowSprite.scale = transformPoint.scale - Vector2.ONE * (z - groundHeight) / 100.0

func IdleEntered() -> void :
    sprite.head.SetAnimation("HeadIdle", true, 0.5)
    fireComponent.alive = true
    attackAir = false

@warning_ignore("unused_parameter")
func IdleProcessing(delta: float) -> void :
    super.IdleProcessing(delta)
    sprite.head.timeScale = timeScale
    if fireComponent.CanFire("SpikeAirDefault"):
        attackAir = true
        state.send_event("ToAttack")
        return

    if fireComponent.CanFire("SpikeDefault"):
        state.send_event("ToAttack")
        return

func IdleExited() -> void :
    super.IdleExited()

func AttackEntered() -> void :
    fireComponent.Refresh()
    if attackAir:
        ySpeed = -200.0
        sprite.SetAnimation("Jump", true, 0.2)
    sprite.head.SetAnimation("HeadFire", true, 0.2)

@warning_ignore("unused_parameter")
func AttackProcessing(delta: float) -> void :
    if attackAir:
        sprite.timeScale = timeScale * 2.0
    sprite.head.timeScale = timeScale * 3.0

func AttackExited() -> void :
    pass

@warning_ignore("unused_parameter")
func AnimeEvent(command: String, argument: Variant) -> void :
    super.AnimeEvent(command, argument)
    match command:
        "fire":
            AudioManager.AudioPlay("ProjectileThrow", AudioManagerEnum.TYPE.SFX)
            var projectile: TowerDefenseProjectile
            if attackAir:
                projectile = fireComponent.CreateProjectile(0, Vector2(300, 0), "SpikeAirDefault", camp, Vector2.ZERO)
            else:
                projectile = fireComponent.CreateProjectile(0, Vector2(300, 0), "SpikeDefault", camp, Vector2.ZERO)
            projectile.gridPos = gridPos

            currentFireNum += 1
            if currentFireNum == fireNum:
                currentFireNum = 0
            else:
                sprite.head.SetAnimation("HeadFire", true, 0.1)

func AnimeCompleted(clip: String) -> void :
    super.AnimeCompleted(clip)
    match clip:
        "Jump":
            sprite.SetAnimation(idleAnimeClip, true, 0.2)

func HeadAnimeCompleted(clip: String) -> void :
    match clip:
        "HeadFire":
            if currentFireNum == 0:
                Idle()
