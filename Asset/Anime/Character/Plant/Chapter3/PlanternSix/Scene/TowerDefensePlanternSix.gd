@tool
extends TowerDefensePlant

const TOWER_DEFENSE_PROJECTILE_EFFECT_PLANTERN_SIX = preload("uid://nbjvjnrei6vi")

@export var attackInterval: float = 1.5
@export var eventList: Array[TowerDefenseCharacterEventBase] = []
@export var eventAttackList: Array[TowerDefenseCharacterEventBase] = []

@onready var light: PointLight2D = %Light

var attackTimer: float = 0.0

var coldCheckInterval: int = 2
var over: bool = false

func _physics_process(delta: float) -> void :
    if Engine.is_editor_hint():
        return
    super._physics_process(delta)
    light.visible = TowerDefenseManager.GetMapIsNight() && GameSaveManager.GetConfigValue("MapEffect")

@warning_ignore("unused_parameter")
func IdleProcessing(delta: float) -> void :
    super.IdleProcessing(delta)
    sprite.timeScale = timeScale

    if coldCheckInterval > 0:
        coldCheckInterval -= 1
    else:
        TowerDefenseExplode.CreateExplode(global_position, Vector2(1.3, 1.3), eventList, [], camp, -1)
        coldCheckInterval = 2

    if attackTimer >= attackInterval:
        TowerDefenseExplode.CreateExplode(global_position, Vector2(1.3, 1.3), eventAttackList, [], camp, instance.collisionFlags)
        attackTimer = 0.0
    else:
        attackTimer += delta

func DestroySet() -> void :
    if over:
        return
    over = true
    var characterNode: Node2D = TowerDefenseManager.GetCharacterNode()
    var projectileEffect: TowerDefenseProjectileEffectBase = TOWER_DEFENSE_PROJECTILE_EFFECT_PLANTERN_SIX.instantiate()
    projectileEffect.camp = camp
    projectileEffect.gridPos = gridPos
    projectileEffect.global_position = global_position
    characterNode.add_child(projectileEffect)
