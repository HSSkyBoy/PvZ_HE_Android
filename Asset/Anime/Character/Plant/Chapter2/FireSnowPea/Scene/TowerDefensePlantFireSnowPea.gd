@tool
extends TowerDefensePlant

@onready var fireComponent: FireComponent = %FireComponent

@export var fireInterval: float = 1.5
@export var fireNum: int = 2

var currentFireNum: int = 0

func _ready() -> void :
    if Engine.is_editor_hint():
        return
    super._ready()
    fireComponent.fireInterval = fireInterval

    sprite.headRight.animeCompleted.connect(HeadAnimeCompleted)
    sprite.headRight.animeEvent.connect(AnimeEvent)
    sprite.headLeft.animeCompleted.connect(HeadAnimeCompleted)
    sprite.headLeft.animeEvent.connect(AnimeEvent)

func _physics_process(delta: float) -> void :
    if Engine.is_editor_hint():
        return
    super._physics_process(delta)
    fireComponent.fireInterval = fireInterval

func IdleEntered() -> void :
    sprite.headRight.SetAnimation("FlameHeadIdle", true, 0.2)
    sprite.headLeft.SetAnimation("ColdHeadIdle", true, 0.0)
    fireComponent.alive = true

@warning_ignore("unused_parameter")
func IdleProcessing(delta: float) -> void :
    super.IdleProcessing(delta)
    sprite.headRight.timeScale = timeScale
    sprite.headLeft.timeScale = timeScale
    if fireComponent.CanFire("PeaDefault"):
        state.send_event("ToAttack")
        return

func IdleExited() -> void :
    super.IdleExited()

func AttackEntered() -> void :
    fireComponent.Refresh()
    sprite.headRight.SetAnimation("FlameHeadFire", true, 0.2)
    sprite.headLeft.SetAnimation("ColdHeadFire", true, 0.2)

@warning_ignore("unused_parameter")
func AttackProcessing(delta: float) -> void :
    sprite.headRight.timeScale = timeScale * 3.0
    sprite.headLeft.timeScale = timeScale * 3.0

func AttackExited() -> void :
    pass

@warning_ignore("unused_parameter")
func AnimeEvent(command: String, argument: Variant) -> void :
    super.AnimeEvent(command, argument)
    match command:
        "flame_fire":
            AudioManager.AudioPlay("ProjectileThrow", AudioManagerEnum.TYPE.SFX)
            var flameProjectile: TowerDefenseProjectile = fireComponent.CreateProjectile(0, Vector2(300, 0), "FirePea", camp, Vector2.ZERO)
            flameProjectile.gridPos = gridPos
            flameProjectile.scale.x = scale.x
            var coldProjectile: TowerDefenseProjectile = fireComponent.CreateProjectile(1, Vector2(-300, 0), "SnowPea", camp, Vector2.ZERO)
            coldProjectile.gridPos = gridPos
            coldProjectile.scale.x = - scale.x
            currentFireNum += 1
            if currentFireNum == fireNum:
                currentFireNum = 0
            else:
                sprite.headRight.SetAnimation("FlameHeadFire", false, 0.1)
                sprite.headLeft.SetAnimation("ColdHeadFire", false, 0.1)

func HeadAnimeCompleted(clip: String) -> void :
    match clip:
        "FlameHeadFire":
            if currentFireNum == 0:
                Idle()
        "ColdHeadFire":
            if currentFireNum == 0:
                sprite.headLeft.SetAnimation("ColdHeadIdle", false, 0.1)

func Flip() -> void :
    scale.x = - scale.x
