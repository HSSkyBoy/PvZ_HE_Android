extends DialogBoxBase

const ALMANAC_ZOMBIE_WIDOW = preload("uid://r4o1fp1gc7bg")
const ALMANAC_PROP_WIDOW = preload("uid://uhke44e0fue6")

@onready var packetMargin: MarginContainer = %PacketMargin

@onready var plantLayer: CanvasLayer = %PlantLayer
@onready var plantPacketContainer: HFlowContainer = %PacketContainer
@onready var plantInformationPanel: InformationPanel = %PlantInformationPanel

@onready var zombieLayer: CanvasLayer = %ZombieLayer
@onready var zombiePacketContainer: HFlowContainer = %ZombiePacketContainer
@onready var zombieInformationPanel: InformationPanel = %ZombieInformationPanel

@onready var propLayer: CanvasLayer = %PropLayer
@onready var propShovelContainer: GridContainer = %PropShovelContainer
@onready var propMowerContainer: GridContainer = %PropMowerContainer
@onready var propInformationPanel: InformationPanel = %PropInformationPanel
@onready var propUseButton: NinePatchButtonBase = %PropUseButton

var plantPacketBank: TowerDefensePacketBankData
var zombiePacketBank: TowerDefensePacketBankData

var plantCategoryId: int = 0
var plantCurrentSelect: TowerDefenseInGamePacketShow

var propType: String = "Shovel"
var propKey: String = ""

var audio: AudioStreamPlayerMember
var isPlaying: bool = false

func MobilePreset() -> void :
    packetMargin.add_theme_constant_override("margin_left", 48)
    packetMargin.add_theme_constant_override("margin_top", 30)
    packetMargin.add_theme_constant_override("margin_right", 48)
    packetMargin.add_theme_constant_override("margin_down", 30)
    plantPacketContainer.add_theme_constant_override("h_separation", 98)
    plantPacketContainer.add_theme_constant_override("v_separation", 62)

func _enter_tree() -> void :
    audio = AudioManager.MemberFind("ChooseYourSeeds", AudioManagerEnum.TYPE.MUSIC)
    audio.process_mode = PROCESS_MODE_ALWAYS
    isPlaying = audio.playing

func _ready() -> void :
    super ._ready()
    if GameSaveManager.GetConfigValue("MobilePreset"):
        MobilePreset()
    plantPacketBank = TowerDefenseManager.GetPacketBankData("GeneralPlant")
    zombiePacketBank = TowerDefenseManager.GetPacketBankData("GeneralZombie")
    InitPlant()
    InitZombie()
    InitProp()
    if !isPlaying:
        audio.play()

func InitPlant() -> void :
    for packet in plantPacketContainer.get_children():
        packet.queue_free()
    if plantCategoryId >= plantPacketBank.category.size():
        return
    var getConfigList: Array = plantPacketBank.category[plantPacketBank.category.keys()[plantCategoryId]]
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
        plantPacketContainer.add_child(packet)
        packet.Init(config)
        packet.showLove = true
        packet.loveChange.connect(PlantLoveChange)
        packet.pressed.connect(PlantPacketChoose)

    if plantPacketContainer.get_children().size() > 0:
        PlantPacketChoose(plantPacketContainer.get_children()[0])

@warning_ignore("unused_parameter")
func PlantLoveChange(packet: TowerDefenseInGamePacketShow) -> void :
    InitPlant()

func PlantPacketChoose(packet: TowerDefenseInGamePacketShow) -> void :
    if plantCurrentSelect == packet:
        return
    if plantCurrentSelect:
        plantCurrentSelect.Reset()
    PlantInformationSet(packet)
    plantCurrentSelect = packet

func PlantInformationSet(packet: TowerDefenseInGamePacketShow) -> void :
    var packetConfig: TowerDefensePacketConfig = packet.config
    plantInformationPanel.InitPacket(packetConfig)

func PlantNextButtonPressed() -> void :
    plantCategoryId = (plantCategoryId + 1) %(plantPacketBank.category.size())
    InitPlant()

func PlantPreButtonPressed() -> void :
    plantCategoryId = (plantCategoryId - 1) %(plantPacketBank.category.size())
    InitPlant()

func PlantButtonPressed() -> void :
    plantLayer.visible = true


func InitZombie() -> void :
    var getConfigList: Array = zombiePacketBank.category["Zombie"]










    for configName: String in getConfigList:
        var config: TowerDefensePacketConfig = TowerDefenseManager.GetPacketConfig(configName)


        var packet = ALMANAC_ZOMBIE_WIDOW.instantiate()
        zombiePacketContainer.add_child(packet)
        packet.Init(config)
        packet.pressed.connect(ZombiePacketChoose)

    ZombiePacketChoose(zombiePacketContainer.get_children()[0].config)

func ZombiePacketChoose(config: TowerDefensePacketConfig) -> void :
    ZombieInformationSet(config)

func ZombieInformationSet(config: TowerDefensePacketConfig) -> void :
    zombieInformationPanel.InitPacket(config)

func ZombieButtonPressed() -> void :
    zombieLayer.visible = true




func InitProp() -> void :
    var getShovelConfigList: Array = TowerDefenseManager.GetShovelList()
    for configName: String in getShovelConfigList:
        var config: ShovelConfig = TowerDefenseManager.GetShovel(configName)
        if !config.Unlock():
            continue
        var packet = ALMANAC_PROP_WIDOW.instantiate()
        propShovelContainer.add_child(packet)
        packet.InitShovel(config)
        packet.pressedShovel.connect(PropShovelChoose)

    var getMowerConfigList: Array = TowerDefenseManager.GetMowerList()
    for configName: String in getMowerConfigList:
        var config: MowerConfig = TowerDefenseManager.GetMowerConfig(configName)
        if !config.Unlock():
            continue
        var packet = ALMANAC_PROP_WIDOW.instantiate()
        propMowerContainer.add_child(packet)
        packet.InitMower(config)
        packet.pressedMower.connect(PropMowerChoose)

    if propShovelContainer.get_children().size() > 0:
        PropShovelChoose(propShovelContainer.get_children()[0].shovelConfig)

func PropShovelChoose(config: ShovelConfig) -> void :
    PropShovelInformationSet(config)
    propType = "Shovel"
    propKey = config.saveKey
    var currentProp: String = GameSaveManager.GetKeyValue("CurrentShovel")
    if currentProp != config.saveKey:
        propUseButton.text = "装备道具"
        propUseButton.disable = false
    else:
        propUseButton.text = "已装备"
        propUseButton.disable = true

func PropMowerChoose(config: MowerConfig) -> void :
    PropMowerInformationSet(config)
    propType = "Mower"
    propKey = config.saveKey
    var currentProp: String = GameSaveManager.GetKeyValue("CurrentMower")
    if currentProp != config.saveKey:
        propUseButton.text = "装备道具"
        propUseButton.disable = false
    else:
        propUseButton.text = "已装备"
        propUseButton.disable = true

func PropShovelInformationSet(config: ShovelConfig) -> void :
    propInformationPanel.InitShovel(config)

func PropMowerInformationSet(config: MowerConfig) -> void :
    propInformationPanel.InitMower(config)

func PropUseButtonPressed() -> void :
    match propType:
        "Shovel":
            GameSaveManager.SetKeyValue("CurrentShovel", propKey)
            propUseButton.text = "已装备"
            propUseButton.disable = true
        "Mower":
            GameSaveManager.SetKeyValue("CurrentMower", propKey)
            propUseButton.text = "已装备"
            propUseButton.disable = true

    GameSaveManager.Save()

func PropButtonPressed() -> void :
    propLayer.visible = true


func ButtonPressed() -> void :
    AudioManager.AudioPlay("ButtonPress", AudioManagerEnum.TYPE.SFX)

func IndexButtonPressed() -> void :
    plantLayer.visible = false
    zombieLayer.visible = false
    propLayer.visible = false

func CloseButtonPressed() -> void :
    audio.process_mode = PROCESS_MODE_PAUSABLE
    if !isPlaying:
        if is_instance_valid(audio):
            audio.stop()
    Close()
