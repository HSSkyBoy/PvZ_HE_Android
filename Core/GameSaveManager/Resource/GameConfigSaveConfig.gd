class_name GameSaveConfig extends Resource

@export var userCurrent: String = ""
@export var userList: Array[String] = []
@export var saveDictionary: Dictionary = {}

func _init() -> void :
    userCurrent = ""
    userList = []
    saveDictionary = {}

func Init(data: Dictionary) -> void :
    userCurrent = data["Current"]
    userList = Array(JSON.parse_string(data["List"]), TYPE_STRING, "", null)
    saveDictionary = JSON.parse_string(data["Dictionary"])

func Export() -> Dictionary:
    return {
        "Current": userCurrent, 
        "List": JSON.stringify(userList), 
        "Dictionary": JSON.stringify(saveDictionary)
    }

func InitUser(user: String) -> void :
    var userDictionary: Dictionary = {}
    TowerDefensePacketDictionaryInit(userDictionary)
    FeatureDictionaryInit(userDictionary)
    TutorialDictionaryInit(userDictionary)
    LevelDictionaryInit(userDictionary)
    KeyDictionaryInit(userDictionary)
    userList.append(user)
    saveDictionary[user] = userDictionary

func RenameUser(user: String, newName: String) -> void :
    saveDictionary[newName] = saveDictionary[user]
    saveDictionary.erase(user)
    userList.erase(user)
    userList.append(newName)

func DeleteUser(user: String) -> void :
    userList.erase(user)
    saveDictionary.erase(user)

func TowerDefensePacketDictionaryInit(dictionary: Dictionary) -> void :
    dictionary["TowerDefensePacket"] = {}
    for packetName: String in GameSaveManager.TOWER_DEFENSE_PACKET_INIT.data.keys():
        dictionary["TowerDefensePacket"][packetName] = TowerDefensePacketDictionaryInitData(GameSaveManager.TOWER_DEFENSE_PACKET_INIT.data[packetName])

func TowerDefensePacketDictionaryInitData(unlock: bool) -> Dictionary:
    return {
        "Unlock": unlock, 
        "Love": false, 
        "Key": {
            "Custom": ""
        }
    }

func FeatureDictionaryInit(dictionary: Dictionary) -> void :
    dictionary["Feature"] = {}
    for featureName: String in GameSaveManager.FEATURE_INIT.data.keys():
        dictionary["Feature"][featureName] = GameSaveManager.FEATURE_INIT.data[featureName]

func TutorialDictionaryInit(dictionary: Dictionary) -> void :
    dictionary["Tutorial"] = {}
    for tutorialName: String in GameSaveManager.TUTORIAL_INIT.data.keys():
        dictionary["Tutorial"][tutorialName] = GameSaveManager.TUTORIAL_INIT.data[tutorialName]

func LevelDictionaryInit(dictionary: Dictionary) -> void :
    dictionary["Level"] = {}
    for levelName: String in GameSaveManager.LEVEL_INIT.data.keys():
        dictionary["Level"][levelName] = {
            "Normal": false, 
            "Difficult": false, 
            "Ultimate": false, 
            "Mower": false, 
            "Key": {
                "Finish": 0
            }
        }

func KeyDictionaryInit(dictionary: Dictionary) -> void :
    dictionary["Key"] = {}
    for keyName: String in GameSaveManager.KEY_INIT.data.keys():
        dictionary["Key"][keyName] = GameSaveManager.KEY_INIT.data[keyName]
