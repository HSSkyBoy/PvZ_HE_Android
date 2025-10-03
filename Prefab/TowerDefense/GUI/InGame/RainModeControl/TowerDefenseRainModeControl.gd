class_name TowerDefenseRainModeControl extends Control

var config: TowerDefenseRainModeConfig
var packetList: Array = []

var running: bool = false
var timer: float = 0.0

func Init(_config: TowerDefenseRainModeConfig) -> void :
    config = _config
    packetList = config.packetList.duplicate(true)

func _physics_process(delta: float) -> void :
    if !visible || !running:
        return
    timer += delta

    var spawnTime: float = config.interval
    if timer > spawnTime:
        Spawn()
        timer = 0.0

func Spawn() -> TowerDefenseInGamePacketShow:
    var posX: float = randf_range(TowerDefenseManager.GetMapGridBeginPos().x, TowerDefenseManager.GetMapGroundRight())
    var height: float = randf_range(TowerDefenseManager.GetMapGridBeginPos().y + 200, TowerDefenseManager.GetMapGroundDown() - TowerDefenseManager.GetMapGridBeginPos().y)
    var characterNode: Node2D = TowerDefenseManager.GetCharacterNode()
    var weightPickItemList: Array[WeightPickItemBase] = []
    for packetConfig: TowerDefenseRainModePacketConfig in packetList:
        var weight: float = packetConfig.weight
        var charcaterNum: int = TowerDefenseManager.GetCharacterNum(packetConfig.name)
        if packetConfig.maxNum != -1:
            if charcaterNum >= packetConfig.maxNum:
                weight *= packetConfig.maxMagnification
        if packetConfig.minNum != -1:
            if charcaterNum < packetConfig.minNum:
                weight *= packetConfig.minMagnification
        weightPickItemList.append(WeightPickItemBase.new(packetConfig, int(weight)))
    var pickPacketConfig: WeightPickItemBase = WeightPickMathine.Pick(weightPickItemList)
    var packetConfigGet = pickPacketConfig.item.GetPacket()
    var packet: TowerDefenseInGamePacketShow = TowerDefenseManager.CreatePacketShow()
    packet.z_index = 990
    packet.global_position = Vector2(posX, TowerDefenseManager.GetMapGridBeginPos().y - 100)
    characterNode.add_child(packet)
    packet.Init(packetConfigGet)
    packet.onlyDraw = false
    packet.showCost = false
    packet.useCost = false
    packet.plantOnce = true
    packet.StartInit()
    packet.alive = true
    packet.aliveTime = config.aliveTime
    var tween = packet.create_tween()
    tween.tween_property(packet, ^"global_position:y", height, (height - global_position.y) / 25.0)
    var seedBank: TowerDefenseInGameSeedBank = TowerDefenseManager.GetSeedBank()
    packet.pressed.connect(seedBank.PickPacket)

    return packet
