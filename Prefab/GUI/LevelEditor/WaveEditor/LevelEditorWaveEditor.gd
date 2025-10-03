class_name LevelEditorWaveEditor extends Control

const LEVEL_EDITOR_WAVE_EDITOR_PACKET_CONTAINER = preload("uid://bua2w8mprv7s")

@onready var spawnNode: Control = %SpawnNode
@onready var eventNode: Control = %EventNode

@onready var poolPacketContainer: LevelEditorWaveEditorPacketContainer = %PoolPacketContainer
@onready var randomPacketContainer: LevelEditorWaveEditorPacketContainer = %RandomPacketContainer
@onready var packetContainerListContainer: VBoxContainer = %PacketContainerListContainer

@onready var eventListContainer: ScrollContainer = %EventListContainer

@onready var bigWaveSpinBox: SpinBox = %BigWaveSpinBox
@onready var waveIntervalSpinBox: SpinBox = %WaveIntervalSpinBox
@onready var beginColSpinBox: SpinBox = %BeginColSpinBox
@onready var spawnColEndSpinBox: SpinBox = %SpawnColEndSpinBox
@onready var spawnColStartSpinBox: SpinBox = %SpawnColStartSpinBox
@onready var minNextWaveHealthPercentageSpinBox: SpinBox = %MinNextWaveHealthPercentageSpinBox
@onready var maxNextWaveHealthPercentageSpinBox: SpinBox = %MaxNextWaveHealthPercentageSpinBox

@onready var tipsLabel: Label = %TipsLabel

@onready var flagSlider: HSlider = %FlagSlider
@onready var waveLabel: Label = %WaveLabel

@onready var levelEditorInspector: MapEditorInspector = %LevelEditorInspector

static  var instance: LevelEditorWaveEditor

@export var levelConfig: TowerDefenseLevelConfig

var waveManagerConfig: TowerDefenseLevelWaveManagerConfig

var isInit: bool = false

var currentFlag: int = -1:
    set(_currentFlag):
        if currentFlag != -1 && _currentFlag != -1:
            SaveFlag(currentFlag)
        currentFlag = _currentFlag

var currentPacketContainer: LevelEditorWaveEditorPacketContainer

func _ready() -> void :
    poolPacketContainer.selected.connect(Selected)
    randomPacketContainer.mainButton.text = "编辑随机出怪"
    randomPacketContainer.selected.connect(Selected)
    for i in 25:
        var packetContainer: LevelEditorWaveEditorPacketContainer = packetContainerListContainer.get_child(i) as LevelEditorWaveEditorPacketContainer
        packetContainer.mainButton.text = "编辑第%d行" % (i + 1)
        packetContainer.selected.connect(Selected)
    currentPacketContainer = null
    instance = self

func Clear() -> void :
    levelConfig = null
    waveManagerConfig = null
    ClearPanel()

func ClearPanel() -> void :
    poolPacketContainer.Clear()
    randomPacketContainer.Clear()
    eventListContainer.Clear()
    for i in 25:
        var packetContainer: LevelEditorWaveEditorPacketContainer = packetContainerListContainer.get_child(i) as LevelEditorWaveEditorPacketContainer
        packetContainer.Clear()

func Init(_levelConfig: TowerDefenseLevelConfig) -> void :
    isInit = true
    Clear()
    currentFlag = -1
    levelConfig = _levelConfig
    if !is_instance_valid(levelConfig.waveManager):
        waveManagerConfig = TowerDefenseLevelWaveManagerConfig.new()
        for i in waveManagerConfig.flagWaveInterval:
            var wave: TowerDefenseLevelWaveConfig = TowerDefenseLevelWaveConfig.new()
            waveManagerConfig.wave.append(wave)
    else:
        waveManagerConfig = levelConfig.waveManager.duplicate(true)
    bigWaveSpinBox.value = float(waveManagerConfig.wave.size()) / float(waveManagerConfig.flagWaveInterval)
    waveIntervalSpinBox.value = waveManagerConfig.flagWaveInterval
    beginColSpinBox.value = waveManagerConfig.beginCol
    spawnColEndSpinBox.value = waveManagerConfig.spawnColEnd
    spawnColStartSpinBox.value = waveManagerConfig.spawnColStart
    minNextWaveHealthPercentageSpinBox.value = waveManagerConfig.minNextWaveHealthPercentage
    maxNextWaveHealthPercentageSpinBox.value = waveManagerConfig.maxNextWaveHealthPercentage
    WaveNumChange()
    isInit = false

func Save() -> void :
    SaveFlag(currentFlag)
    waveManagerConfig.flagWaveInterval = int(waveIntervalSpinBox.value)
    waveManagerConfig.beginCol = beginColSpinBox.value
    waveManagerConfig.spawnColEnd = spawnColEndSpinBox.value
    waveManagerConfig.spawnColStart = spawnColStartSpinBox.value
    waveManagerConfig.minNextWaveHealthPercentage = minNextWaveHealthPercentageSpinBox.value
    waveManagerConfig.maxNextWaveHealthPercentage = maxNextWaveHealthPercentageSpinBox.value
    var waveList: Array[TowerDefenseLevelWaveConfig] = []
    for i in waveIntervalSpinBox.value * bigWaveSpinBox.value:
        waveList.append(waveManagerConfig.wave[i])
    waveManagerConfig.wave = waveList
    levelConfig.waveManager = waveManagerConfig

func SaveFlag(flagId: int) -> void :
    if currentFlag == -1:
        return
    var waveConfig: TowerDefenseLevelWaveConfig = waveManagerConfig.wave[flagId]
    waveConfig.spawn.clear()
    waveConfig.dynamic = TowerDefenseLevelSpawnDynamicConfig.new()
    for packet in poolPacketContainer.packetList:
        var packetName: String = packet.config.saveKey
        var point: int = packet.config.characterConfig.wavePointCost
        if packet.config.overrideWavePointCost != -1:
            point = packet.config.overrideWavePointCost
        waveConfig.dynamic.points += point
        waveConfig.dynamic.zombiePool.append(packetName)
    for packet in randomPacketContainer.packetList:
        var packetName: String = packet.config.saveKey
        var spawnConfig: TowerDefenseLevelSpawnConfig = TowerDefenseLevelSpawnConfig.new()
        spawnConfig.zombie = packetName
        spawnConfig.line = -1
        spawnConfig.num = 1
        waveConfig.spawn.append(spawnConfig)
    for i in 25:
        var packetContainer: LevelEditorWaveEditorPacketContainer = packetContainerListContainer.get_child(i) as LevelEditorWaveEditorPacketContainer
        if !packetContainer.visible:
            continue
        for packet in packetContainer.packetList:
            var packetName: String = packet.config.saveKey
            var spawnConfig: TowerDefenseLevelSpawnConfig = TowerDefenseLevelSpawnConfig.new()
            spawnConfig.zombie = packetName
            spawnConfig.line = i + 1
            spawnConfig.num = 1
            waveConfig.spawn.append(spawnConfig)
    waveConfig.event = eventListContainer.GetEventList()
    levelEditorInspector.Clear()

func MapChange(_config: TowerDefenseMapConfig) -> void :
    for i in 25:
        var packetContainer: LevelEditorWaveEditorPacketContainer = packetContainerListContainer.get_child(i)
        packetContainer.visible = i < _config.gridNum.y

func FlagChanged(isChange: bool) -> void :
    if !is_instance_valid(waveManagerConfig):
        return
    if !isChange:
        return
    var flagId = int(flagSlider.value)
    currentFlag = flagId
    waveLabel.text = "当前波:%d" % (currentFlag + 1)
    ClearPanel()
    var waveConfig: TowerDefenseLevelWaveConfig = waveManagerConfig.wave[currentFlag]
    for packetName in waveConfig.dynamic.zombiePool:
        var packet: TowerDefensePacketConfig = TowerDefenseManager.GetPacketConfig(packetName)
        poolPacketContainer.AddPacket(packet)
    for spawnConfig: TowerDefenseLevelSpawnConfig in waveConfig.spawn:
        var zombieName: String = spawnConfig.zombie
        var packetContainer: LevelEditorWaveEditorPacketContainer
        if spawnConfig.line == -1:
            packetContainer = randomPacketContainer
        else:
            packetContainer = packetContainerListContainer.get_child(spawnConfig.line - 1) as LevelEditorWaveEditorPacketContainer
        var packet: TowerDefensePacketConfig = TowerDefenseManager.GetPacketConfig(zombieName)
        for i in spawnConfig.num:
            packetContainer.AddPacket(packet)
    eventListContainer.Init(waveConfig.event)

@warning_ignore("unused_parameter")
func BigWaveSpinBoxValueChanged(value: float) -> void :
    if !isInit:
        levelConfig.canExport = false
    WaveNumChange()

@warning_ignore("unused_parameter")
func WaveIntervalSpinBoxValueChanged(value: float) -> void :
    if !isInit:
        levelConfig.canExport = false
    WaveNumChange()

func WaveNumChange() -> void :
    for i in waveIntervalSpinBox.value * bigWaveSpinBox.value:
        if waveManagerConfig.wave.size() <= i:
            var wave: TowerDefenseLevelWaveConfig = TowerDefenseLevelWaveConfig.new()
            waveManagerConfig.wave.append(wave)
    flagSlider.max_value = waveIntervalSpinBox.value * bigWaveSpinBox.value - 1
    flagSlider.tick_count = int(bigWaveSpinBox.value) + 1
    flagSlider.value = 0.0
    FlagChanged(true)

func Selected(packetContainer: LevelEditorWaveEditorPacketContainer) -> void :
    currentPacketContainer = packetContainer
    tipsLabel.modulate = Color.WHITE
    tipsLabel.text = "当前%s" % currentPacketContainer.mainButton.text


func SpawnButtonPressed() -> void :
    spawnNode.visible = true
    eventNode.visible = false

func EventButtonPressed() -> void :
    spawnNode.visible = false
    eventNode.visible = true


@warning_ignore("unused_parameter")
func BeginColSpinBoxValueChanged(value: float) -> void :
    if !isInit:
        levelConfig.canExport = false


@warning_ignore("unused_parameter")
func SpawnColEndSpinBoxValueChanged(value: float) -> void :
    if !isInit:
        levelConfig.canExport = false


@warning_ignore("unused_parameter")
func SpawnColStartSpinBoxValueChanged(value: float) -> void :
    if !isInit:
        levelConfig.canExport = false


@warning_ignore("unused_parameter")
func MinNextWaveHealthPercentageSpinBoxValueChanged(value: float) -> void :
    if !isInit:
        levelConfig.canExport = false


@warning_ignore("unused_parameter")
func MaxNextWaveHealthPercentageSpinBoxValueChanged(value: float) -> void :
    if !isInit:
        levelConfig.canExport = false


func EventListContainerChange() -> void :
    if !isInit:
        levelConfig.canExport = false
