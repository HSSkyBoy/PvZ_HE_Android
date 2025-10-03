class_name TowerDefenseCharacterEventSunCreate extends TowerDefenseCharacterEventBase

@export var num: float = 25.0
@export var dieCreate: bool = false

@warning_ignore("unused_parameter")
func Execute(pos: Vector2, target: TowerDefenseCharacter) -> void :
    Run(target, num, dieCreate)

@warning_ignore("unused_parameter")
func ExecuteDps(pos: Vector2, target: TowerDefenseCharacter, delta: float) -> void :
    Run(target, num * delta, dieCreate)

@warning_ignore("unused_parameter")
func ExecuteProject(projectile: TowerDefenseProjectile, target: TowerDefenseCharacter) -> void :
    Run(target, num, dieCreate)

static func Run(target: TowerDefenseCharacter, _num = 25.0, _dieCreate: bool = false) -> void :
    if _dieCreate:
        if !target.IsDie():
            return
    target.SunCreate(target.global_position, _num, TowerDefenseEnum.SUN_MOVING_METHOD.GRAVITY, Vector2(randf_range(-50.0, 50.0), -400.0), 980.0)
