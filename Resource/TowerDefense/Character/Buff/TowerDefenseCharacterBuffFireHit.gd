class_name TowerDefenseCharacterBuffFireHit extends TowerDefenseCharacterBuffConfig

func _init() -> void :
    key = "FireHit"

func Enter() -> void :
    character.buff.BuffDelete("IceSpeedDown")
    character.buff.BuffDelete("Frozen")

@warning_ignore("unused_parameter")
func Step(delta: float) -> bool:
    return true

func Exit() -> void :
    pass

@warning_ignore("unused_parameter")
func Refresh(config: TowerDefenseCharacterBuffConfig) -> void :
    pass
