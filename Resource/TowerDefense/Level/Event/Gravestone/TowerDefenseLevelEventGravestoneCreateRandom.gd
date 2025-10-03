class_name TowerDefenseLevelEventGravestoneCreateRandom extends TowerDefenseLevelEventBase

@export var gravestoneNames: Array = ["GraveStoneDefault"]
@export var gravestoneNum: int = 5
@export var gravestonePos: Vector4i = Vector4i(3, 1, 9, 5)

func GetName() -> String:
    return "LEVLE_EVENT_GRAVESTONE_CREATE_RANDOM"

func Execute() -> void :
    if gravestonePos == Vector4i(-1, -1, -1, -1):
        return
    var canSpawnPos: Array[Vector2i] = []
    for x in range(gravestonePos.x, gravestonePos.z + 1):
        for y in range(gravestonePos.y, gravestonePos.w + 1):
            var gridPos: Vector2i = Vector2i(x, y)
            var cell: TowerDefenseCellInstance = TowerDefenseManager.GetMapCell(gridPos)
            var canSpawnFlag = true
            for gravestoneName: String in gravestoneNames:
                var packet: TowerDefensePacketConfig = TowerDefenseManager.GetPacketConfig(gravestoneName)
                if !cell.CanPacketPlant(packet):
                    canSpawnFlag = false
                    break
            if canSpawnFlag:
                canSpawnPos.append(gridPos)

    var num: int = min(canSpawnPos.size(), gravestoneNum)
    while (num > 0):
        var packet: TowerDefensePacketConfig = TowerDefenseManager.GetPacketConfig(gravestoneNames.pick_random())
        var gridPos: Vector2i = canSpawnPos.pick_random()
        var cell: TowerDefenseCellInstance = TowerDefenseManager.GetMapCell(gridPos)
        if cell.CanPacketPlant(packet):
            packet.Plant(gridPos, false)
        canSpawnPos.erase(gridPos)
        num -= 1

func Init(valueDictionary: Dictionary) -> void :
    gravestoneNames = valueDictionary.get("GravestoneNames", [])
    gravestoneNum = valueDictionary.get("GravestoneNum", 1)
    var posData: Dictionary = valueDictionary.get("GravestonePos", {})
    gravestonePos = Vector4i(posData.get("x", -1), posData.get("y", -1), posData.get("z", -1), posData.get("w", -1))

func Export() -> Dictionary:
    return {
        "EventName": "GravestoneCreateRandom", 
        "Value": {
            "GravestoneNames": gravestoneNames, 
            "GravestoneNum": gravestoneNum, 
            "GravestonePos": {
                "x": gravestonePos.x, 
                "y": gravestonePos.y, 
                "z": gravestonePos.z, 
                "w": gravestonePos.w
            }
        }
    }

func GetProperty() -> Dictionary:
    var data = super .GetProperty()
    data["随机创建墓碑"] = {
        "数量": {
            "Object": self, 
            "Type": "Int", 
            "Property": "gravestoneNum", 
            "Rest": 5
        }, 
        "范围": {
            "Object": self, 
            "Type": "Vector4i", 
            "Property": "gravestonePos", 
            "Rest": Vector4i(3, 1, 9, 5)
        }
    }
    return data
