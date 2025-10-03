class_name TowerDefenseCharacterEventConditionRandom extends TowerDefenseCharacterEventBase

@export var eventList: Array[TowerDefenseCharacterEventBase]
@export var percentage: float = 0.3

@warning_ignore("unused_parameter")
func Execute(pos: Vector2, target: TowerDefenseCharacter) -> void :
    Run(pos, target, eventList, percentage)

@warning_ignore("unused_parameter")
func ExecuteDps(pos: Vector2, target: TowerDefenseCharacter, delta: float) -> void :
    Run(pos, target, eventList, percentage)

@warning_ignore("unused_parameter")
func ExecuteProject(projectile: TowerDefenseProjectile, target: TowerDefenseCharacter) -> void :
    Run(projectile.global_position, target, eventList, percentage)

static func Run(_pos: Vector2, _target: TowerDefenseCharacter, _eventList: Array[TowerDefenseCharacterEventBase], _percentage: float) -> void :
    if randf() > _percentage:
        return
    for event: TowerDefenseCharacterEventBase in _eventList:
        event.Execute(_pos, _target)
