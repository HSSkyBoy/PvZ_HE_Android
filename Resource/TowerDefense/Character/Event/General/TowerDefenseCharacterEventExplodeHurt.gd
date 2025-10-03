class_name TowerDefenseCharacterEventExplodeHurt extends TowerDefenseCharacterEventBase

@export_enum("Bomb", "Mine") var type: String = "Bomb"
@export var num: float = 1800.0
@export var burns: bool = true

@warning_ignore("unused_parameter")
func Execute(pos: Vector2, target: TowerDefenseCharacter) -> void :
    Run(pos, type, target, num)

@warning_ignore("unused_parameter")
func ExecuteDps(pos: Vector2, target: TowerDefenseCharacter, delta: float) -> void :
    Run(pos, type, target, num * delta)

func ExecuteProject(projectile: TowerDefenseProjectile, target: TowerDefenseCharacter) -> void :
    Run(projectile.global_position, type, target, num)

static func Run(pos: Vector2, _type: String, target: TowerDefenseCharacter, _num = 20.0) -> void :
    var velocity = Vector2((target.global_position.x - pos.x) * randf_range(3, 6), -1000)
    target.ExplodeHurt(_num, _type, true, velocity)
