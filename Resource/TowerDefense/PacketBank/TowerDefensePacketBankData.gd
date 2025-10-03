class_name TowerDefensePacketBankData extends Resource

@export var category: Dictionary

func GetUnlockPacket() -> Array[String]:
    var packetList: Array[String] = []
    for configList: Array in category.values():
        for configName: String in configList:
            var config: TowerDefensePacketConfig = TowerDefenseManager.GetPacketConfig(configName)
            if config.Unlock():
                packetList.append(configName)
    return packetList

func GetCategory(_category: String) -> Array:
    if category.has(_category):
        return category[_category]
    return []

func GetPacketList() -> Array:
    var packetList: Array = []
    for categoryName: String in category.keys():
        packetList.append_array(category[categoryName])
    return packetList

func GetPlantList() -> Array:
    var plantList: Array = []
    for categoryName: String in category.keys():
        match categoryName:
            "White", "Gold", "Diamond", "Colour", "Star", "Original":
                plantList.append_array(category[categoryName])
    plantList.erase("PlantPresentBox")
    return plantList

func GetZombieList() -> Array:
    var zombieList: Array = []
    for categoryName: String in category.keys():
        match categoryName:
            "Zombie":
                zombieList.append_array(category[categoryName])
    return zombieList
