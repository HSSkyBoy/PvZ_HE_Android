class_name TowerDefenseCharacterBuffButter extends TowerDefenseCharacterBuffConfig

const BUTTER_SPLAT = preload("uid://cf2k7klghh2nl")

@export var time: float = 8.0
var currentTime: float = 0.0
var butterSprite: Sprite2D

func _init() -> void :
    key = "Butter"

func Enter() -> void :
    if character.instance.unUseBuffFlags & TowerDefenseEnum.CHARACTER_BUFF_FLAGS.BUTTER:
        character.buff.BuffDelete("Butter")
        return
    if character.headSlot:
        if !butterSprite:
            butterSprite = Sprite2D.new()
            butterSprite.texture = BUTTER_SPLAT
            butterSprite.rotation = -0.4
            butterSprite.position = Vector2(-5, -10)
            character.headSlot.add_child(butterSprite)
    character.sprite.pause = true

@warning_ignore("unused_parameter")
func Step(delta: float) -> bool:
    currentTime += delta
    return character.nearDie || character.die || currentTime >= time

func Exit() -> void :
    if butterSprite:
        butterSprite.queue_free()
    character.sprite.pause = false

@warning_ignore("unused_parameter")
func Refresh(config: TowerDefenseCharacterBuffConfig) -> void :
    time = max(time, config.time)
    currentTime = 0.0
