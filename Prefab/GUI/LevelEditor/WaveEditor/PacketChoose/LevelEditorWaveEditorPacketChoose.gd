class_name LevelEditorWaveEditorPacketChoose extends Control

@onready var packetBankScroll: ScrollContainer = %PacketBankScroll
@onready var packetBankMargin: MarginContainer = %PacketBankMargin

@onready var packetContainer: GridContainer = %PacketContainer


@onready var animeNode: Control = %AnimeNode

static  var instance: LevelEditorWaveEditorPacketChoose

var data

var mapControl: TowerDefenseMapControl

var packetList: Array[TowerDefenseInGamePacketShow] = []

var currentCategory: String = ""
var currentIndex: int = -1

func Init(_data) -> void :
    data = _data
    PacketClear()
    await get_tree().physics_frame
    CategoryChoose("Zombie")


func _ready() -> void :
    mapControl = TowerDefenseMapControl.instance
    instance = self
    data = TowerDefenseManager.GetPacketBankData("Total")
    if data:
        Init(data)

func PacketChoose(packet: TowerDefenseInGamePacketShow) -> void :
    LevelEditorWaveEditor.instance.levelConfig.canExport = false
    var nextIndex: int = packetList.find(packet)
    if packet.alive:
        if currentIndex != -1:
            if LevelEditorWaveEditor.instance.currentPacketContainer && LevelEditorWaveEditor.instance.currentPacketContainer.CanAddPacket():
                CreateAnime(packet.config, packet.global_position, LevelEditorWaveEditor.instance.currentPacketContainer)

    if nextIndex != currentIndex:
        if currentIndex != -1:
            var prePacket: TowerDefenseInGamePacketShow = packetList[currentIndex]
            prePacket.Reset()

        currentIndex = nextIndex

func PacketNameChoose(packetName: String) -> void :
    AudioManager.AudioPlay("PacketPick", AudioManagerEnum.TYPE.SFX)
    if LevelEditorWaveEditor.instance.currentPacketContainer && LevelEditorWaveEditor.instance.currentPacketContainer.CanAddPacket():
        var selectFlsg: bool = false
        for packet: TowerDefenseInGamePacketShow in packetList:
            if packet.config.saveKey == packetName:
                if packet.alive:
                    selectFlsg = true
                    PacketChoose(packet)
                    break
        if !selectFlsg:
            var packetConfig = TowerDefenseManager.GetPacketConfig(packetName)
            var cameraPos: Vector2 = get_viewport().get_camera_2d().global_position
            CreateAnime(packetConfig, cameraPos + Vector2(300.0, 260.0), LevelEditorWaveEditor.instance.currentPacketContainer)

func PacketListChoose(_packetList: Array) -> void :
    AudioManager.AudioPlay("PacketPick", AudioManagerEnum.TYPE.SFX)
    for node in animeNode.get_children():
        node.queue_free()
    for packetName: String in _packetList:
        PacketNameChoose(packetName)

func CreateAnime(config, pos: Vector2, _packetContainer: LevelEditorWaveEditorPacketContainer) -> void :
    var animePacket: TowerDefenseInGamePacketShow = TowerDefenseManager.CreatePacketShow()
    animeNode.add_child(animePacket)
    animePacket.Init(config)
    animePacket.onlyDraw = true
    animePacket.global_position = pos

    await get_tree().physics_frame
    await get_tree().physics_frame
    var tween = animePacket.create_tween()
    tween.set_ease(Tween.EASE_OUT)
    tween.set_trans(Tween.TRANS_QUART)
    tween.tween_property(animePacket, "global_position", _packetContainer.GetPacketPos(_packetContainer.packetNum), 0.5)
    var packet: TowerDefenseInGamePacketShow = _packetContainer.AddPacket(config)
    packet.visible = false
    await tween.finished
    packet.visible = true
    animePacket.queue_free()

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

@warning_ignore("unused_parameter")
func LoveChange(packet: TowerDefenseInGamePacketShow) -> void :
    CategoryChoose(currentCategory, true)
