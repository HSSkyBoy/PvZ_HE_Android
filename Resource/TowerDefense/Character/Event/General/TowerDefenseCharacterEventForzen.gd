class_name TowerDefenseCharacterEventForzen extends TowerDefenseCharacterEventBase

@export var time: float = 8.0
@export var iceSpeedDownTime: float = 15.0
@export var fliterShield: bool = false

@warning_ignore("unused_parameter")
func Execute(pos: Vector2, target: TowerDefenseCharacter) -> void :
    Run(target, time, iceSpeedDownTime, fliterShield)

@warning_ignore("unused_parameter")
func ExecuteDps(pos: Vector2, target: TowerDefenseCharacter, delta: float) -> void :
    Run(target, time, iceSpeedDownTime, fliterShield)

@warning_ignore("unused_parameter")
func ExecuteProject(projectile: TowerDefenseProjectile, target: TowerDefenseCharacter) -> void :
    Run(target, time, iceSpeedDownTime, fliterShield)

static func Run(target: TowerDefenseCharacter, _time: float = 8.0, _iceSpeedDownTime: float = 15.0, _fliterShield: bool = false) -> void :
    if _fliterShield && target.HasShield():
        return
    var forzen: TowerDefenseCharacterBuffFrozen = TowerDefenseCharacterBuffFrozen.new()
    forzen.time = _time
    forzen.iceSpeedDownTime = _iceSpeedDownTime
    target.BuffAdd(forzen)
