class_name TowerDefenseCharacterEventPacketSpawn extends TowerDefenseCharacterEventBase

@export var packetName: String = ""
@export var percentage: float = 1.0
@export var dieSpawn: bool = false

@warning_ignore("unused_parameter")
func Execute(pos: Vector2, target: TowerDefenseCharacter) -> void :
    Run(target, packetName, percentage, dieSpawn)

@warning_ignore("unused_parameter")
func ExecuteDps(pos: Vector2, target: TowerDefenseCharacter, delta: float) -> void :
    Run(target, packetName, percentage, dieSpawn)

@warning_ignore("unused_parameter")
func ExecuteProject(projectile: TowerDefenseProjectile, target: TowerDefenseCharacter) -> void :
    Run(target, packetName, percentage, dieSpawn)

static func Run(target: TowerDefenseCharacter, _packetName: String, _percentage: float, _dieSpawn: bool = false) -> void :
    if randf() > _percentage:
        return
    if !_dieSpawn || (_dieSpawn && (target.instance.die || target.instance.nearDie)):
        var packetConfig: TowerDefensePacketConfig = TowerDefenseManager.GetPacketConfig(_packetName)
        if is_instance_valid(packetConfig):
            packetConfig.Plant.call_deferred(target.gridPos)
