@tool
extends TowerDefensePlant

@export var allEventList: Array[TowerDefenseCharacterEventBase] = []

@onready var light: PointLight2D = %Light

var coldCheckInterval: int = 2

func _physics_process(delta: float) -> void :
    if Engine.is_editor_hint():
        return
    super ._physics_process(delta)
    light.visible = TowerDefenseManager.GetMapIsNight() && GameSaveManager.GetConfigValue("MapEffect")
    if coldCheckInterval > 0:
        coldCheckInterval -= 1
    else:
        TowerDefenseExplode.CreateExplode(global_position, Vector2(0.25, 0.25), allEventList, [], TowerDefenseEnum.CHARACTER_CAMP.ALL, -1)
        coldCheckInterval = 2
