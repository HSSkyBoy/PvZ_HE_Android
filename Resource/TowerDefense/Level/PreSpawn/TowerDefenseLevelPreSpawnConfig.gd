class_name TowerDefenseLevelPreSpawnConfig extends Resource

@export var packetName: String
@export var gridPos: Vector2i

func Init(spawnDictionary: Dictionary):
    packetName = spawnDictionary.get_or_add("Name", null)
    var gridPosGet = spawnDictionary.get_or_add("GridPos", Vector2i.ZERO)
    gridPos = Vector2i(gridPosGet[0], gridPosGet[1])

func Spawn() -> TowerDefenseCharacter:
    var packet: TowerDefensePacketConfig = TowerDefenseManager.GetPacketConfig(packetName)
    return packet.Plant(gridPos, false, true)

func Export() -> Dictionary:
    return {
        "Name": packetName, 
        "GridPos": [gridPos.x, gridPos.y]
    }
