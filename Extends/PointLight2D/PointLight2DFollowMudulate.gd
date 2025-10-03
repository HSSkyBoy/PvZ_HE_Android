@tool
class_name PointLight2DFollowMudulate extends PointLight2D

@export var followNode: CanvasItem
@export var saveEnergy: float = 1.5

func _ready() -> void :
    saveEnergy = energy
    energy = 0.0

@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void :
    if !Engine.is_editor_hint():
        visible = true
        if !GameSaveManager.GetConfigValue("MapEffect"):
            visible = false
            return
    if followNode:
        color = followNode.modulate
        energy = saveEnergy * color.a
