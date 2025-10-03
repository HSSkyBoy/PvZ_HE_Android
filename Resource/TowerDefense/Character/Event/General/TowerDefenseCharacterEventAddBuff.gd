class_name TowerDefenseCharacterEventAddBuff extends TowerDefenseCharacterEventBase

@export var buffList: Array[TowerDefenseCharacterBuffConfig]

@warning_ignore("unused_parameter")
func Execute(pos: Vector2, target: TowerDefenseCharacter) -> void :
    Run(target, buffList)

@warning_ignore("unused_parameter")
func ExecuteDps(pos: Vector2, target: TowerDefenseCharacter, delta: float) -> void :
    Run(target, buffList)

@warning_ignore("unused_parameter")
func ExecuteProject(projectile: TowerDefenseProjectile, target: TowerDefenseCharacter) -> void :
    Run(target, buffList)

static func Run(target: TowerDefenseCharacter, _buffList: Array[TowerDefenseCharacterBuffConfig]) -> void :
    for buff: TowerDefenseCharacterBuffConfig in _buffList:
        target.BuffAdd(buff.duplicate(true))
