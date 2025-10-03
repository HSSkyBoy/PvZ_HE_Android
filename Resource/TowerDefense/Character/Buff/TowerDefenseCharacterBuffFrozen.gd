class_name TowerDefenseCharacterBuffFrozen extends TowerDefenseCharacterBuffConfig

@export var time: float = 8.0
@export var iceSpeedDownTime: float = 15.0
var currentTime: float = 0.0

func _init() -> void :
    key = "Frozen"

func Enter() -> void :
    if character.instance.unUseBuffFlags & TowerDefenseEnum.CHARACTER_BUFF_FLAGS.FROZEN:
        character.buff.BuffDelete("Frozen")
        return
    character.buff.BuffDelete("Burn")
    character.SetSpriteGroupShaderParameter("iceSpeedDown", true)
    character.sprite.pause = true
    character.icetrapSprite.visible = true

@warning_ignore("unused_parameter")
func Step(delta: float) -> bool:
    currentTime += delta
    return character.nearDie || character.die || currentTime >= time

func Exit() -> void :
    character.icetrapSprite.visible = false
    character.sprite.pause = false
    character.CreateIceTrap()
    if iceSpeedDownTime == 0.0:
        character.SetSpriteGroupShaderParameter("iceSpeedDown", false)
    else:
        var iceSpeedDownBuff: TowerDefenseCharacterBuffIceSpeedDown = TowerDefenseCharacterBuffIceSpeedDown.new()
        iceSpeedDownBuff.time = iceSpeedDownTime
        character.buff.BuffAdd(iceSpeedDownBuff)

@warning_ignore("unused_parameter")
func Refresh(config: TowerDefenseCharacterBuffConfig) -> void :
    time = max(time, config.time + randf_range(-0.2, 0.2))
    iceSpeedDownTime = config.iceSpeedDownTime
    currentTime = 0.0
