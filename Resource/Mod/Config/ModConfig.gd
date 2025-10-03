class_name ModConfig extends Resource

@export var modName: String
@export var modGameVersion: String
@export var modVersion: String
@export var modAuthor: String

@export var hasAudio: bool = false
@export var modAudio: ModAudio

@export var hasScene: bool = false
@export var modScene: ModScene

@export var hasLevel: bool = false
@export var modLevel: ModLevel

@export var hasBgm: bool = false
@export var modBgm: ModBgm

@export var hasMap: bool = false
@export var modMap: ModMap

func Init(modPath: String, data: Dictionary) -> void :
    if data.has("Audio"):
        hasAudio = true
        modAudio = ModAudio.new()
        modAudio.Init(modPath, data.get("Audio", {}))

    if data.has("Scene"):
        hasScene = true
        modScene = ModScene.new()
        modScene.Init(modPath, data.get("Scene", {}))

    if data.has("Level"):
        hasLevel = true
        modLevel = ModLevel.new()
        modLevel.Init(modPath, data.get("Level", {}))

    if data.has("BGM"):
        hasBgm = true
        modBgm = ModBgm.new()
        modBgm.Init(modPath, data.get("BGM", {}))

    if data.has("Map"):
        hasMap = true
        modMap = ModMap.new()
        modMap.Init(modPath, data.get("Map", {}))
