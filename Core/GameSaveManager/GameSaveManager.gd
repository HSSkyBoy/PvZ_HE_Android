extends Node

const CHECK_INIT = preload("res://Asset/Config/Check/CheckInit.json")

const TOWER_DEFENSE_PACKET_INIT: JSON = preload("res://Asset/Config/Save/TowerDefensePacketInit.json")
const FEATURE_INIT: JSON = preload("res://Asset/Config/Save/FeatureInit.json")
const TUTORIAL_INIT: JSON = preload("res://Asset/Config/Save/TutorialInit.json")
const LEVEL_INIT: JSON = preload("res://Asset/Config/Save/LevelInit.json")
const KEY_INIT = preload("res://Asset/Config/Save/KeyInit.json")

const CONFIG_INIT = preload("res://Asset/Config/Save/ConfigInit.json")

const PATH: String = "user://save.res"
const PATHCONFIG: String = "user://config.res"
const PATHDAILYLEVEL: String = "user://DailyLevel"
const PATHONLINELEVEL: String = "user://OnlineLevel"

const pathDebug: String = "res://Core/Save/save.res"
const pathConfigDebug: String = "res://Core/Save/config.res"
const pathDailyLevelDebug: String = "res://Core/Save/DailyLevel"
const pathOnlineLevelDebug: String = "res://Core/Save/OnlineLevel"

@export var config: GameSaveConfig
@export var gameConfig: GameConfigSaveConfig

func _ready() -> void :
    if Global.debug:
        if !DirAccess.dir_exists_absolute(pathDailyLevelDebug):
            DirAccess.make_dir_absolute(pathDailyLevelDebug)
        if !DirAccess.dir_exists_absolute(pathOnlineLevelDebug):
            DirAccess.make_dir_absolute(pathOnlineLevelDebug)
        if !FileAccess.file_exists(pathConfigDebug):
            gameConfig = GameConfigSaveConfig.new()
        else:
            gameConfig = ResourceLoader.load(pathConfigDebug)
    else:
        if !DirAccess.dir_exists_absolute(PATHDAILYLEVEL):
            DirAccess.make_dir_absolute(PATHDAILYLEVEL)
        if !DirAccess.dir_exists_absolute(PATHONLINELEVEL):
            DirAccess.make_dir_absolute(PATHONLINELEVEL)
        if !FileAccess.file_exists(PATHCONFIG):
            gameConfig = GameConfigSaveConfig.new()
        else:
            gameConfig = ResourceLoader.load(PATHCONFIG)

    if Global.isMobile:
        if GetConfigValue("FullScreen"):
            DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
        else:
            DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

    Global.animeFrameRate = GetConfigValue("AnimeFrameRate")

func Check() -> void :
    for checkData: Dictionary in CHECK_INIT.data:
        var data: bool
        match checkData["CheckType"]:
            "Packet":
                data = GetTowerDefensePacketValue(checkData["CheckKey"])["Unlock"]
            "Feature":
                data = GetFeatureValue(checkData["CheckKey"])
            "Tutorial":
                data = GetTutorialValue(checkData["CheckKey"])
            "Level":
                data = GetLevelValue(checkData["CheckKey"])["Key"]["Finish"] > 0
            "Key":
                data = GetKeyValue(checkData["CheckKey"])
            "Config":
                data = GetConfigValue(checkData["CheckKey"])
        if data:
            var saveData
            match checkData["SaveType"]:
                "Packet":
                    saveData = GetTowerDefensePacketValue(checkData["SaveKey"])
                    if !saveData["Unlock"]:
                        saveData["Unlock"] = true
                    SetTowerDefensePacketValue(checkData["SaveKey"], saveData)
                "Feature":
                    SetFeatureValue(checkData["SaveKey"], true)
                "Tutorial":
                    SetTutorialValue(checkData["SaveKey"], true)
                "Level":
                    saveData = GetLevelValue(checkData["SaveKey"])
                    if saveData["Key"]["Finish"] <= 0:
                        saveData["Key"]["Finish"] += 1
                    SetLevelValue(checkData["SaveKey"], saveData)
                "Key":
                    SetKeyValue(checkData["SaveKey"], true)
                "Config":
                    SetConfigValue(checkData["SaveKey"], true)

func Save() -> void :
    if GetUserCurrent() != "":
        Check()
    GameSaveManager.SetKeyValue("CoinNum", TowerDefenseManager.coinBank.num)
    if MultiPlayerManager.IsConnect():
        var data: Dictionary = config.Export()
        await MultiPlayerManager.SaveUserData("UserData", "User", JSON.stringify(data), true, true)
    else:
        if !config:
            Load()
        if Global.debug:
            ResourceSaver.save(config, pathDebug)
        else:
            ResourceSaver.save(config, PATH)
    SaveGameConfig()

func SaveGameConfig() -> void :
    if Global.debug:
        ResourceSaver.save(gameConfig, pathConfigDebug)
    else:
        ResourceSaver.save(gameConfig, PATHCONFIG)

func Load() -> void :
    if MultiPlayerManager.IsConnect():
        var data = await MultiPlayerManager.LoadUserData("UserData", "User")
        config = GameSaveConfig.new()
        if !data:
            Save()
        else:
            config.Init(data)
    else:
        if Global.debug:
            if !FileAccess.file_exists(pathDebug):
                config = GameSaveConfig.new()
                Save()
            else:
                config = ResourceLoader.load(pathDebug)
                if config.userCurrent != "":
                    TowerDefenseManager.coinBank.num = GameSaveManager.GetKeyValue("CoinNum")
        else:
            if !FileAccess.file_exists(PATH):
                config = GameSaveConfig.new()
                Save()
            else:
                config = ResourceLoader.load(PATH)
                if config.userCurrent != "":
                    TowerDefenseManager.coinBank.num = GameSaveManager.GetKeyValue("CoinNum")
    if GetUserCurrent() != "":
        Check()

func GetUserCurrent() -> String:
    if config:
        return config.userCurrent
    return ""

func SetUserCurrent(user: String) -> void :
    if !config.userList.has(user):
        AddUser(user)
        Save()
    config.userCurrent = user
    TowerDefenseManager.coinBank.num = GameSaveManager.GetKeyValue("CoinNum")
    Save()

func GetUserList() -> Array[String]:
    return config.userList

func HasUser(user: String) -> bool:
    return config.userList.has(user)

func AddUser(user: String) -> void :
    if !HasUser(user):
        config.InitUser(user)
    Save()

func RenameUser(user: String, newName: String) -> void :
    if HasUser(user):
        config.RenameUser(user, newName)

func DeleteUser(user: String) -> void :
    if HasUser(user):
        config.DeleteUser(user)
        if config.userList.size() > 0:
            SetUserCurrent(config.userList[0])
        else:
            SetUserCurrent("")

func GetUserDictionary(user: String) -> Dictionary:
    if !config.userList.has(user):
        return {}
    return config.saveDictionary[user]

func GetTowerDefensePacketDictionary() -> Dictionary:
    var userCurrent: String = GetUserCurrent()
    if userCurrent == "":
        return {}
    if !config.saveDictionary[userCurrent].has("TowerDefensePacket"):
        config.TowerDefensePacketDictionaryInit(config.saveDictionary[userCurrent])
    return config.saveDictionary[userCurrent]["TowerDefensePacket"]

func GetTowerDefensePacketValue(key: String) -> Dictionary:
    var userCurrent: String = GetUserCurrent()
    if userCurrent == "":
        return {}
    var packetDictionary: Dictionary = GetTowerDefensePacketDictionary()
    if !packetDictionary.has(key):
        packetDictionary[key] = config.TowerDefensePacketDictionaryInitData(TOWER_DEFENSE_PACKET_INIT.data[key])
    return packetDictionary[key]

func SetTowerDefensePacketValue(key: String, value: Dictionary) -> void :
    var userCurrent: String = GetUserCurrent()
    if userCurrent == "":
        return
    var packetDictionary: Dictionary = GetTowerDefensePacketDictionary()
    if !packetDictionary.has(key):
        packetDictionary[key] = config.TowerDefensePacketDictionaryInitData(TOWER_DEFENSE_PACKET_INIT.data[key])
    packetDictionary[key] = value

func GetFeatureDictionary() -> Dictionary:
    var userCurrent: String = GetUserCurrent()
    if userCurrent == "":
        return {}
    if !config.saveDictionary[userCurrent].has("Feature"):
        config.FeatureDictionaryInit(config.saveDictionary[userCurrent])
    return config.saveDictionary[userCurrent]["Feature"]

func GetFeatureValue(key: String) -> int:
    var userCurrent: String = GetUserCurrent()
    if userCurrent == "":
        return false
    var featureDictionary: Dictionary = GetFeatureDictionary()
    if !featureDictionary.has(key):
        featureDictionary[key] = FEATURE_INIT.data[key]
    return featureDictionary[key]

func SetFeatureValue(key: String, value: Variant) -> void :
    var userCurrent: String = GetUserCurrent()
    if userCurrent == "":
        return
    var featureDictionary: Dictionary = GetFeatureDictionary()
    if !featureDictionary.has(key):
        featureDictionary[key] = FEATURE_INIT.data[key]
    featureDictionary[key] = value

func GetTutorialDictionary() -> Dictionary:
    var userCurrent: String = GetUserCurrent()
    if userCurrent == "":
        return {}
    if !config.saveDictionary[userCurrent].has("Tutorial"):
        config.TutorialDictionaryInit(config.saveDictionary[userCurrent])
    return config.saveDictionary[userCurrent]["Tutorial"]

func GetTutorialValue(key: String) -> bool:
    var userCurrent: String = GetUserCurrent()
    if userCurrent == "":
        return false
    var tutorialDictionary: Dictionary = GetTutorialDictionary()
    if !tutorialDictionary.has(key):
        tutorialDictionary[key] = TUTORIAL_INIT.data[key]
    return tutorialDictionary[key]

func SetTutorialValue(key: String, value: bool) -> void :
    var userCurrent: String = GetUserCurrent()
    if userCurrent == "":
        return
    var tutorialDictionary: Dictionary = GetTutorialDictionary()
    if !tutorialDictionary.has(key):
        tutorialDictionary[key] = TUTORIAL_INIT.data[key]
    tutorialDictionary[key] = value

func GetLevelDictionary() -> Dictionary:
    var userCurrent: String = GetUserCurrent()
    if userCurrent == "":
        return {}
    if !config.saveDictionary[userCurrent].has("Level"):
        config.LevelDictionaryInit(config.saveDictionary[userCurrent])
    return config.saveDictionary[userCurrent]["Level"]

func GetLevelValue(key: String) -> Dictionary:
    var userCurrent: String = GetUserCurrent()
    if userCurrent == "" || key == "":
        return {}
    var levelDictionary: Dictionary = GetLevelDictionary()
    if !levelDictionary.has(key):
        if LEVEL_INIT.data.has(key):
            levelDictionary[key] = LEVEL_INIT.data[key]
        else:
            levelDictionary[key] = {}
    return levelDictionary[key]

func SetLevelValue(key: String, value: Dictionary) -> void :
    var userCurrent: String = GetUserCurrent()
    if userCurrent == "":
        return
    var levelDictionary: Dictionary = GetLevelDictionary()
    if !levelDictionary.has(key):
        if LEVEL_INIT.data.has(key):
            levelDictionary[key] = LEVEL_INIT.data[key]
        else:
            levelDictionary[key] = {}
    levelDictionary[key] = value

func GetKeyDictionary() -> Dictionary:
    var userCurrent: String = GetUserCurrent()
    if userCurrent == "":
        return {}
    if !config.saveDictionary[userCurrent].has("Key"):
        config.KeyDictionaryInit(config.saveDictionary[userCurrent])
    return config.saveDictionary[userCurrent]["Key"]

func GetKeyValue(key: String) -> Variant:
    var userCurrent: String = GetUserCurrent()
    if userCurrent == "":
        return false
    var keyDictionary: Dictionary = GetKeyDictionary()
    if !keyDictionary.has(key):
        keyDictionary[key] = KEY_INIT.data[key]
    return keyDictionary[key]

func SetKeyValue(key: String, value: Variant) -> void :
    var userCurrent: String = GetUserCurrent()
    if userCurrent == "":
        return
    var keyDictionary: Dictionary = GetKeyDictionary()
    if !keyDictionary.has(key):
        keyDictionary[key] = KEY_INIT.data[key]
    keyDictionary[key] = value

func GetConfigDictionary() -> Dictionary:
    if !gameConfig.saveDictionary.is_empty():
        gameConfig.Init()
    return gameConfig.saveDictionary

func GetConfigValue(key: String) -> Variant:
    if !gameConfig.saveDictionary.has(key):
        gameConfig.saveDictionary[key] = CONFIG_INIT.data[key]
    return gameConfig.saveDictionary[key]

func SetConfigValue(key: String, value: Variant) -> void :
    if !gameConfig.saveDictionary.has(key):
        gameConfig.saveDictionary[key] = CONFIG_INIT.data[key]
    gameConfig.saveDictionary[key] = value
    if Global.debug:
        ResourceSaver.save(gameConfig, pathConfigDebug)
    else:
        ResourceSaver.save(gameConfig, PATHCONFIG)

func GetDailyLevel(levelName: String) -> JSON:
    if Global.debug:
        var path: String = pathDailyLevelDebug + "/" + levelName + ".json"
        if FileAccess.file_exists(path):
            var json: JSON = load(path)
            if json.data:
                return json
    else:
        var path: String = PATHDAILYLEVEL + "/" + levelName + ".json"
        if FileAccess.file_exists(path):
            var json: JSON = load(path)
            if json.data:
                return json
    return null

func SaveDailyLevel(levelName: String, json: JSON) -> void :
    if Global.debug:
        var path: String = pathDailyLevelDebug + "/" + levelName + ".json"
        var file = FileAccess.open(path, FileAccess.WRITE)
        file.store_string(json.get_parsed_text())
        file.close()
    else:
        var path: String = PATHDAILYLEVEL + "/" + levelName + ".json"
        var file = FileAccess.open(path, FileAccess.WRITE)
        file.store_string(json.get_parsed_text())
        file.close()

func GetOnlineLevel(levelName: String) -> JSON:
    if Global.debug:
        var path: String = pathOnlineLevelDebug + "/" + levelName + ".json"
        if FileAccess.file_exists(path):
            var json: JSON = load(path)
            if json.data:
                return json
    else:
        var path: String = PATHONLINELEVEL + "/" + levelName + ".json"
        if FileAccess.file_exists(path):
            var json: JSON = load(path)
            if json.data:
                return json
    return null

func SaveOnlineLevel(levelName: String, json: JSON) -> void :
    if Global.debug:
        var path: String = pathOnlineLevelDebug + "/" + levelName + ".json"
        var file = FileAccess.open(path, FileAccess.WRITE)
        file.store_string(json.get_parsed_text())
        file.close()
    else:
        var path: String = PATHONLINELEVEL + "/" + levelName + ".json"
        var file = FileAccess.open(path, FileAccess.WRITE)
        file.store_string(json.get_parsed_text())
        file.close()

func SaveLevelProgress(levelName: String) -> void :
    var filename: String = "user://Progress/%s.tscn" % levelName
    var root = get_tree().current_scene
    DirAccess.make_dir_absolute(filename.get_base_dir())
    var scene = PackedScene.new()
    SetOwenr.call(root)
    scene.pack(root)
    ResourceSaver.save(scene, filename)

func SetOwenr(parent) -> void :
    for node in parent.get_children():
        if !is_instance_valid(node.owner):
            node.owner = parent.owner
        SetOwenr(node)

func LoadLevelProgress(levelName: String) -> void :
    SceneManager.ChangeScene("user://Progress/%s.tscn" % levelName, true)
