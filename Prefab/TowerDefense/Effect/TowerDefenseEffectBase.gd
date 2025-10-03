@tool
class_name TowerDefenseEffectBase extends TowerDefenseGroundItemBase

func _ready() -> void :
    super._ready()
    add_to_group("Effect", true)
