class_name GameConfigSaveConfig extends Resource

@export var saveDictionary: Dictionary = {}

func _init() -> void :
    saveDictionary = {}

func Init() -> void :
    for keyName: String in GameSaveManager.CONFIG_INIT.data.keys():
        saveDictionary[keyName] = GameSaveManager.CONFIG_INIT.data[keyName]
