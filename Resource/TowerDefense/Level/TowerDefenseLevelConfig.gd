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
@export var finishMethod: TowerDefenseEnum.LEVEL_FINISH_METHOD = TowerDefenseEnum.LEVEL_FINISH_METHOD.WAVE
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
@export var limitGridPlantNum: int = -1
@export var plantColumn: bool = false
@export var packetColdDownStart: bool = true
@export var packetBankMethod: TowerDefenseEnum.LEVEL_SEEDBANK_METHOD = TowerDefenseEnum.LEVEL_SEEDBANK_METHOD.CHOOSE:
    set(_packetBankMethod):
        packetBankMethod = _packetBankMethod
        notify_property_list_changed()
@export_category("Sun")
@export var sunManager: TowerDefenseLevelSunManagerConfig = TowerDefenseLevelSunManagerConfig.new()
@export_category("Wave")
@export var waveManager: TowerDefenseLevelWaveManagerConfig
@export_category("Vase")
@export var vaseManager: TowerDefenseLevelVaseManagerConfig
@export_category("Option")
@export var isCustomTalk: bool = false
@export var isCustomTutorial: bool = false
@export var customTalk: NpcTalkConfig
@export var customTutorial: TutorialConfig
@export_storage var packetBank: String = "GeneralPlant"
@export var packetBankList: Array = []
@export var conveyorData: TowerDefenseConveyorConfig
@export var rainData: TowerDefenseRainModeConfig

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
    return properties

func _set(property: StringName, value: Variant) -> bool:
    match property:
        "PacketBank/Name":
            packetBank = value
            return true
    return false

func _get(property: StringName) -> Variant:
    match property:
        "PacketBank/Name":
            return packetBank
    return null

func _property_can_revert(property: StringName) -> bool:
    match property:
        "PacketBank/Name":
            return true
    return false

func _property_get_revert(property: StringName) -> Variant:
    match property:
        "PacketBank/Name":
            return ""
    return null

func Clear() -> void :
    homeWorld = GeneralEnum.HOMEWORLD.NOONE
    finishMethod = TowerDefenseEnum.LEVEL_FINISH_METHOD.WAVE
    packetBankMethod = TowerDefenseEnum.LEVEL_SEEDBANK_METHOD.CHOOSE
    eventInit.clear()
    eventReady.clear()
    eventStart.clear()
    sunManager = null
    waveManager = null
    vaseManager = null
    isCustomTalk = false
    isCustomTutorial = false
    customTalk = null
    customTutorial = null
    packetBankList.clear()
    conveyorData = null
    rainData = null

func Init() -> void :
    if !data:
        return
    Clear()


    var levelData: Dictionary = data.data as Dictionary
    name = levelData.get("Name", "")
    levelName = levelData.get("LevelName", "")
    description = levelData.get("Description", "")
    levelNumber = levelData.get("LevelNumber", 0)
    nextLevel = levelData.get("NextLevel", "")
    homeWorld = GeneralEnum.HOMEWORLD.get(levelData.get("HomeWorld", "NOONE").to_upper())
    finishMethod = TowerDefenseEnum.LEVEL_FINISH_METHOD.get(levelData.get("FinishMethod", "WAVE").to_upper())

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
    limitGridPlantNum = packetBankData.get("LimitGridPlantNum", -1)
    packetColdDownStart = packetBankData.get("ColdDownStart", true)
    packetBankMethod = TowerDefenseEnum.LEVEL_SEEDBANK_METHOD.get(packetBankData.get("Method", "NOONE").to_upper())
    plantColumn = packetBankData.get("PlantColumn", false)
    var packetBankValue = packetBankData.get("Value", [])

    match packetBankMethod:
        TowerDefenseEnum.LEVEL_SEEDBANK_METHOD.PRESET:
            for packetData in packetBankValue:
                var packet: TowerDefenseLevelPacketConfig = TowerDefenseLevelPacketConfig.new()
                packet.Init(packetData)
                packetBankList.append(packet)
        TowerDefenseEnum.LEVEL_SEEDBANK_METHOD.CHOOSE:
            for packetData in packetBankValue:
                var packet: TowerDefenseLevelPacketConfig = TowerDefenseLevelPacketConfig.new()
                packet.Init(packetData)
                packetBankList.append(packet)
            packetBank = packetBankData.get("Type", "")
        TowerDefenseEnum.LEVEL_SEEDBANK_METHOD.CONVEYOR:
            conveyorData = TowerDefenseConveyorConfig.new()
            if packetBankValue.size() == 1 && (typeof(packetBankValue[0]) == TYPE_DICTIONARY && packetBankValue[0].has("Packet")):
                conveyorData.Init(packetBankValue[0])
            else:
                conveyorData.Init(packetBankData.get("ConveyorPreset", []))
        TowerDefenseEnum.LEVEL_SEEDBANK_METHOD.RAIN:
            rainData = TowerDefenseRainModeConfig.new()
            if packetBankValue.size() == 1 && (typeof(packetBankValue[0]) == TYPE_DICTIONARY && packetBankValue[0].has("Packet")):
                rainData.Init(packetBankValue[0])
            else:
                rainData.Init(packetBankData.get("RainPreset", []))

    var sunManagerData: Dictionary = levelData.get("SunManager", {}) as Dictionary
    sunManager = TowerDefenseLevelSunManagerConfig.new()
    sunManager.Init(sunManagerData)

    match finishMethod:
        TowerDefenseEnum.LEVEL_FINISH_METHOD.WAVE:
            var waveManagerData: Dictionary = levelData.get("WaveManager", {}) as Dictionary
            waveManager = TowerDefenseLevelWaveManagerConfig.new()
            waveManager.Init(waveManagerData)
        TowerDefenseEnum.LEVEL_FINISH_METHOD.VASE:
            var vaseManagerData: Dictionary = levelData.get("VaseManager", {}) as Dictionary
            vaseManager = TowerDefenseLevelVaseManagerConfig.new()
            vaseManager.Init(vaseManagerData)

func Export() -> Dictionary:
    var _data: Dictionary = {
        "LevelName": levelName, 
        "LevelNumber": levelNumber, 
        "Description": description, 
        "HomeWorld": GeneralEnum.HOMEWORLD.find_key(homeWorld), 
        "FinishMethod": TowerDefenseEnum.LEVEL_FINISH_METHOD.find_key(finishMethod), 
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
            "LimitGridPlantNum": limitGridPlantNum, 
            "PlantColumn": plantColumn, 
            "ColdDownStart": packetColdDownStart, 
            "Method": TowerDefenseEnum.LEVEL_SEEDBANK_METHOD.find_key(packetBankMethod), 
            "Type": packetBank, 
            "Value": []
        }, 
        "SunManager": sunManager.Export(), 
    }
    for preSpawn: TowerDefenseLevelPreSpawnConfig in preSpawnList:
        _data["PreSpawn"]["Packet"].append(preSpawn.Export())

    for eventGet: TowerDefenseLevelEventBase in eventInit:
        _data["Event"]["EventInit"].append(eventGet.Export())
    for eventGet: TowerDefenseLevelEventBase in eventReady:
        _data["Event"]["EventReady"].append(eventGet.Export())
    for eventGet: TowerDefenseLevelEventBase in eventStart:
        _data["Event"]["EventStart"].append(eventGet.Export())

    for packetData in packetBankList:
        if packetData is TowerDefenseLevelPacketConfig:
            _data["PacketBank"]["Value"].append(packetData.Export())
        elif typeof(packetData) == TYPE_STRING:
            _data["PacketBank"]["Value"].append(packetData)
    match packetBankMethod:
        TowerDefenseEnum.LEVEL_SEEDBANK_METHOD.CONVEYOR:
            _data["PacketBank"]["ConveyorPreset"] = conveyorData.Export()
            _data["PacketBank"]["Value"] = []
        TowerDefenseEnum.LEVEL_SEEDBANK_METHOD.RAIN:
            _data["PacketBank"]["RainPreset"] = rainData.Export()
            _data["PacketBank"]["Value"] = []

    match finishMethod:
        TowerDefenseEnum.LEVEL_FINISH_METHOD.WAVE:
            _data["WaveManager"] = waveManager.Export()
        TowerDefenseEnum.LEVEL_FINISH_METHOD.VASE:
            _data["VaseManager"] = vaseManager.Export()

    return _data

func ConveyorPreset() -> void :
    packetBankMethod = TowerDefenseEnum.LEVEL_SEEDBANK_METHOD.CONVEYOR
    waveManager.minNextWaveHealthPercentage = 0.45
    waveManager.maxNextWaveHealthPercentage = 0.35
    waveManager.beginCol = 9.0
    waveManager.spawnColEnd = 15.0
    waveManager.spawnColStart = 6.0
    sunManager.open = false

func RainPreset() -> void :
    packetBankMethod = TowerDefenseEnum.LEVEL_SEEDBANK_METHOD.RAIN
    sunManager.open = false
