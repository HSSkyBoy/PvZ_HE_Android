extends Control

signal pressed(_config: TowerDefensePacketConfig)

@onready var spriteNode: Control = %SpriteNode

var config: TowerDefensePacketConfig = null

var sprite: AdobeAnimateSprite

func Init(_config: TowerDefensePacketConfig):
    config = _config

    var characterConfig: TowerDefenseCharacterConfig = config.characterConfig

    sprite = TowerDefenseManager.GetCharacterSprite(characterConfig.name)
    sprite.SetAnimation(config.packetAnimeClip, true)
    sprite.light_mask = 0
    spriteNode.add_child(sprite)
    sprite.position = config.packetAnimeOffset
    sprite.scale = config.packetAnimeScale

    if characterConfig.armorData:
        if config.initArmor.size() > 0:
            for armorName: String in config.initArmor:
                var armor: CharacterArmorConfig = characterConfig.armorData.armorDictionary[armorName]
                match armor.replaceMethod:
                    "Media":
                        characterConfig.armorData.OpenArmorFliters(sprite, armorName)
                        characterConfig.armorData.SetArmorReplace(sprite, armorName, 0)
                    "Sprite":
                        var slotNode: AdobeAnimateSlot = sprite.get_node(armor.replaceSpriteSlotPath)
                        var _sprite: Sprite2D = Sprite2D.new()
                        _sprite.texture = armor.stageAnimeTexture[0]
                        _sprite.position = armor.replaceSpriteOffset
                        _sprite.rotation = armor.replaceSpriteRotation
                        _sprite.scale = armor.replaceSpriteScale
                        slotNode.add_child(_sprite)

    Reset()

func Pressed() -> void :
    if config == null:
        return
    AudioManager.AudioPlay("PacketPick", AudioManagerEnum.TYPE.SFX)
    pressed.emit(config)

func MouseEntered() -> void :
    if sprite:
        sprite.pause = false

func MouseExited() -> void :
    Reset()

func Reset() -> void :
    if sprite:
        sprite.ResetAnimation()
        sprite.pause = true
