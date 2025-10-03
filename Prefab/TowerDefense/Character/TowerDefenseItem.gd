@tool
class_name TowerDefenseItem extends TowerDefenseCharacter

func _ready() -> void :
    if Engine.is_editor_hint():
        return
    super._ready()
    instance.hitpointsEmpty.connect(Destroy)
    add_to_group("Item", true)
