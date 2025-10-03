class_name TowerDefenseCharacterBuffRedHeat extends TowerDefenseCharacterBuffConfig

@export var time: float = 15.0

var currentTime: float = 0.0

func _init() -> void :
    key = "RedHeat"

func Enter() -> void :
    if character.instance.unUseBuffFlags & TowerDefenseEnum.CHARACTER_BUFF_FLAGS.REDHEAT:
        character.buff.BuffDelete("RedHeat")
        return
    character.SetSpriteGroupShaderParameter("redHeat", true)
    character.buff.BuffAdd(TowerDefenseCharacterBuffFireHit.new())

@warning_ignore("unused_parameter")
func Step(delta: float) -> bool:
    character.buff.BuffAdd(TowerDefenseCharacterBuffFireHit.new())
    currentTime += delta
    return currentTime >= time

func Exit() -> void :
    character.SetSpriteGroupShaderParameter("redHeat", false)

@warning_ignore("unused_parameter")
func Refresh(config: TowerDefenseCharacterBuffConfig) -> void :
    time = max(time, config.time + randf_range(-0.2, 0.2))
    currentTime = 0.0
