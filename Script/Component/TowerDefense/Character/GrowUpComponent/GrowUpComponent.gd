class_name GrowUpComponent extends ComponentBase

@export var growUpTime: Array[float] = []
@export var growUpSize: Array[float] = []

signal grow(reach: int)

var parent: TowerDefenseCharacter

var timer: float = 0.0
var growUpReach: int = 0

func _ready() -> void :
    parent = get_parent()

@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void :
    if !alive:
        return
    if parent.die:
        return
    if parent.instance.sleep:
        return
    if !is_instance_valid(TowerDefenseManager.currentControl) || !TowerDefenseManager.currentControl.isGameRunning:
        return
    if growUpReach < growUpTime.size():
        timer += delta
        if timer > growUpTime[growUpReach]:
            grow.emit(growUpReach)
            AudioManager.AudioPlay("Grow", AudioManagerEnum.TYPE.SFX)
            var tween = create_tween()
            tween.set_parallel(true)
            tween.tween_property(parent.transformPoint, "scale", Vector2.ONE * growUpSize[growUpReach], 1.0)
            tween.tween_property(parent.shadowSprite, "scale", parent.saveShadowScale * growUpSize[growUpReach], 1.0)
            parent.saveShadowScale = parent.saveShadowScale * growUpSize[growUpReach]
            growUpReach += 1
