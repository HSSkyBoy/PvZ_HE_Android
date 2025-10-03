class_name TowerDefenseInGamePacketBank extends Control

@onready var packetBankScroll: ScrollContainer = %PacketBankScroll
@onready var packetBankMargin: MarginContainer = %PacketBankMargin

@onready var packetContainer: GridContainer = %PacketContainer
@onready var animeNode: Control = %AnimeNode
@export var seedBank: TowerDefenseInGameSeedBank
@export var data: TowerDefensePacketBankData

@onready var cardZombie: Control = %CardZombie
@onready var cardItem: Control = %CardItem
@onready var cardGraveStone: Control = %CardGraveStone

signal chooseOver()
signal view()

static  var instance: TowerDefenseInGamePacketBank = null

var packetList: Array[TowerDefenseInGamePacketShow] = []

var currentCategory: String = ""
var currentIndex: int = -1

func MobilePreset() -> void :
    packetBankScroll.size = Vector2(590.0, 422.0)
    packetBankScroll.position = Vector2(10.0, 34.0)
    packetBankMargin.add_theme_constant_override("margin_left", 48)
    packetBankMargin.add_theme_constant_override("margin_top", 30)
    packetBankMargin.add_theme_constant_override("margin_right", 48)
    packetBankMargin.add_theme_constant_override("margin_down", 30)
    packetContainer.columns = 6
    packetContainer.add_theme_constant_override("h_separation", 98)
    packetContainer.add_theme_constant_override("v_separation", 62)

func Init(_data: TowerDefensePacketBankData) -> void :
    data = _data
    PacketClear()
    CategoryChoose("White")


func _ready() -> void :
    if GameSaveManager.GetConfigValue("MobilePreset"):
        MobilePreset()
    instance = self
    if data:
        Init(data)

    cardZombie.visible = Global.debugPacketOpenAll
    cardItem.visible = Global.debugPacketOpenAll
    cardGraveStone.visible = Global.debugPacketOpenAll

func PacketChoose(packet: TowerDefenseInGamePacketShow) -> void :
    var nextIndex: int = packetList.find(packet)
    if packet.alive:
        if currentIndex != -1:
            if seedBank && seedBank.CanAddPacket():
                var cameraPos: Vector2 = get_viewport().get_camera_2d().global_position
                CreateAnime(packet.config, cameraPos + packet.global_position)
                packet.alive = false

    if nextIndex != currentIndex:
        if currentIndex != -1:
            var prePacket: TowerDefenseInGamePacketShow = packetList[currentIndex]
            prePacket.Reset()

        currentIndex = nextIndex

func PacketListChoose(_packetList: Array) -> void :
    AudioManager.AudioPlay("PacketPick", AudioManagerEnum.TYPE.SFX)
    for node in animeNode.get_children():
        node.queue_free()
    for packetName: String in _packetList:
        var config: TowerDefensePacketConfig = TowerDefenseManager.GetPacketConfig(packetName)
        if !config.Unlock():
            continue
        if seedBank.HasPacket(packetName):
            continue
        if seedBank && seedBank.CanAddPacket():
            var selectFlag: bool = false
            for packet: TowerDefenseInGamePacketShow in packetList:
                if packet.config.saveKey == packetName:
                    if packet.alive:
                        selectFlag = true
                        PacketChoose(packet)
                        break
            if !selectFlag:
                var packetConfig: TowerDefensePacketConfig = TowerDefenseManager.GetPacketConfig(packetName)
                var cameraPos: Vector2 = get_viewport().get_camera_2d().global_position
                CreateAnime(packetConfig, cameraPos + Vector2(300.0, 260.0))

func PacketChooseFromName(packetName: String, lock: bool = false) -> void :
    var packetConfig: TowerDefensePacketConfig = TowerDefenseManager.GetPacketConfig(packetName)
    if seedBank.HasPacket(packetName):
        return
    if seedBank.CanAddPacket():
        var packetInstance: TowerDefenseInGamePacketShow = seedBank.AddPacket(packetConfig)
        packetInstance.lock = lock
    for packet: TowerDefenseInGamePacketShow in packetList:
        if packet.config.saveKey == packetName:
            if packet.alive:
                packet.alive = false

func CreateAnime(config: TowerDefensePacketConfig, pos: Vector2) -> void :
    var cameraPos: Vector2 = Global.get_viewport().get_camera_2d().global_position
    var animePacket: TowerDefenseInGamePacketShow = TowerDefenseManager.CreatePacketShow()
    animeNode.add_child(animePacket)
    animePacket.Init(config)
    animePacket.onlyDraw = true
    animePacket.global_position = pos - cameraPos

    var tween = animePacket.create_tween()
    tween.set_ease(Tween.EASE_OUT)
    tween.set_trans(Tween.TRANS_QUART)
    tween.tween_property(animePacket, "global_position", seedBank.GetPacketPos(seedBank.packetNum), 0.5)
    var packet: TowerDefenseInGamePacketShow = seedBank.AddPacket(config, TowerDefenseManager.IsGameRunning())
    packet.visible = false
    await tween.finished
    packet.visible = true
    animePacket.queue_free()

func PacketAlive(packetName: String) -> void :
    for packet: TowerDefenseInGamePacketShow in packetList:
        if packet.config.saveKey == packetName:
            packet.alive = true
            return

func RockButtonPressed() -> void :
    if !seedBank || seedBank.packetNum <= 0:
        return
    chooseOver.emit()

    var reSelectPacketList: Array = []
    for packet: TowerDefenseInGamePacketShow in seedBank.packetList:
        reSelectPacketList.append(packet.config.saveKey)
    GameSaveManager.SetKeyValue("PacketReSlect", reSelectPacketList)
    GameSaveManager.Save()

    await get_tree().create_timer(1.0, false).timeout
    PacketClear()

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
        var config: TowerDefensePacketConfig = TowerDefenseManager.GetPacketConfig(configName)
        if !config.Unlock():
            continue
        var packet: TowerDefenseInGamePacketShow = TowerDefenseManager.CreatePacketShow()
        packetContainer.add_child(packet)
        packet.Init(config)
        packet.showLove = true
        packet.loveChange.connect(LoveChange)
        packet.pressed.connect(PacketChoose)
        packet.alive = !seedBank.HasPacket(configName)
        if Global.debugPacketOpenAll:
            packet.alive = !seedBank.HasPacket(configName)
        packetList.append(packet)

@warning_ignore("unused_parameter")
func LoveChange(packet: TowerDefenseInGamePacketShow) -> void :
    CategoryChoose(currentCategory, true)

func ReSelectButtonPressed() -> void :
    var reSelectPacketList: Array = GameSaveManager.GetKeyValue("PacketReSlect")
    seedBank.DeleteAllPacket()
    PacketListChoose(reSelectPacketList)

func ViewButtonPressed() -> void :
    view.emit()

func LoadPacketGroup(id: int) -> void :
    var packetGroupList: Array = GameSaveManager.GetKeyValue("PacketGroup%d" % id)
    seedBank.DeleteAllPacket()
    PacketListChoose(packetGroupList)

func SavePacketGroup(id: int) -> void :
    var packetGroupList: Array = []
    for packet: TowerDefenseInGamePacketShow in seedBank.packetList:
        packetGroupList.append(packet.config.saveKey)
    GameSaveManager.SetKeyValue("PacketGroup%d" % id, packetGroupList)
    GameSaveManager.Save()
