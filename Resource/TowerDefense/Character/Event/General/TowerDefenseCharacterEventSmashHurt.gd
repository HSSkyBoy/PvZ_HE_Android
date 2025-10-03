class_name TowerDefenseCharacterEventSmashHurt extends TowerDefenseCharacterEventBase

@export var num: float = 1800.0

@warning_ignore("unused_parameter")
func Execute(pos: Vector2, target: TowerDefenseCharacter) -> void :
    Run(pos, target, num)

@warning_ignore("unused_parameter")
func ExecuteDps(pos: Vector2, target: TowerDefenseCharacter, delta: float) -> void :
    Run(pos, target, num * delta)

func ExecuteProject(projectile: TowerDefenseProjectile, target: TowerDefenseCharacter) -> void :
    Run(projectile.global_position, target, num)

static func Run(pos: Vector2, target: TowerDefenseCharacter, _num = 20.0) -> void :
    var velocity = Vector2((target.global_position.x - pos.x) * randf_range(3, 6), -1000)
    target.SmashHurt(_num, true, velocity)
