@tool
extends TowerDefensePlant

@onready var fireComponent: FireComponent = %FireComponent
@onready var produceComponent: ProduceComponent = %ProduceComponent
@onready var growUpComponent: GrowUpComponent = %GrowUpComponent
@onready var attackComponent: AttackComponent = %AttackComponent
@onready var checkScaredShape: CollisionShape2D = %CheckScaredShape

@export var fireInterval: float = 1.5
@export var produceInterval: float = 25.0
@export var sunNum: int = 15
@export var growUpTime: float = 60.0
@export var fireNum: int = 1

var currentFireNum: int = 0

var projectileName: String = "PuffDefault"

func _ready() -> void :
    if Engine.is_editor_hint():
        return
    super ._ready()

    checkScaredShape.shape.size = TowerDefenseManager.GetMapGridSize() * Vector2.ONE * 2.75

    produceComponent.produceInterval = produceInterval
    produceComponent.num = sunNum

    growUpComponent.growUpTime[0] = growUpTime

    fireComponent.fireInterval = fireInterval

func _physics_process(delta: float) -> void :
    if Engine.is_editor_hint():
        return
    super ._physics_process(delta)
    fireComponent.fireInterval = fireInterval

func GowUp(reach: int) -> void :
    match reach:
        0:
            sunNum = 25
            produceComponent.num = sunNum
            projectileName = "PuffBig"

func IdleEntered() -> void :
    if Engine.is_editor_hint():
        return
    super .IdleEntered()
    fireComponent.alive = true

@warning_ignore("unused_parameter")
func IdleProcessing(delta: float) -> void :
    super .IdleProcessing(delta)
    if attackComponent.CanAttack(false, false, false):
        state.send_event("ToScared")
        return
    if fireComponent.CanFire(projectileName):
        state.send_event("ToAttack")
        return

func IdleExited() -> void :
    super .IdleExited()

func AttackEntered() -> void :
    fireComponent.Refresh()
    sprite.SetAnimation("Fire", true, 0.4)

@warning_ignore("unused_parameter")
func AttackProcessing(delta: float) -> void :
    sprite.timeScale = timeScale * 3.0
    if attackComponent.CanAttack(false, false, false):
        state.send_event("ToScared")

func AttackExited() -> void :
    pass

func ScaredEntered() -> void :
    sprite.SetAnimation("Scared", false, 0.2)
    sprite.AddAnimation("ScaredIdle", 0.0, true, 0.2)

@warning_ignore("unused_parameter")
func ScaredProcessing(delta: float) -> void :
    if !attackComponent.CanAttack(false, false, false):
        state.send_event("ToIdle")

func ScaredExited() -> void :
    pass

@warning_ignore("unused_parameter")
func AnimeEvent(command: String, argument: Variant) -> void :
    super .AnimeEvent(command, argument)
    match command:
        "fire":
            AudioManager.AudioPlay("ProjectilePuff", AudioManagerEnum.TYPE.SFX)
            var projectile: TowerDefenseProjectile
            projectile = fireComponent.CreateProjectile(0, Vector2(300, 0), projectileName, -1, camp, Vector2.ZERO)
            projectile.gridPos = gridPos
            projectile.fireLength = -1

            if fireComponent.CanFire(projectileName):
                currentFireNum = 0
                sprite.SetAnimation("HeadFire", true, 0.1 * (fireInterval + 4.5) / 6.0)
                return

            currentFireNum += 1
            if currentFireNum == fireNum:
                currentFireNum = 0
            else:
                sprite.SetAnimation("HeadFire", true, 0.1 * (fireInterval + 4.5) / 6.0)

func AnimeCompleted(clip: String) -> void :
    super .AnimeCompleted(clip)
    match clip:
        "Fire":
            Idle()
