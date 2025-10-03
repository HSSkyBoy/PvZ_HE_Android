class_name LevelEditorSeedbankEditor extends Control

@onready var plantColumnCheckBox: CheckBox = %PlantColumnCheckBox

@onready var sunContainer: VBoxContainer = %SunContainer
@onready var sunManagerContainer: VBoxContainer = %SunManagerContainer
@onready var conveyorContainer: VBoxContainer = %ConveyorContainer
@onready var packetColdDownStartContainer: HBoxContainer = %PacketColdDownStartContainer
@onready var rainModeContainer: VBoxContainer = %RainModeContainer

@onready var methodOptionButton: OptionButton = %MethodOptionButton
@onready var sunSpinBox: SpinBox = %SunSpinBox
@onready var sunUseCheckBox: CheckBox = %SunUseCheckBox
@onready var sunSpawnIntervalSpinBox: SpinBox = %SunSpawnIntervalSpinBox
@onready var sunSpawnNumSpinBox: SpinBox = %SunSpawnNumSpinBox
@onready var conveyorIntervalSpinBox: SpinBox = %ConveyorIntervalSpinBox
@onready var packetColdDownStartUseCheckBox: CheckBox = %PacketColdDownStartUseCheckBox

@onready var rainModeIntervalSpinBox: SpinBox = %RainModeIntervalSpinBox
@onready var rainModeAliveTimeSpinBox: SpinBox = %RainModeAliveTimeSpinBox

static  var instance: LevelEditorSeedbankEditor

@export var levelConfig: TowerDefenseLevelConfig

var isInit: bool = false

const methodTranslate: Dictionary = {
    TowerDefenseEnum.LEVEL_SEEDBANK_METHOD.NOONE: "无", 
    TowerDefenseEnum.LEVEL_SEEDBANK_METHOD.CHOOSE: "选卡模式", 
    TowerDefenseEnum.LEVEL_SEEDBANK_METHOD.PRESET: "预选卡模式", 
    TowerDefenseEnum.LEVEL_SEEDBANK_METHOD.CONVEYOR: "传送带模式", 
    TowerDefenseEnum.LEVEL_SEEDBANK_METHOD.RAIN: "种子雨模式"
}
const methodDictionary: Dictionary = {
    "无": TowerDefenseEnum.LEVEL_SEEDBANK_METHOD.NOONE, 
    "选卡模式": TowerDefenseEnum.LEVEL_SEEDBANK_METHOD.CHOOSE, 
    "预选卡模式": TowerDefenseEnum.LEVEL_SEEDBANK_METHOD.PRESET, 
    "传送带模式": TowerDefenseEnum.LEVEL_SEEDBANK_METHOD.CONVEYOR, 
    "种子雨模式": TowerDefenseEnum.LEVEL_SEEDBANK_METHOD.RAIN
}

func Init(_levelConfig: TowerDefenseLevelConfig) -> void :
    isInit = true
    Clear()

    levelConfig = _levelConfig

    plantColumnCheckBox.button_pressed = levelConfig.plantColumn

    methodOptionButton.selected = FindOptionButtonId(methodOptionButton, methodTranslate[levelConfig.packetBankMethod])
    MethodOptionButtonItemSelected(methodOptionButton.selected)

    if !is_instance_valid(levelConfig.conveyorData):
        levelConfig.conveyorData = TowerDefenseConveyorConfig.new()
    else:
        levelConfig.conveyorData = levelConfig.conveyorData.duplicate(true)
    conveyorIntervalSpinBox.value = levelConfig.conveyorData.interval

    if !is_instance_valid(levelConfig.rainData):
        levelConfig.rainData = TowerDefenseRainModeConfig.new()
    else:
        levelConfig.rainData = levelConfig.rainData.duplicate(true)
    rainModeIntervalSpinBox.value = levelConfig.rainData.interval
    rainModeAliveTimeSpinBox.value = levelConfig.rainData.aliveTime

    if !is_instance_valid(levelConfig.sunManager):
        levelConfig.sunManager = TowerDefenseLevelSunManagerConfig.new()
    else:
        levelConfig.sunManager = levelConfig.sunManager.duplicate(true)
    sunSpinBox.value = levelConfig.sunManager.begin
    SunSpinBoxValueChanged(sunSpinBox.value)
    sunUseCheckBox.button_pressed = levelConfig.sunManager.open
    sunSpawnIntervalSpinBox.value = levelConfig.sunManager.spawnInterval
    sunSpawnNumSpinBox.value = levelConfig.sunManager.spawnNum
    packetColdDownStartUseCheckBox.button_pressed = levelConfig.packetColdDownStart

    match levelConfig.packetBankMethod:
        TowerDefenseEnum.LEVEL_SEEDBANK_METHOD.CHOOSE, TowerDefenseEnum.LEVEL_SEEDBANK_METHOD.PRESET:
            LevelEditorSeedBankChoose.instance.PacketListChoose(levelConfig.packetBankList)
        TowerDefenseEnum.LEVEL_SEEDBANK_METHOD.CONVEYOR:
            for packet: TowerDefenseConveyorPacketConfig in levelConfig.conveyorData.packetList:
                LevelEditorSeedBankChoose.instance.PacketNameChoose(packet.name)
        TowerDefenseEnum.LEVEL_SEEDBANK_METHOD.RAIN:
            for packet: TowerDefenseRainModePacketConfig in levelConfig.rainData.packetList:
                LevelEditorSeedBankChoose.instance.PacketNameChoose(packet.name)
    isInit = false

func Save() -> void :
    if !is_instance_valid(levelConfig):
        return

    levelConfig.plantColumn = plantColumnCheckBox.button_pressed

    levelConfig.conveyorData.interval = conveyorIntervalSpinBox.value

    levelConfig.rainData.interval = rainModeIntervalSpinBox.value
    levelConfig.rainData.aliveTime = rainModeAliveTimeSpinBox.value

    levelConfig.sunManager.begin = int(sunSpinBox.value)
    levelConfig.sunManager.open = sunUseCheckBox.button_pressed
    levelConfig.sunManager.spawnInterval = sunSpawnIntervalSpinBox.value
    levelConfig.sunManager.spawnNum = int(sunSpawnNumSpinBox.value)

    levelConfig.packetColdDownStart = packetColdDownStartUseCheckBox.button_pressed

    match levelConfig.packetBankMethod:
        TowerDefenseEnum.LEVEL_SEEDBANK_METHOD.CHOOSE, TowerDefenseEnum.LEVEL_SEEDBANK_METHOD.PRESET:
            levelConfig.packetBankList.clear()
            for packet: TowerDefenseInGamePacketShow in LevelEditorSeedbank.instance.packetList:
                var config: TowerDefenseLevelPacketConfig = TowerDefenseLevelPacketConfig.new()
                config.packetName = packet.config.saveKey
                levelConfig.packetBankList.append(config)
        TowerDefenseEnum.LEVEL_SEEDBANK_METHOD.CONVEYOR:
            levelConfig.conveyorData.packetList.clear()
            for packet: TowerDefenseInGamePacketShow in LevelEditorSeedbank.instance.packetList:
                var config: TowerDefenseConveyorPacketConfig = TowerDefenseConveyorPacketConfig.new()
                config.name = packet.config.saveKey
                levelConfig.conveyorData.packetList.append(config)
        TowerDefenseEnum.LEVEL_SEEDBANK_METHOD.RAIN:
            levelConfig.rainData.packetList.clear()
            for packet: TowerDefenseInGamePacketShow in LevelEditorSeedbank.instance.packetList:
                var config: TowerDefenseRainModePacketConfig = TowerDefenseRainModePacketConfig.new()
                config.name = packet.config.saveKey
                levelConfig.rainData.packetList.append(config)

func Clear() -> void :
    LevelEditorSeedbank.instance.Clear()
    levelConfig = null

func _ready() -> void :
    instance = self

    for method in TowerDefenseEnum.LEVEL_SEEDBANK_METHOD.values():
        methodOptionButton.add_item(methodTranslate[method])

func FindOptionButtonId(optionButton: OptionButton, key: String) -> int:
    for index in optionButton.item_count:
        if optionButton.get_item_text(index) == key:
            return optionButton.get_item_id(index)
    return -1

func MethodOptionButtonItemSelected(index: int) -> void :
    if !isInit:
        levelConfig.canExport = false
    var methodName: String = methodOptionButton.get_item_text(index)
    levelConfig.packetBankMethod = methodDictionary[methodName]
    LevelEditorSeedbank.instance.seedContanin.visible = false
    LevelEditorSeedbank.instance.conveyor.visible = false
    LevelEditorSeedbank.instance.packetContainer.visible = false
    packetColdDownStartContainer.visible = false
    sunContainer.visible = false
    conveyorContainer.visible = false
    rainModeContainer.visible = false
    match levelConfig.packetBankMethod:
        TowerDefenseEnum.LEVEL_SEEDBANK_METHOD.NOONE:
            packetColdDownStartContainer.visible = true
            sunContainer.visible = true
            LevelEditorSeedBankChoose.instance.visible = false
        TowerDefenseEnum.LEVEL_SEEDBANK_METHOD.CHOOSE, TowerDefenseEnum.LEVEL_SEEDBANK_METHOD.PRESET:
            LevelEditorSeedbank.instance.seedContanin.visible = true
            LevelEditorSeedbank.instance.packetContainer.visible = true
            packetColdDownStartContainer.visible = true
            sunContainer.visible = true
            LevelEditorSeedBankChoose.instance.visible = true
        TowerDefenseEnum.LEVEL_SEEDBANK_METHOD.CONVEYOR:
            sunUseCheckBox.button_pressed = false
            LevelEditorSeedbank.instance.conveyor.visible = true
            LevelEditorSeedbank.instance.packetContainer.visible = true
            conveyorContainer.visible = true
            LevelEditorSeedBankChoose.instance.visible = true
        TowerDefenseEnum.LEVEL_SEEDBANK_METHOD.RAIN:
            sunUseCheckBox.button_pressed = false
            LevelEditorSeedbank.instance.seedContanin.visible = true
            LevelEditorSeedbank.instance.packetContainer.visible = true
            rainModeContainer.visible = true
            LevelEditorSeedBankChoose.instance.visible = true

func SunUseCheckBoxToggled(toggledOn: bool) -> void :
    if !isInit:
        levelConfig.canExport = false
    sunManagerContainer.visible = toggledOn

func SunSpinBoxValueChanged(value: float) -> void :
    if !isInit:
        levelConfig.canExport = false
    LevelEditorSeedbank.instance.sunLabel.text = str(int(value))

func PacketColdDownStartUseCheckBoxPressed() -> void :
    if !isInit:
        levelConfig.canExport = false

@warning_ignore("unused_parameter")
func SunSpawnIntervalSpinBoxValueChanged(value: float) -> void :
    if !isInit:
        levelConfig.canExport = false

@warning_ignore("unused_parameter")
func SunSpawnNumSpinBoxValueChanged(value: float) -> void :
    if !isInit:
        levelConfig.canExport = false

@warning_ignore("unused_parameter")
func RainModeIntervalSpinBoxValueChanged(value: float) -> void :
    if !isInit:
        levelConfig.canExport = false

@warning_ignore("unused_parameter")
func RainModeAliveTimeSpinBoxValueChanged(value: float) -> void :
    if !isInit:
        levelConfig.canExport = false

@warning_ignore("unused_parameter")
func PlantColumnCheckBoxToggled(toggled_on: bool) -> void :
    if !isInit:
        levelConfig.canExport = false
