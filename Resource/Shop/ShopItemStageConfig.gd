@tool
class_name ShopItemStageConfig extends Resource

@export_group("Base")
@export_enum("Feature", "TowerDefensePacket") var saveType: String = "Feature"
@export var saveKey: String = ""
@export var texture: Texture2D
@export var describe: String
@export var npcTalk: String
@export_group("Init")
@export_enum("Coin") var type: String = "Coin"
@export var cost: int = 0
@export var openMinNum: int = 0
@export var openMaxNum: int = 1
@export var addNum: int = 1

func Init(data: Dictionary) -> void :
    saveType = data.get("SaveType", "Feature")
    saveKey = data.get("SaveKey", "")
    var textureGet = data.get("Texture", "")
    if textureGet != "":
        texture = load(textureGet)
    describe = data.get("Describe", "")
    npcTalk = data.get("NpcTalk", "")

    cost = data.get("Cost", 0)
    openMinNum = data.get("OpenMinNum", 0)
    openMaxNum = data.get("OpenMaxNum", 1)
    addNum = data.get("AddNum", 1)
