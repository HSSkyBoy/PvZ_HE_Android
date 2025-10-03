class_name TowerDefenseCharacterEventCraterCreate extends TowerDefenseCharacterEventBase

@warning_ignore("unused_parameter")
func Execute(pos: Vector2, target: TowerDefenseCharacter) -> void :
    Run(target)

@warning_ignore("unused_parameter")
func ExecuteDps(pos: Vector2, target: TowerDefenseCharacter, delta: float) -> void :
    Run(target)

@warning_ignore("unused_parameter")
func ExecuteProject(projectile: TowerDefenseProjectile, target: TowerDefenseCharacter) -> void :
    Run(target)

@warning_ignore("unused_parameter")
func Init(valueDictionary: Dictionary) -> void :
    pass

func Export() -> Dictionary:
    return {
        "EventName": "CraterCreate", 
        "Value": {}
    }

static func Run(target: TowerDefenseCharacter) -> void :
    target.CraterCreate(true)
