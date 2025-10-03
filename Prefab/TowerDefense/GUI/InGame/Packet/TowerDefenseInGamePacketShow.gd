class_name TowerDefenseInGamePacketShow extends Control

const FZKT = preload("uid://coqskwlqtnypf")
const MOBILE_PROGRESS_TEXTURE = preload("uid://cy8jc6hsspvfy")

const PACKET_COLOUR = preload("uid://dricqt0scm3sm")
const PACKET_DIAMOND = preload("uid://eutur83nlbar")
const PACKET_GOLD = preload("uid://dfihegby6yat6")
const PACKET_NORMAL = preload("uid://bwksngvkn16cd")
const PACKET_STAR = preload("uid://bwnw5thitfc8e")
const PACKET_ZOMBIE = preload("uid://btgdkkg66xc8d")
const PACKET_COVER = preload("uid://dbkcwpq2ie7t0")
const PACKET_GRAY = preload("uid://dfy7jg4c8v30x")

const PACKET_COLOUR_MOBILE = preload("uid://cdrj5bkubm7la")
const PACKET_COVER_MOBILE = preload("uid://3k84w2g5d10r")
const PACKET_DIAMOND_MOBILE = preload("uid://1242bw5k8uwq")
const PACKET_GOLD_MOBILE = preload("uid://2smnyulcahs3")
const PACKET_NORMAL_MOBILE = preload("uid://bwfy3kman4ich")
const PACKET_STAR_MOBILE = preload("uid://dxa7vky1ueb2o")
const PACKET_ZOMBIE_MOBILE = preload("uid://csgt5dkel0xeb")

signal pressed(packet: TowerDefenseInGamePacketShow)
signal loveChange(packet: TowerDefenseInGamePacketShow)

@onready var backgroundTexture: TextureRect = %BackgroundTexture
@onready var selectTexture: NinePatchRect = %SelectTexture
@onready var mask: ColorRect = %Mask

@onready var layout: Control = %Layout
@onready var body: Control = %Body
@onready var itemCostLabel: Label = %ItemCostLabel

@onready var spriteNode: Control = %SpriteNode
@onready var button: Button = %Button

@onready var coldDownProgressBar: TextureProgressBar = %ColdDownProgressBar
@onready var coldDownTimer: Timer = %ColdDownTimer

@onready var loveButton: TextureButton = %LoveButton

@export var showLove: bool = false:
    set(_showLove):
        showLove = _showLove
        if is_node_ready():
            loveButton.visible = showLove
            var packetData: Dictionary = GameSaveManager.GetTowerDefensePacketValue(config.saveKey)
            loveButton.button_pressed = packetData.get_or_add("Love", false)

@export var showCost: bool = true:
    set(_showCost):
        showCost = _showCost
        if is_node_ready():
            itemCostLabel.visible = showCost

@export var onlyDraw: bool = false

@export var alive: bool = true:
    set(_alive):
        alive = _alive
        if alive && !lock:
            layout.modulate = Color.WHITE
        else:
            layout.modulate = Color.DIM_GRAY

@export var lock: bool = false:
    set(_lock):
        lock = _lock
        if alive && !lock:
            layout.modulate = Color.WHITE
        else:
            layout.modulate = Color.DIM_GRAY

@export var plantOnce: bool = false

@export var useCost: bool = true

var sprite: AdobeAnimateSprite

var start: bool = false

var select: bool = false:
    set(_select):
        select = _select
        selectTexture.visible = select

var config: TowerDefensePacketConfig = null:
    set(_config):
        config = _config
        if backgroundTexture:
            backgroundTexture.visible = config != null

var baseItemCost: int = 0

var itemCost: int = 100:
    set(_itemCost):
        itemCost = _itemCost
        if riseCost != -1:
            itemCostLabel.text = str(itemCost) + "+"
        else:
            itemCostLabel.text = str(itemCost)

var riseCost: int = -1

var coldDown: float = 0.0

var setMobileLayout: bool = false
var setPcLayout: bool = false

var aliveTime: float = -1
var aliveTimer: float = 0.0
var blinkTimer: float = 0.0
var blink: bool = false

func MobilePreset() -> void :
    backgroundTexture.size = Vector2(96.0, 60.0)
    backgroundTexture.position = - backgroundTexture.size / 2.0
    mask.size = Vector2(82.0, 48.0)
    mask.position = Vector2(6.0, 5.0)
    itemCostLabel.size = Vector2(48.0, 25.0)
    itemCostLabel.position = Vector2(45.0, 32.0)
    itemCostLabel.texture_filter = TextureFilter.TEXTURE_FILTER_PARENT_NODE
    itemCostLabel.add_theme_color_override("font_color", Color.WHITE)
    itemCostLabel.add_theme_constant_override("outline_size", 5)
    itemCostLabel.add_theme_font_override("font", FZKT)
    itemCostLabel.add_theme_font_size_override("font_size", 24)
    selectTexture.size = Vector2(312.0, 198.0)
    selectTexture.position = Vector2(-48.0, -30.0)
    button.size = Vector2(94.0, 60.0)
    button.position = Vector2(-48.0, -30.0)
    coldDownProgressBar.size = Vector2(95.0, 59.0)
    coldDownProgressBar.position = Vector2(-48.0, -30.0)
    coldDownProgressBar.texture_progress = MOBILE_PROGRESS_TEXTURE
    loveButton.position = Vector2(26.0, -34.0)
    spriteNode.position = Vector2(10.0, 0.0)

func Clear() -> void :
    config = null
    backgroundTexture.texture = PACKET_NORMAL
    if is_instance_valid(sprite):
        sprite.queue_free()
    baseItemCost = 0
    itemCost = 0
    riseCost = 0
    coldDown = 0

func Init(_config: TowerDefensePacketConfig) -> void :
    config = _config
    if setMobileLayout || ( !setPcLayout && GameSaveManager.GetConfigValue("MobilePreset") && SceneManager.currentScene != "LevelEditorStage"):
        match config.GetType():
            TowerDefenseEnum.PACKET_TYPE.WHITE:
                backgroundTexture.texture = PACKET_NORMAL_MOBILE
            TowerDefenseEnum.PACKET_TYPE.GOLD:
                backgroundTexture.texture = PACKET_GOLD_MOBILE
            TowerDefenseEnum.PACKET_TYPE.DIAMOND:
                backgroundTexture.texture = PACKET_DIAMOND_MOBILE
            TowerDefenseEnum.PACKET_TYPE.COLOUR:
                backgroundTexture.texture = PACKET_COLOUR_MOBILE
            TowerDefenseEnum.PACKET_TYPE.ORIGINAL:
                backgroundTexture.texture = PACKET_NORMAL_MOBILE
            TowerDefenseEnum.PACKET_TYPE.ZOMBIE:
                backgroundTexture.texture = PACKET_ZOMBIE_MOBILE
            TowerDefenseEnum.PACKET_TYPE.COVER:
                backgroundTexture.texture = PACKET_COVER_MOBILE
            TowerDefenseEnum.PACKET_TYPE.GRAY:
                backgroundTexture.texture = PACKET_GRAY
    else:
        match config.GetType():
            TowerDefenseEnum.PACKET_TYPE.WHITE:
                backgroundTexture.texture = PACKET_NORMAL
            TowerDefenseEnum.PACKET_TYPE.GOLD:
                backgroundTexture.texture = PACKET_GOLD
            TowerDefenseEnum.PACKET_TYPE.DIAMOND:
                backgroundTexture.texture = PACKET_DIAMOND
            TowerDefenseEnum.PACKET_TYPE.COLOUR:
                backgroundTexture.texture = PACKET_COLOUR
            TowerDefenseEnum.PACKET_TYPE.ORIGINAL:
                backgroundTexture.texture = PACKET_NORMAL
            TowerDefenseEnum.PACKET_TYPE.ZOMBIE:
                backgroundTexture.texture = PACKET_ZOMBIE
            TowerDefenseEnum.PACKET_TYPE.COVER:
                backgroundTexture.texture = PACKET_COVER
            TowerDefenseEnum.PACKET_TYPE.GRAY:
                backgroundTexture.texture = PACKET_GRAY

    var characterConfig: TowerDefenseCharacterConfig = config.characterConfig
    baseItemCost = config.GetCost()
    itemCost = baseItemCost

    riseCost = config.GetCostRise()
    if is_instance_valid(sprite):
        sprite.queue_free()
    sprite = TowerDefenseManager.GetCharacterSprite(characterConfig.name)
    sprite.SetAnimation(config.packetAnimeClip, true)
    sprite.pause = true
    sprite.light_mask = 0
    spriteNode.add_child(sprite)
    if setMobileLayout || ( !setPcLayout && GameSaveManager.GetConfigValue("MobilePreset") && SceneManager.currentScene != "LevelEditorStage"):
        if characterConfig is TowerDefenseZombieConfig:
            sprite.position = config.packetAnimeOffset * 1.2
            sprite.scale = config.packetAnimeScale * 1.25
        else:
            sprite.position = config.packetAnimeOffset
            sprite.scale = config.packetAnimeScale * 1.25
    else:
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
    if characterConfig.customData:
        var packetValue: Dictionary = GameSaveManager.GetTowerDefensePacketValue(config.saveKey)
        if packetValue.get_or_add("Key", {}).get_or_add("Custom", "") != "":
            characterConfig.customData.SetCustomFliters(sprite, packetValue["Key"]["Custom"])

    coldDown = config.GetPacketCooldown()
    coldDownProgressBar.max_value = coldDown
    coldDownProgressBar.value = coldDownProgressBar.max_value
    Reset()

func _ready() -> void :
    if Global.isMobile:
        button.action_mode = BaseButton.ACTION_MODE_BUTTON_PRESS
    if setMobileLayout || ( !setPcLayout && GameSaveManager.GetConfigValue("MobilePreset") && SceneManager.currentScene != "LevelEditorStage"):
        MobilePreset()
    coldDownProgressBar.visible = false

@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void :
    if onlyDraw:
        return
    button.visible = config != null

    if aliveTime != -1:
        if aliveTimer < aliveTime:
            aliveTimer += delta
            if aliveTimer > aliveTime - 5:
                if blinkTimer < 0.25:
                    blinkTimer += delta
                else:
                    if !select:
                        blink = !blink
                        if blink:
                            layout.modulate = Color.DIM_GRAY
                        else:
                            layout.modulate = Color.WHITE
                    blinkTimer = 0
        else:
            if !select:
                queue_free()
            return

    if riseCost != -1:
        var num: int = TowerDefenseManager.GetCharacterNum(config.saveKey)
        itemCost = baseItemCost + num * riseCost

    if start:
        var aliveFlag = true
        if !coldDownTimer.is_stopped():
            coldDownProgressBar.visible = true
            coldDownProgressBar.value = coldDownTimer.time_left
            aliveFlag = false
        else:
            coldDownProgressBar.visible = false

        if TowerDefenseManager.GetSun() < itemCost:
            aliveFlag = false

        if aliveFlag:
            if config.GetPlantCover().size() > 0:
                var coverFlag: bool = false
                for coverCheckName in config.GetPlantCover():
                    if TowerDefenseManager.GetCharacterNum(coverCheckName) > 0:
                        coverFlag = true
                        break
                if config.GetCoverCanDirectPlant():
                    coverFlag = true
                aliveFlag = coverFlag
        alive = aliveFlag

func Pressed() -> void :
    if onlyDraw:
        return
    if config == null:
        return
    if lock:
        return
    if !alive:
        return
    AudioManager.AudioPlay("PacketPick", AudioManagerEnum.TYPE.SFX)
    select = !select
    if select:
        config.ExecuteEventPress(self)
    pressed.emit(self)

func MouseEntered() -> void :
    if onlyDraw:
        return
    if config == null:
        return
    if lock:
        return
    if !alive:
        return
    if sprite:
        sprite.pause = false

func MouseExited() -> void :
    if onlyDraw:
        return
    if config == null:
        return
    if lock:
        return
    if !alive:
        return
    if select:
        return
    Reset()

func Reset() -> void :
    if onlyDraw:
        return
    if config == null:
        return
    select = false
    if sprite:
        sprite.ResetAnimation()
        sprite.pause = true

func StartInit() -> void :
    alive = false
    if !plantOnce && !Global.debugPacketColdDown && TowerDefenseManager.currentControl.levelConfig.packetColdDownStart:
        var startingCooldown: float = config.GetStartingCooldown()
        if startingCooldown > 0.0:
            coldDownTimer.start(startingCooldown)

func Plant(gridPos: Vector2i, useSun: bool = true) -> TowerDefenseCharacter:
    if useCost && useSun:
        TowerDefenseManager.UseSun(itemCost)
    var character = config.Plant(gridPos)
    config.ExecuteEventPlant(self)
    if Global.isEditor && SceneManager.currentScene == "LevelEditorStage":
        return character
    if plantOnce:
        queue_free()
        return character
    if !Global.debugPacketColdDown:
        coldDownProgressBar.visible = true
        coldDownTimer.start(coldDown)
    Reset()
    return character

func LoveButtonToggled(toggled: bool) -> void :
    var packetData: Dictionary = GameSaveManager.GetTowerDefensePacketValue(config.saveKey)
    packetData["Love"] = toggled
    loveButton.button_pressed = toggled
    GameSaveManager.SetTowerDefensePacketValue(config.saveKey, packetData)
    GameSaveManager.Save()
    loveChange.emit(self)
