class_name TowerDefenseInGameSeedBank extends Control

const TOWER_DEFENSE_IN_GAME_PACKET_SLOT = preload("res://Prefab/TowerDefense/GUI/InGame/Packet/TowerDefenseInGamePacketSlot.tscn")

signal sunCollect(num: int)
signal sunChange(num: int)

@onready var pcControl: Control = %PCControl
@onready var mobileControl: Control = %MobileControl
@onready var mobileConveyorBeltContainer: VBoxContainer = %MobileConveyorBeltContainer
@onready var mobileConveyorBelt: TowerDefenseConveyorBelt = %MobileConveyorBelt
@onready var mobileSeedContanin: MarginContainer = %MobileSeedContanin

@onready var itemContainer: HBoxContainer = %ItemContainer
@onready var packetSlotContainer = %PacketSlotContainer
@onready var packetContainer = %PacketContainer
@onready var sunLabel: Label = %SunLabel

@onready var seedContanin: MarginContainer = %SeedContanin
@onready var conveyorBeltContainer: HBoxContainer = %ConveyorBeltContainer
@onready var conveyorBelt: TowerDefenseConveyorBelt = %ConveyorBelt

@onready var shovelNode: Control = %ShovelNode
@onready var shovelButton: TextureButton = %ShovelButton
@onready var shovelSprite: Sprite2D = %ShovelSprite

@export var sunNum: int = 50
var sunNumShow: float = 50.0:
    set(_sunNumShow):
        if sunLabel:
            sunNumShow = _sunNumShow
            sunLabel.text = str(int(round(sunNumShow)))

var packetBank: TowerDefenseInGamePacketBank
var mapControl: TowerDefenseMapControl

var packetNum: int = 0

var packetList: Array[TowerDefenseInGamePacketShow] = []

var shovelConfig: ShovelConfig
var shovelShow: bool = false

var mouseIn: bool = false

func MobilePreset() -> void :
    sunLabel = %MobileSunLabel
    itemContainer = %MobileItemContainer
    packetSlotContainer = %MobilePacketSlotContainer
    packetContainer = %MobilePacketContainer
    conveyorBelt = %MobileConveyorBelt
    mobileControl.visible = true
    pcControl.queue_free()

func _ready() -> void :
    var slotNum = TowerDefenseManager.GetPacketSlotNum()
    if GameSaveManager.GetConfigValue("MobilePreset"):
        MobilePreset()
    else:
        mobileControl.queue_free()
    if Global.isMobile:
        shovelButton.action_mode = BaseButton.ACTION_MODE_BUTTON_PRESS
    else:
        conveyorBelt.custom_minimum_size = Vector2(781.0, 0.0)
    for node in packetSlotContainer.get_children():
        node.queue_free()
    for id in slotNum:
        packetSlotContainer.add_child(TOWER_DEFENSE_IN_GAME_PACKET_SLOT.instantiate())
    packetSlotContainer.visible = false

    packetBank = TowerDefenseInGamePacketBank.instance
    mapControl = TowerDefenseMapControl.instance
    packetList.clear()

    var shovelName: String = GameSaveManager.GetKeyValue("CurrentShovel")
    if !shovelName:
        shovelName = "ShovelDefault"
    shovelConfig = TowerDefenseManager.GetShovel(shovelName)
    shovelSprite.texture = shovelConfig.texture
    mapControl.shovelSprite.texture = shovelConfig.texture

@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void :
    if Global.debugSunMax:
        sunNum = 100000
    sunNumShow = sunNum
    shovelSprite.visible = !shovelButton.button_pressed
    if shovelSprite.visible:
        shovelSprite.scale = Vector2.ONE * 80.0 / shovelSprite.texture.get_width()
    shovelNode.position.x = itemContainer.size.x

@warning_ignore("unused_parameter")
func _input(event: InputEvent) -> void :
    if Input.is_action_just_pressed("Shovel"):
        shovelButton.button_pressed = !shovelButton.button_pressed
        ShovelButtonPressed()















func HasPacket(packetName: String) -> bool:
    for packet: TowerDefenseInGamePacketShow in packetList:
        if packet.config.saveKey == packetName:
            return true
    return false

func CanAddPacket() -> bool:
    return packetNum < TowerDefenseManager.seedbankPacketMax

func GetPacketPos(id: int) -> Vector2:
    return packetSlotContainer.get_child(id).global_position

func AddPacket(_packetConfig: TowerDefensePacketConfig, isStart: bool = false) -> TowerDefenseInGamePacketShow:
    packetNum += 1
    var packet: TowerDefenseInGamePacketShow = TowerDefenseManager.CreatePacketShow()
    packetContainer.add_child(packet)
    packet.Init(_packetConfig)
    packet.onlyDraw = false
    if !isStart:
        packet.pressed.connect(DeletePacket)
    else:
        packet.alive = true
        packet.onlyDraw = false
        packet.start = true
        packet.pressed.connect(PickPacket)
        packet.StartInit()
    packetList.append(packet)
    return packet

func DeletePacket(_packet: TowerDefenseInGamePacketShow) -> void :
    var id: int = packetList.find(_packet)
    packetBank.PacketAlive(_packet.config.saveKey)
    packetList.remove_at(id)
    _packet.queue_free()
    packetNum -= 1

func DeleteAllPacket() -> void :
    var clearList: Array[TowerDefenseInGamePacketShow] = []
    for packet: TowerDefenseInGamePacketShow in packetList:
        if packet.lock:
            clearList.append(packet)
            continue
        packetBank.PacketAlive(packet.config.saveKey)
        packet.queue_free()
    packetList = clearList
    packetNum = packetList.size()

func Ready() -> void :
    for packet: Node in packetContainer.get_children():
        if packet is TowerDefenseInGamePacketShow:
            packet.alive = false
            packet.lock = true
            packet.onlyDraw = true
            if packet.pressed.is_connected(DeletePacket):
                packet.pressed.disconnect(DeletePacket)

func Start() -> void :
    shovelButton.visible = true
    if GameSaveManager.GetConfigValue("MobilePreset"):
        if mobileConveyorBeltContainer.visible:
            mobileConveyorBelt.running = true
    else:
        if conveyorBeltContainer.visible:
            conveyorBelt.running = true
    for packet: Node in packetContainer.get_children():
        if packet is TowerDefenseInGamePacketShow:
            packet.alive = true
            packet.lock = false
            packet.onlyDraw = false
            packet.start = true
            packet.StartInit()
            packet.pressed.connect(PickPacket)
            if packet.pressed.is_connected(DeletePacket):
                packet.pressed.disconnect(DeletePacket)

func PickPacket(_packet: TowerDefenseInGamePacketShow) -> void :
    if !mapControl:
        return
    mapControl.shovelPick = false
    mapControl.shovelSprite.visible = false
    if is_instance_valid(mapControl.packetPick):
        if _packet != mapControl.packetPick:
            mapControl.packetPick.Reset()
            if !mapControl.packetPick.config.characterConfig.plantCover.is_empty():
                for character: TowerDefenseCharacter in TowerDefenseManager.GetCharacter():
                    if mapControl.packetPick.config.characterConfig.plantCover.has(character.config.name):
                        character.SetSpriteGroupShaderParameter("cover", false)
    if _packet.select:
        mapControl.packetPick = _packet
        if !mapControl.packetPick.config.characterConfig.plantCover.is_empty():
            for character: TowerDefenseCharacter in TowerDefenseManager.GetCharacter():
                if mapControl.packetPick.config.characterConfig.plantCover.has(character.config.name):
                    character.SetSpriteGroupShaderParameter("cover", true)


        if mapControl.followSprite:
            mapControl.followSprite.queue_free()
        if mapControl.plantSprite:
            mapControl.plantSprite.queue_free()
        var characterConfig: TowerDefenseCharacterConfig = _packet.config.characterConfig
        mapControl.followSprite = TowerDefenseManager.GetCharacterSprite(characterConfig.name)
        mapControl.followSprite.light_mask = 0
        mapControl.followSprite.z_index = 1000
        mapControl.followSprite.position = Vector2(-100, -100)

        mapControl.plantSprite = TowerDefenseManager.GetCharacterSprite(characterConfig.name)
        mapControl.plantSprite.light_mask = 0
        mapControl.plantSprite.modulate.a = 0.5
        mapControl.plantSprite.z_index = 900
        mapControl.plantSprite.position = Vector2(-100, -100)

        if characterConfig.armorData:
            if _packet.config.initArmor.size() > 0:
                for armorName: String in _packet.config.initArmor:
                    var armor: CharacterArmorConfig = characterConfig.armorData.armorDictionary[armorName]
                    match armor.replaceMethod:
                        "Media":
                            characterConfig.armorData.OpenArmorFliters(mapControl.followSprite, armorName)
                            characterConfig.armorData.SetArmorReplace(mapControl.followSprite, armorName, 0)
                            characterConfig.armorData.OpenArmorFliters(mapControl.plantSprite, armorName)
                            characterConfig.armorData.SetArmorReplace(mapControl.plantSprite, armorName, 0)
                        "Sprite":
                            var followSlotNode: AdobeAnimateSlot = mapControl.followSprite.get_node(armor.replaceSpriteSlotPath)
                            var _follosprite: Sprite2D = Sprite2D.new()
                            _follosprite.texture = armor.stageAnimeTexture[0]
                            _follosprite.position = armor.replaceSpriteOffset
                            _follosprite.rotation = armor.replaceSpriteRotation
                            _follosprite.scale = armor.replaceSpriteScale
                            followSlotNode.add_child(_follosprite)
                            var plantSlotNode: AdobeAnimateSlot = mapControl.plantSprite.get_node(armor.replaceSpriteSlotPath)
                            var _plantsprite: Sprite2D = Sprite2D.new()
                            _plantsprite.texture = armor.stageAnimeTexture[0]
                            _plantsprite.position = armor.replaceSpriteOffset
                            _plantsprite.rotation = armor.replaceSpriteRotation
                            _plantsprite.scale = armor.replaceSpriteScale
                            plantSlotNode.add_child(_plantsprite)
        if characterConfig.customData:
            var packetValue: Dictionary = GameSaveManager.GetTowerDefensePacketValue(_packet.config.saveKey)
            if packetValue.get_or_add("Key", {}).get_or_add("Custom", "") != "":
                characterConfig.customData.SetCustomFliters(mapControl.followSprite, packetValue["Key"]["Custom"])
                characterConfig.customData.SetCustomFliters(mapControl.plantSprite, packetValue["Key"]["Custom"])
        mapControl.spriteNode.add_child(mapControl.followSprite)
        mapControl.spriteNode.add_child(mapControl.plantSprite)
    else:
        Release()

func Release() -> void :
    if !mapControl:
        return
    if mapControl.shovelPick:
        AudioManager.AudioPlay("ShovelDeny", AudioManagerEnum.TYPE.SFX)
    if is_instance_valid(mapControl.packetPick):
        if !mapControl.packetPick.config.characterConfig.plantCover.is_empty():
            for character: TowerDefenseCharacter in TowerDefenseManager.GetCharacter():
                if mapControl.packetPick.config.characterConfig.plantCover.has(character.config.name):
                    character.SetSpriteGroupShaderParameter("cover", false)
        mapControl.packetPick.Reset()
        mapControl.packetPick = null
    mapControl.shovelPick = false
    mapControl.shovelSprite.visible = false
    mapControl.plantfoodPick = false
    mapControl.plantfoodSprite.visible = false
    shovelButton.button_pressed = false
    if mapControl.followSprite:
        mapControl.followSprite.queue_free()
        mapControl.followSprite = null
    if mapControl.plantSprite:
        mapControl.plantSprite.queue_free()
        mapControl.plantSprite = null

func ShovelButtonPressed() -> void :
    if !shovelShow && !TowerDefenseManager.currentControl.isGameRunning:
        shovelButton.button_pressed = false
        return
    if !mapControl:
        return
    if is_instance_valid(mapControl.packetPick):
        mapControl.packetPick.Reset()
        mapControl.packetPick = null
        if mapControl.followSprite:
            mapControl.followSprite.queue_free()
            mapControl.followSprite = null
        if mapControl.plantSprite:
            mapControl.plantSprite.queue_free()
            mapControl.plantSprite = null
    if shovelButton.button_pressed:
        AudioManager.AudioPlay("Shovel", AudioManagerEnum.TYPE.SFX)
        mapControl.shovelPick = true
        mapControl.shovelSprite.position = Vector2(-100, -100)
        mapControl.shovelSprite.visible = true
    else:
        AudioManager.AudioPlay("ShovelDeny", AudioManagerEnum.TYPE.SFX)
        mapControl.shovelPick = false
        mapControl.shovelSprite.visible = false

func PlantfoodPick() -> void :
    if !mapControl:
        return
    mapControl.plantfoodPick = true
    mapControl.plantfoodSprite.position = Vector2(-100, -100)
    mapControl.plantfoodSprite.visible = true

func AddSun(num: int) -> void :
    sunNum += num
    sunCollect.emit(num)
    sunChange.emit(sunNum)

func UseSun(num: int) -> void :
    sunNum -= num
    sunChange.emit(sunNum)

func SetSun(num: int) -> void :
    sunNum = num
    sunChange.emit(sunNum)
