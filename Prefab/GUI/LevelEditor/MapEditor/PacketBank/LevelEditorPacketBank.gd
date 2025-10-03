class_name LevelEditorPacketBank extends Control

@onready var packetBankScroll: ScrollContainer = %PacketBankScroll
@onready var packetBankMargin: MarginContainer = %PacketBankMargin

@onready var packetContainer: GridContainer = %PacketContainer
@export var data: TowerDefensePacketBankData

static  var instance: LevelEditorPacketBank

var mapControl: TowerDefenseMapControl

var packetList: Array[TowerDefenseInGamePacketShow] = []

var currentCategory: String = ""
var currentIndex: int = -1

func Init(_data: TowerDefensePacketBankData) -> void :
    data = _data
    PacketClear()
    CategoryChoose("White")


func _ready() -> void :
    mapControl = TowerDefenseMapControl.instance
    instance = self
    data = TowerDefenseManager.GetPacketBankData("Total")
    if data:
        Init(data)

func PacketChoose(packet: TowerDefenseInGamePacketShow) -> void :
    if !mapControl:
        return
    mapControl.shovelPick = false
    mapControl.shovelSprite.visible = false
    if is_instance_valid(mapControl.packetPick):
        if packet != mapControl.packetPick:
            mapControl.packetPick.Reset()
            if !mapControl.packetPick.config.characterConfig.plantCover.is_empty():
                for character: TowerDefenseCharacter in TowerDefenseManager.GetCharacter():
                    if mapControl.packetPick.config.characterConfig.plantCover.has(character.config.name):
                        character.SetSpriteGroupShaderParameter("cover", false)
    if packet.select:
        mapControl.packetPick = packet
        if !mapControl.packetPick.config.characterConfig.plantCover.is_empty():
            for character: TowerDefenseCharacter in TowerDefenseManager.GetCharacter():
                if mapControl.packetPick.config.characterConfig.plantCover.has(character.config.name):
                    character.SetSpriteGroupShaderParameter("cover", true)


        if mapControl.followSprite:
            mapControl.followSprite.queue_free()
        if mapControl.plantSprite:
            mapControl.plantSprite.queue_free()
        var characterConfig: TowerDefenseCharacterConfig = packet.config.characterConfig
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
            if packet.config.initArmor.size() > 0:
                for armorName: String in packet.config.initArmor:
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
            var packetValue: Dictionary = GameSaveManager.GetTowerDefensePacketValue(packet.config.saveKey)
            if packetValue.get_or_add("Key", {}).get_or_add("Custom", "") != "":
                characterConfig.customData.SetCustomFliters(mapControl.followSprite, packetValue["Key"]["Custom"])
                characterConfig.customData.SetCustomFliters(mapControl.plantSprite, packetValue["Key"]["Custom"])
        mapControl.spriteNode.add_child(mapControl.followSprite)
        mapControl.spriteNode.add_child(mapControl.plantSprite)


    var nextIndex: int = packetList.find(packet)
    if nextIndex != currentIndex:
        if currentIndex != -1:
            var prePacket: TowerDefenseInGamePacketShow = packetList[currentIndex]
            prePacket.Reset()

        currentIndex = nextIndex

func PacketAlive(packetName: String) -> void :
    for packet: TowerDefenseInGamePacketShow in packetList:
        if packet.config.saveKey == packetName:
            packet.alive = true
            return

func PacketClear() -> void :
    for packet in packetContainer.get_children():
        packet.queue_free()
    packetList = []
    currentIndex = 0

func CategoryChoose(_category: String, reFresh: bool = false) -> void :
    if currentCategory == _category && !reFresh:
        return
    currentCategory = _category
    PacketClear()
    if !data.category.has(_category):
        return
    var getConfigList: Array = data.category[_category]
    var configList: Array = []
    var unLoveList: Array = []
    for configName: String in getConfigList:
        var packetData: Dictionary = GameSaveManager.GetTowerDefensePacketValue(configName)
        if packetData.get_or_add("Love", false):
            configList.append(configName)
        else:
            unLoveList.append(configName)
    configList.append_array(unLoveList)

    for configName: String in configList:
        var config = TowerDefenseManager.GetPacketConfig(configName)
        var packet: TowerDefenseInGamePacketShow = TowerDefenseManager.CreatePacketShow()
        packetContainer.add_child(packet)
        packet.Init(config)
        packet.showLove = true
        packet.loveChange.connect(LoveChange)
        packet.pressed.connect(PacketChoose)
        packetList.append(packet)

    if is_instance_valid(LevelEditorMapEditor.instance):
        LevelEditorMapEditor.instance.Release()

@warning_ignore("unused_parameter")
func LoveChange(packet: TowerDefenseInGamePacketShow) -> void :
    CategoryChoose(currentCategory, true)
