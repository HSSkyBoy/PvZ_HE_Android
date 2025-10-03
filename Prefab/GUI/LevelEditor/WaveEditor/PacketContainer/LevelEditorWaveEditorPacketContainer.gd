class_name LevelEditorWaveEditorPacketContainer extends HBoxContainer

@onready var mainButton: MainButton = %MainButton

@onready var scrollContainer: ScrollContainer = %ScrollContainer


@onready var packetSlotContainer: HBoxContainer = %PacketSlotContainer
@onready var packetContainer: HBoxContainer = %PacketContainer

signal selected(packetContainer: LevelEditorWaveEditorPacketContainer)

var packetNum: int = 0

var packetList: Array[TowerDefenseInGamePacketShow] = []

func Clear() -> void :
    for packet in packetList:
        packet.queue_free()
    packetList.clear()
    packetNum = 0

func CanAddPacket() -> bool:
    return packetNum < 50

func GetPacketPos(id: int) -> Vector2:
    return packetSlotContainer.get_child(id).global_position

func AddPacket(_packetConfig) -> TowerDefenseInGamePacketShow:
    packetNum += 1
    var packet: TowerDefenseInGamePacketShow = TowerDefenseManager.CreatePacketShow()
    packetContainer.add_child(packet)
    packet.Init(_packetConfig)
    packet.onlyDraw = false
    packet.pressed.connect(DeletePacket)
    packetList.append(packet)
    return packet

func DeletePacket(_packet: TowerDefenseInGamePacketShow) -> void :
    LevelEditorWaveEditor.instance.levelConfig.canExport = false
    var id: int = packetList.find(_packet)
    packetList.remove_at(id)
    _packet.queue_free()
    packetNum -= 1

func Selected() -> void :
    selected.emit(self)
