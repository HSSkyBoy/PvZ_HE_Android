@tool
extends TowerDefensePlant

@export var eventList: Array[TowerDefenseCharacterEventBase] = []

@onready var attackShape: CollisionShape2D = %AttackShape
@onready var light: PointLight2D = %Light

@export var attackInterval: float = 3
var attackTimer: float = 0.0

func _physics_process(delta: float) -> void :
    if Engine.is_editor_hint():
        return
    super ._physics_process(delta)
    light.visible = TowerDefenseManager.GetMapIsNight() && GameSaveManager.GetConfigValue("MapEffect")

@warning_ignore("unused_parameter")
func IdleProcessing(delta: float) -> void :
    super .IdleProcessing(delta)
    sprite.timeScale = timeScale

    if attackTimer >= attackInterval:
        TowerDefenseExplode.CreateExplode(global_position, Vector2(1.5, 0.25), eventList, [], camp, instance.collisionFlags | TowerDefenseEnum.CHARACTER_COLLISION_FLAGS.UNDER_GROUND | TowerDefenseEnum.CHARACTER_COLLISION_FLAGS.UNDER_WATER)
        attackTimer = 0.0
    else:
        attackTimer += delta
