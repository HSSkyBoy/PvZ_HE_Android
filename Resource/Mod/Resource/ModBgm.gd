class_name ModBgm extends Resource

var BGMS: Dictionary = {}

func Init(modPath: String, data: Dictionary) -> void :
    LoadBgm(modPath, data)

@warning_ignore("unused_parameter")
func LoadBgm(modPath: String, data: Dictionary) -> void :
    for bgmName in data.keys():
        var bgmPath: String = data[bgmName]
        if !ResourceLoader.exists(bgmPath):
            continue
        prints("Load Bgm :", bgmPath)
        BGMS[bgmName] = load(bgmPath)

func GetBgm(bgmName: String) -> TowerDefenseBackgroundMusicConfig:
    if !BGMS.has(bgmName):
        return null
    return BGMS[bgmName]
