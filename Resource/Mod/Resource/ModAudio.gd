class_name ModAudio extends Resource

var AUDIO: Dictionary = {}

func Init(modPath: String, data: Dictionary) -> void :
    LoadAudio(modPath, data)

@warning_ignore("unused_parameter")
func LoadAudio(modPath: String, data: Dictionary) -> void :
    for audioName in data.keys():
        var audioPath: String = data[audioName]
        if !ResourceLoader.exists(audioPath):
            continue
        prints("Load Audio :", audioPath)
        AUDIO[audioName] = load(audioPath)


func GetAudio(audioName: String) -> AudioStream:
    if !AUDIO.has(audioName):
        return null
    return AUDIO[audioName]
