class_name ModMap extends Resource

var MAPS: Dictionary = {}

func Init(modPath: String, data: Dictionary) -> void :
    LoadMap(modPath, data)

@warning_ignore("unused_parameter")
func LoadMap(modPath: String, data: Dictionary) -> void :
    for mapName in data.keys():
        var mapPath: String = data[mapName]
        if !ResourceLoader.exists(mapPath):
            continue
        prints("Load Map :", mapPath)
        MAPS[mapName] = load(mapPath)

func GetMap(mapName: String) -> TowerDefenseMapConfig:
    if !MAPS.has(mapName):
        return null
    return MAPS[mapName]
