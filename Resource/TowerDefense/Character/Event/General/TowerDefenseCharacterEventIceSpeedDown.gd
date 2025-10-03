class_name TowerDefenseCharacterEventIceSpeedDown extends TowerDefenseCharacterEventBase

@export var time: float = 15.0
@export var fliterShield: bool = false

@warning_ignore("unused_parameter")
func Execute(pos: Vector2, target: TowerDefenseCharacter) -> void :
    Run(target, time, fliterShield)

@warning_ignore("unused_parameter")
func ExecuteDps(pos: Vector2, target: TowerDefenseCharacter, delta: float) -> void :
    Run(target, time, fliterShield)

@warning_ignore("unused_parameter")
func ExecuteProject(projectile: TowerDefenseProjectile, target: TowerDefenseCharacter) -> void :
    Run(target, time, fliterShield)

static func Run(target: TowerDefenseCharacter, _time: float = 8.0, _fliterShield: bool = false) -> void :
    if _fliterShield && target.HasShield():
        return
    var iceSpeedDown: TowerDefenseCharacterBuffIceSpeedDown = TowerDefenseCharacterBuffIceSpeedDown.new()
    iceSpeedDown.time = _time
    target.BuffAdd(iceSpeedDown)
