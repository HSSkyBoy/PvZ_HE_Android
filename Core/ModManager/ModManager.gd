extends Node

var PATH: String = OS.get_executable_path().get_base_dir() + "/Mods"
var PATH_MOD: String = "res://Mod/{MODE_NAME}"

var modDictionary: Dictionary[String, ModConfig] = {}

func Find() -> void :
    if !DirAccess.dir_exists_absolute(PATH):
        return
    var dir: DirAccess = DirAccess.open(PATH)
    if dir:
        dir.list_dir_begin()
        var fileName = dir.get_next()
        while fileName != "":
            if !dir.current_is_dir():
                LoadPck(PATH + "/" + fileName, fileName.get_basename())
            fileName = dir.get_next()

func LoadPck(pckPath: String, modName: String) -> void :
    ProjectSettings.load_resource_pack(pckPath)
    prints("加载Mod :", modName)
    LoadMode(PATH_MOD.replace("{MODE_NAME}", modName))

func LoadMode(modPath: String) -> void :
    if !FileAccess.file_exists(modPath + "/" + "mod.json"):
        return
    var json: JSON = load(modPath + "/" + "mod.json")
    var modName: String = json.data.get("Name", "")
    var modGameVersion: String = json.data.get("GameVersion", "")
    var modVersion: String = json.data.get("Version", "")
    var modAuthor: String = json.data.get("Author", "")
    var modConfig: ModConfig = ModConfig.new()
    modConfig.modName = modName
    modConfig.modGameVersion = modGameVersion
    modConfig.modVersion = modVersion
    modConfig.modAuthor = modAuthor
    modConfig.Init(modPath, json.data)
    modDictionary[modName] = modConfig

func FindAudio(audioName: String) -> AudioStream:
    for modName in modDictionary.keys():
        var mod: ModConfig = modDictionary[modName]
        if !mod.hasAudio:
            continue
        return mod.modAudio.GetAudio(audioName)
    return null

func FindScene(audioName: String) -> String:
    for modName in modDictionary.keys():
        var mod: ModConfig = modDictionary[modName]
        if !mod.hasScene:
            continue
        return mod.modScene.GetScene(audioName)
    return ""

func FindLevel(currentChoose: String, chapterId: int, levelId: int, difficult: String) -> String:
    for modName in modDictionary.keys():
        var mod: ModConfig = modDictionary[modName]
        if !mod.hasLevel:
            continue
        return mod.modLevel.GetLevel(currentChoose, chapterId, levelId, difficult)
    return ""

func FindBgm(bgmName: String) -> TowerDefenseBackgroundMusicConfig:
    for modName in modDictionary.keys():
        var mod: ModConfig = modDictionary[modName]
        if !mod.hasBgm:
            continue
        return mod.modBgm.GetBgm(bgmName)
    return null

func FindMap(mapName: String) -> TowerDefenseMapConfig:
    for modName in modDictionary.keys():
        var mod: ModConfig = modDictionary[modName]
        if !mod.hasMap:
            continue
        return mod.modMap.GetMap(mapName)
    return null
