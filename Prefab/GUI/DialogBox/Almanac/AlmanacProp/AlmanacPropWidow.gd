extends Control

signal pressedShovel(_config: ShovelConfig)
signal pressedMower(_config: MowerConfig)

@onready var spriteNode: Control = %SpriteNode

var type: String = "Shovel"

var shovelConfig: ShovelConfig
var mowerConfig: MowerConfig

var sprite: Sprite2D

func InitShovel(_config: ShovelConfig):
    type = "Shovel"
    shovelConfig = _config

    sprite = Sprite2D.new()
    sprite.texture = shovelConfig.texture
    sprite.light_mask = 0
    sprite.scale = Vector2.ONE * 0.8
    spriteNode.add_child(sprite)

func InitMower(_config: MowerConfig):
    type = "Mower"
    mowerConfig = _config

    sprite = Sprite2D.new()
    sprite.texture = mowerConfig.texture
    sprite.light_mask = 0
    sprite.scale = Vector2.ONE * 0.5
    spriteNode.add_child(sprite)

func Pressed() -> void :
    AudioManager.AudioPlay("PacketPick", AudioManagerEnum.TYPE.SFX)
    match type:
        "Shovel":
            pressedShovel.emit(shovelConfig)
        "Mower":
            pressedMower.emit(mowerConfig)
