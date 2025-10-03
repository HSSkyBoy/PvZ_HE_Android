@tool
class_name GPUParticles2DMerge extends GPUParticles2D

@export_tool_button("Emit") var emitEvent: Callable = Init

func _ready() -> void :
    if Engine.is_editor_hint():
        return
    var parent = get_parent()
    if !(is_instance_valid(parent) && parent is TowerDefenseEffectParticlesOnce):
        finished.connect(queue_free)
        Init()

func Init():
    restart()
    for node in get_children():
        if node is GPUParticles2D:
            node.restart()
