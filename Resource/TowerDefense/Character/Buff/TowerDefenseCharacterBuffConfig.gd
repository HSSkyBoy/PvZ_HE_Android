class_name TowerDefenseCharacterBuffConfig extends Resource

var key: String
@export var refresh: bool = true

var character: TowerDefenseCharacter

func Enter() -> void :
    pass

@warning_ignore("unused_parameter")
func Step(delta: float) -> bool:
    return true

func Exit() -> void :
    pass

@warning_ignore("unused_parameter")
func Refresh(config: TowerDefenseCharacterBuffConfig) -> void :
    pass
