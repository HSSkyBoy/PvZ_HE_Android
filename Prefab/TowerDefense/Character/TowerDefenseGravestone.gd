@tool
class_name TowerDefenseGravestone extends TowerDefenseCharacter

@export var rise: bool = true

func _ready() -> void :
    if Engine.is_editor_hint():
        return
    super._ready()
    instance.hitpointsEmpty.connect(Destroy)
    add_to_group("Gravestone", true)
    if rise:
        Rise(randf_range(0.75, 1.25))
        SetSpriteGroupShaderParameter("surfacePos", 0.0)
