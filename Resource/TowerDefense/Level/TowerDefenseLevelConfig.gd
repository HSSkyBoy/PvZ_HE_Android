@tool
class_name TowerDefenseLevelConfig extends Resource

@export_storage var canExport: bool = false:
    set(_canExport):
        canExport = _canExport

@export var data: JSON:
    set(_data):
        data = _data
        Init()
@export var name: String = ""
@export var description: String = "关卡描述"
@export var levelName: String = "关卡名"
@export var levelNumber: int = 1
@export var nextLevel: String = ""
@export var homeWorld: GeneralEnum.HOMEWORLD = GeneralEnum.HOMEWORLD.NOONE
@export_category("Mower")
@export var mowerUse: bool = true
@export_category("Tutorial")
@export var talk: Variant = ""
@export var tutorial: Variant = ""
@export_category("Map")
@export var map: String = "Frontlawn"
@export_category("BGM")
@export var backgroundMusic: String = "Frontlawn"
@export_category("Reward")
@export var firstRewardType: TowerDefenseEnum.LEVEL_REWARDTYPE = TowerDefenseEnum.LEVEL_REWARDTYPE.COIN
@export_storage var firstRewardValue = 2000
@export_category("Event")
@export var eventInit: Array[TowerDefenseLevelEventBase] = []
@export var eventReady: Array[TowerDefenseLevelEventBase] = []
@export var eventStart: Array[TowerDefenseLevelEventBase] = []
@export_category("PreSpawn")
@export var preSpawnList: Array[TowerDefenseLevelPreSpawnConfig] = []
@export_category("PacketBank")
@export var packetColdDownStart: bool = true
@export var packetBankMethod: TowerDefenseEnum.LEVEL_SEEDBANK_METHOD = TowerDefenseEnum.LEVEL_SEEDBANK_METHOD.CHOOSE:
    set(_packetBankMethod):
        packetBankMethod = _packetBankMethod
        notify_property_list_changed()
@export_category("Sun")
@export var sunManager: TowerDefenseLevelSunManagerConfig = TowerDefenseLevelSunManagerConfig.new()
@export_category("Wave")
@export var waveManager: TowerDefenseLevelWaveManagerConfig = TowerDefenseLevelWaveManagerConfig.new()
@export_category("Option")

@export var isCustomTalk: bool = false
@export var isCustomTutorial: bool = false
@export var customTalk: NpcTalkConfig
@export var customTutorial: TutorialConfig
@export_storage var packetBank: String = "GeneralPlant"
@export_storage var packetBankList: Array[String] = []
@export var conveyorData: TowerDefenseConveyorConfig = TowerDefenseConveyorConfig.new()

func _get_property_list() -> Array[Dictionary]:
    var properties: Array[Dictionary] = []
    match packetBankMethod:
        TowerDefenseEnum.LEVEL_SEEDBANK_METHOD.CHOOSE:
            properties.append(
                {
                    "name": "PacketBank/Name", 
                    "type": TYPE_STRING, 
                }
            )
            properties.append(
                {
                    "name": "PacketBank/PacketName", 
                    "type": TYPE_ARRAY, 
                    "hint": PROPERTY_HINT_TYPE_STRING, 
                }
            )
        TowerDefenseEnum.LEVEL_SEEDBANK_METHOD.PRESET:
            properties.append(
                {
                    "name": "PacketBank/PacketName", 
                    "type": TYPE_ARRAY, 
                    "hint": PROPERTY_HINT_TYPE_STRING, 
                }
            )
    return properties

func _set(property: StringName, value: Variant) -> bool:
    match property:
        "PacketBank/Name":
            packetBank = value
            return true
        "PacketBank/PacketName":
            packetBankList = value
            return true
    return false

func _get(property: StringName) -> Variant:
    match property:
        "PacketBank/Name":
            return packetBank
        "PacketBank/PacketName":
            return packetBankList
    return null

func _property_can_revert(property: StringName) -> bool:
    match property:
        "PacketBank/Name":
            return true
        "PacketBank/PacketName":
            return true
    return false

func _property_get_revert(property: StringName) -> Variant:
    match property:
        "PacketBank/Name":
            return ""
        "PacketBank/PacketName":
            return Array([], TYPE_STRING, "", null)
    return null

func Init() -> void :
    if !data:
        return
    eventInit = []
    eventReady = []
    eventStart = []
    sunManager = null
    waveManager = null
    isCustomTalk = false
    isCustomTutorial = false
    customTalk = null
    customTutorial = null

    var levelData: Dictionary = data.data as Dictionary
    name = levelData.get("Name", "")
    levelName = levelData.get("LevelName", "")
    description = levelData.get("Description", "")
    levelNumber = levelData.get("LevelNumber", 0)
    nextLevel = levelData.get("NextLevel", "")
    homeWorld = GeneralEnum.HOMEWORLD.get(levelData.get("HomeWorld", "NOONE").to_upper())
    mowerUse = levelData.get("MowerUse", true)
    var talkGet = levelData.get("Talk", "")
    if talkGet is Dictionary:
        isCustomTalk = true
        customTalk = NpcTalkConfig.new()
        customTalk.Load(talkGet)
    else:
        talk = talkGet

    var tutorialGet = levelData.get("Tutorial", "")
    if tutorialGet is Dictionary:
        isCustomTutorial = true
        customTutorial = TutorialConfig.new()
        customTutorial.Load(tutorialGet)
    else:
        tutorial = tutorialGet
    map = levelData.get("Map", "")

    backgroundMusic = levelData.get("BGM", "")

    var rewardData: Dictionary = levelData.get("Reward", {}) as Dictionary
    firstRewardType = TowerDefenseEnum.LEVEL_REWARDTYPE.get(str(rewardData.get("RewardType", "NOONE")).to_upper())
    firstRewardValue = rewardData.get("RewardFirst")

    var eventData: Dictionary = levelData.get("Event", {}) as Dictionary
    var eventInitList: Array = eventData.get("EventInit", []) as Array
    for eventInitDictionary: Dictionary in eventInitList:
        var eventName: String = eventInitDictionary.get("EventName", "")
        if eventName:
            var event = TowerDefenseLevelEventMathine.EventGet(eventName)
            var eventValue: Dictionary = eventInitDictionary.get("Value", {})
            event.Init(eventValue)
            eventInit.append(event)

    var eventReadyList: Array = eventData.get("EventReady", []) as Array
    for eventReadyDictionary: Dictionary in eventReadyList:
        var eventName: String = eventReadyDictionary.get("EventName", "")
        if eventName:
            var event = TowerDefenseLevelEventMathine.EventGet(eventName)
            var eventValue: Dictionary = eventReadyDictionary.get("Value", {})
            event.Init(eventValue)
            eventReady.append(event)

    var eventStartist: Array = eventData.get("EventStart", []) as Array
    for eventStartDictionary: Dictionary in eventStartist:
        var eventName: String = eventStartDictionary.get("EventName", "")
        if eventName:
            var event = TowerDefenseLevelEventMathine.EventGet(eventName)
            var eventValue: Dictionary = eventStartDictionary.get("Value", {})
            event.Init(eventValue)
            eventStart.append(event)

    preSpawnList = []
    var preSpawnData: Dictionary = levelData.get("PreSpawn", {}) as Dictionary
    var packetList: Array = preSpawnData.get("Packet", []) as Array
    for packetData: Dictionary in packetList:
        var preSpawnConfig: TowerDefenseLevelPreSpawnConfig = TowerDefenseLevelPreSpawnConfig.new()
        preSpawnConfig.Init(packetData)
        preSpawnList.append(preSpawnConfig)

    var packetBankData: Dictionary = levelData.get("PacketBank", {}) as Dictionary
    packetColdDownStart = packetBankData.get("ColdDownStart", true)
    packetBankMethod = TowerDefenseEnum.LEVEL_SEEDBANK_METHOD.get(packetBankData.get("Method", "NOONE").to_upper())
    var packetBankValue = packetBankData.get("Value", [])
    match packetBankMethod:
        TowerDefenseEnum.LEVEL_SEEDBANK_METHOD.PRESET:
            packetBankList = Array(packetBankValue, TYPE_STRING, "", null)
        TowerDefenseEnum.LEVEL_SEEDBANK_METHOD.CHOOSE:
            packetBankList = Array(packetBankValue, TYPE_STRING, "", null)
            packetBank = packetBankData.get("Type", "")
        TowerDefenseEnum.LEVEL_SEEDBANK_METHOD.CONVEYOR:
            conveyorData = TowerDefenseConveyorConfig.new()
            conveyorData.Init(packetBankValue[0])

    var sunManagerData: Dictionary = levelData.get("SunManager", {}) as Dictionary
    sunManager = TowerDefenseLevelSunManagerConfig.new()
    sunManager.Init(sunManagerData)

    var waveManagerData: Dictionary = levelData.get("WaveManager", {}) as Dictionary
    waveManager = TowerDefenseLevelWaveManagerConfig.new()
    waveManager.Init(waveManagerData)

func Export() -> Dictionary:
    var _data: Dictionary = {
        "LevelName": levelName, 
        "LevelNumber": levelNumber, 
        "Description": description, 
        "HomeWorld": GeneralEnum.HOMEWORLD.find_key(homeWorld), 
        "Talk": talk, 
        "Tutorial": tutorial, 
        "Map": map, 
        "BGM": backgroundMusic, 
        "MowerUse": mowerUse, 
        "Reward": {
            "RewardType": TowerDefenseEnum.LEVEL_REWARDTYPE.find_key(firstRewardType), 
            "RewardFirst": firstRewardValue
        }, 
        "Event": {
            "EventInit": [], 
            "EventReady": [], 
            "EventStart": [], 
        }, 
        "PreSpawn": {
            "Packet": []
        }, 
        "PacketBank": {
            "ColdDownStart": packetColdDownStart, 
            "Method": TowerDefenseEnum.LEVEL_SEEDBANK_METHOD.find_key(packetBankMethod), 
            "Type": packetBank, 
            "Value": packetBankList
        }, 
        "SunManager": sunManager.Export(), 
        "WaveManager": waveManager.Export()
    }
    for preSpawn: TowerDefenseLevelPreSpawnConfig in preSpawnList:
        _data["PreSpawn"]["Packet"].append(preSpawn.Export())

    for eventGet: TowerDefenseLevelEventBase in eventInit:
        _data["Event"]["EventInit"].append(eventGet.Export())
    for eventGet: TowerDefenseLevelEventBase in eventReady:
        _data["Event"]["EventReady"].append(eventGet.Export())
    for eventGet: TowerDefenseLevelEventBase in eventStart:
        _data["Event"]["EventStart"].append(eventGet.Export())

    match packetBankMethod:
        TowerDefenseEnum.LEVEL_SEEDBANK_METHOD.CONVEYOR:
            _data["PacketBank"]["Value"] = []
            _data["PacketBank"]["Value"].append(conveyorData.Export())
    return _data

func ConveyorPreset() -> void :
    packetBankMethod = TowerDefenseEnum.LEVEL_SEEDBANK_METHOD.CONVEYOR
    waveManager.minNextWaveHealthPercentage = 0.45
    waveManager.maxNextWaveHealthPercentage = 0.35
    waveManager.beginCol = 9.0
    waveManager.spawnColEnd = 15.0
    waveManager.spawnColStart = 6.0
    sunManager.open = false
