@tool
extends TowerDefensePlant

@export var eventList: Array[TowerDefenseCharacterEventBase] = []
@export var allEventList: Array[TowerDefenseCharacterEventBase] = []

@onready var attackShape: CollisionShape2D = %AttackShape
@onready var attackComponent: AttackComponent = %AttackComponent
@onready var produceComponent: ProduceComponent = %ProduceComponent
@onready var fireComponent: FireComponent = %FireComponent

@export var attackInterval: float = 3
@export var fireInterval: float = 3
@export var fireNum: int = 1
@export var produceInterval: float = 25.0
@export var sunNum: int = 150

var currentFireNum: int = 0
var attackTimer: float = 0.0

var coldCheckInterval: int = 2

func _ready() -> void :
    if Engine.is_editor_hint():
        return
    super._ready()
    attackShape.shape = attackShape.shape.duplicate(true)
    attackShape.shape.size = TowerDefenseManager.GetMapGridSize() * 2.75

    fireComponent.fireInterval = fireInterval
    produceComponent.produceInterval = produceInterval
    produceComponent.num = sunNum

@warning_ignore("unused_parameter")
func IdleProcessing(delta: float) -> void :
    super.IdleProcessing(delta)
    sprite.timeScale = timeScale

    if coldCheckInterval > 0:
        coldCheckInterval -= 1
    else:
        TowerDefenseExplode.CreateExplode(global_position, Vector2(1.3, 1.3), allEventList, [], TowerDefenseEnum.CHARACTER_CAMP.ALL, -1)
        coldCheckInterval = 2
    if attackTimer >= attackInterval:
        if attackComponent.CanAttack():
            TowerDefenseExplode.CreateExplode(global_position, Vector2(1.3, 1.3), eventList, [], camp, instance.collisionFlags)
            attackTimer = 0.0
    else:
        attackTimer += delta

    if fireComponent.CanFire("FirePeaTrack"):
        fireComponent.Refresh()
        for i in fireNum:
            var angle: float = deg_to_rad(360.0 / fireNum * float(i))
            var posOffset: Vector2 = Vector2.from_angle(angle)
            var projectile: TowerDefenseProjectile = fireComponent.CreateProjectile(0, Vector2(600, 0), "FirePeaTrack", camp)
            var tween = projectile.create_tween()
            tween.set_ease(Tween.EASE_OUT)
            tween.set_trans(Tween.TRANS_QUART)
            tween.tween_property(projectile, ^"global_position", projectile.global_position + posOffset * 50.0, 0.25)
            await get_tree().create_timer(0.1, false).timeout
