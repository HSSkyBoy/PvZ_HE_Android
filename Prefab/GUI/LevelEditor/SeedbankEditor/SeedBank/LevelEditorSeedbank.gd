class_name LevelEditorSeedbank extends Control

@onready var posMask: Control = %PosMask

@onready var sunLabel: Label = %SunLabel
@onready var seedContanin: MarginContainer = %SeedContanin
@onready var conveyor: Control = %Conveyor

@onready var packetSlotContainer: HBoxContainer = %PacketSlotContainer
@onready var packetContainer: HBoxContainer = %PacketContainer

static  var instance: LevelEditorSeedbank

var packetNum: int = 0

var packetList: Array[TowerDefenseInGamePacketShow] = []

func _ready() -> void :
    instance = self

func Clear() -> void :
    for packet in packetList:
        packet.queue_free()
    packetList.clear()
    packetNum = 0

func CanAddPacket() -> bool:
    return packetNum < 16

func GetPacketPos(id: int) -> Vector2:
    return posMask.global_position + Vector2(51 * id, 0)

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
    LevelEditorSeedbankEditor.instance.levelConfig.canExport = false
    var id: int = packetList.find(_packet)
    packetList.remove_at(id)
    _packet.queue_free()
    packetNum -= 1
