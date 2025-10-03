class_name ModScene extends Resource

var SCENE: Dictionary = {}

func Init(modPath: String, data: Dictionary) -> void :
    LoadScene(modPath, data)

@warning_ignore("unused_parameter")
func LoadScene(modPath: String, data: Dictionary) -> void :
    for sceneName in data.keys():
        var scenePath: String = data[sceneName]
        if !ResourceLoader.exists(scenePath):
            continue
        prints("Load Scene :", scenePath)
        SCENE[sceneName] = scenePath

func GetScene(sceneName: String) -> String:
    if !SCENE.has(sceneName):
        return ""
    return SCENE[sceneName]
