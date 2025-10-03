class_name TowerDefenseConveyorBelt extends Control

const num: int = 16

@onready var pcControl: Control = %PCControl
@onready var mobileControl: Control = %MobileControl

@onready var packetContainer: Control = %PacketContainer
@onready var belt: TextureRect = %Belt

@onready var mobileBelt1: Sprite2D = %MobileBelt1
@onready var mobilePacketContainer1: Control = %MobilePacketContainer1
@onready var mobileBelt2: Sprite2D = %MobileBelt2
@onready var mobilePacketContainer2: Control = %MobilePacketContainer2

var packetList: Array[TowerDefenseConveyorPacketConfig] = []
var config: TowerDefenseConveyorConfig

var running: bool = false
var timer: float = 0.0

var beltTime: float = 0.0

var isMobileUI: bool = false

func MobilePreset() -> void :
    pcControl.queue_free()
    mobileControl.visible = true

func Init(_config: TowerDefenseConveyorConfig) -> void :
    config = _config
    packetList = config.packetList.duplicate(true)

func _ready() -> void :
    isMobileUI = GameSaveManager.GetConfigValue("MobilePreset")
    if isMobileUI:
        MobilePreset()
    else:
        mobileControl.queue_free()
    await get_tree().create_timer(0.1, false).timeout
    TowerDefenseInGameWaveManager.instance.bigWaveBegin.connect(WaveEventExecute)

func _physics_process(delta: float) -> void :
    if !visible || !running:
        return
    timer += delta
    if TowerDefenseManager.currentControl.isGameRunning:
        beltTime += delta
    var packetNum: int
    if !isMobileUI:
        packetNum = packetContainer.get_child_count()
        belt.material.set_shader_parameter("time", beltTime)
        for id in packetNum:
            var packet: TowerDefenseInGamePacketShow = packetContainer.get_child(id)
            var targetPos: Vector2 = GetPacketPos(id)
            if packet.position.x > targetPos.x:
                packet.position.x -= delta * 50.0
            else:
                packet.position.x = targetPos.x
    else:
        mobileBelt1.material.set_shader_parameter("time", beltTime)
        mobileBelt2.material.set_shader_parameter("time", beltTime)
        packetNum = mobilePacketContainer1.get_child_count() + mobilePacketContainer2.get_child_count()
        for id in mobilePacketContainer1.get_child_count():
            var packet: TowerDefenseInGamePacketShow = mobilePacketContainer1.get_child(id)
            var targetPos: Vector2 = mobilePacketContainer1.position + Vector2(0, 61 * id)
            if packet.position.y > targetPos.y:
                packet.position.y -= delta * 50.0
            else:
                packet.position.y = targetPos.y
        for id in mobilePacketContainer2.get_child_count():
            var packet: TowerDefenseInGamePacketShow = mobilePacketContainer2.get_child(id)
            var targetPos: Vector2 = mobilePacketContainer2.position + Vector2(0, 61 * id)
            if packet.position.y > targetPos.y:
                packet.position.y -= delta * 50.0
            else:
                packet.position.y = targetPos.y

    var spawnTime: float = config.interval * (1.0 + float(floor(float(packetNum) / float(config.intervalIncreaseEvery))) * config.intervalMagnification)
    if timer > spawnTime && packetNum < 14:
        Spawn()
        timer = 0.0

@warning_ignore("unused_parameter")
func WaveEventExecute(bigWaveId: int) -> void :
    if !visible || !running:
        return
    if config.waveEvent.size() <= bigWaveId:
        return
    for event: TowerDefenseConveyorEventBase in config.waveEvent[bigWaveId]:
        event.Execute()

func Spawn() -> TowerDefenseInGamePacketShow:
    var weightPickItemList: Array[WeightPickItemBase] = []
    for packetConfig: TowerDefenseConveyorPacketConfig in packetList:
        var weight: float = packetConfig.weight
        var charcaterNum: int = TowerDefenseManager.GetCharacterNum(packetConfig.name, true)
        if packetConfig.maxNum != -1:
            if charcaterNum >= packetConfig.maxNum:
                weight *= packetConfig.maxMagnification
        if packetConfig.minNum != -1:
            if charcaterNum < packetConfig.minNum:
                weight *= packetConfig.minMagnification
        weightPickItemList.append(WeightPickItemBase.new(packetConfig, int(weight)))
    var pickPacketConfig: WeightPickItemBase = WeightPickMathine.Pick(weightPickItemList)
    var packetConfigGet = TowerDefenseManager.GetPacketConfig(pickPacketConfig.item.name)
    var packet: TowerDefenseInGamePacketShow = TowerDefenseManager.CreatePacketShow()

    if isMobileUI:
        packet.position = Vector2(0.0, 680.0)
        if mobilePacketContainer1.get_child_count() <= mobilePacketContainer2.get_child_count():
            mobilePacketContainer1.add_child(packet)
        else:
            mobilePacketContainer2.add_child(packet)
    else:
        packet.position = Vector2(868.0, 0.0)
        packetContainer.add_child(packet)
    packet.Init(packetConfigGet)
    packet.onlyDraw = false
    packet.showCost = false
    packet.plantOnce = true
    packet.StartInit()
    packet.alive = true

    var seedBank: TowerDefenseInGameSeedBank = TowerDefenseManager.GetSeedBank()
    packet.pressed.connect(seedBank.PickPacket)

    return packet

func GetPacketPos(id: int) -> Vector2:
    return packetContainer.position + Vector2(53.0 * id, 0)
