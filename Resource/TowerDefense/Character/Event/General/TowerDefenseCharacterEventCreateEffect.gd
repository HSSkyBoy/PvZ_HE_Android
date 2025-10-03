class_name TowerDefenseCharacterEventCreateEffect extends TowerDefenseCharacterEventBase

@export var effectObject: ObjectManagerConfig.OBJECT = ObjectManagerConfig.OBJECT.NOONE

@warning_ignore("unused_parameter")
func Execute(pos: Vector2, target: TowerDefenseCharacter) -> void :
    Run(target, effectObject)

@warning_ignore("unused_parameter")
func ExecuteDps(pos: Vector2, target: TowerDefenseCharacter, delta: float) -> void :
    Run(target, effectObject)

@warning_ignore("unused_parameter")
func ExecuteProject(projectile: TowerDefenseProjectile, target: TowerDefenseCharacter) -> void :
    Run(target, effectObject)

static func Run(target: TowerDefenseCharacter, _effectObject: ObjectManagerConfig.OBJECT) -> void :
    var characterNode: Node2D = TowerDefenseManager.GetCharacterNode()
    var splatEffect = ObjectManager.PoolPop(_effectObject, characterNode)
    if is_instance_valid(target):
        splatEffect.gridPos.y = target.gridPos.y
        splatEffect.global_position = target.global_position - Vector2(0, 20)
