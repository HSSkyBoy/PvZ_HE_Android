extends DialogBoxBase

const DAILY_CHALLENGE_LEVEL_CHOOSE_BUTTON = preload("uid://dq0anpngru0qq")
const DAILY_CHALLENGE_LEVEL_CHOOSE_BUTTON_GROUP = preload("uid://bp0gych3ped8t")

@onready var dailyChallengeLevelChooseButton: Array = [ %DailyChallengeLevelChooseButton, %DailyChallengeLevelChooseButton2, %DailyChallengeLevelChooseButton3, %DailyChallengeLevelChooseButton4, %DailyChallengeLevelChooseButton5]
@onready var levelHTTPRequest: HTTPRequest = %LevelHTTPRequest
@onready var playButton: MainButton = %PlayButton

var date: String = ""

var levelList: Array

var chooseId: int = 0

func _ready() -> void :
    super._ready()
    await get_tree().physics_frame
    var levelDataMap: Dictionary = ResourceManager.DAILY_LEVEL_DATA["LevelDateMap"]
    levelList = levelDataMap[date]
    for buttonNodeId in dailyChallengeLevelChooseButton.size():
        var buttonNode = dailyChallengeLevelChooseButton[buttonNodeId]
        if buttonNodeId < levelList.size():
            buttonNode.visible = true
            var levelId = levelList[buttonNodeId]
            var levelName = "DailyLevel-%s-%s" % [date, levelId]
            var levelData: Dictionary = GameSaveManager.GetLevelValue(levelName)
            if levelData.get("Key", {}).get("Finish", 0) > 0:
                buttonNode.finishTexture.visible = true
        buttonNode.button.button_group = DAILY_CHALLENGE_LEVEL_CHOOSE_BUTTON_GROUP
        buttonNode.button.pressed.connect(ChooseLevel.bind(buttonNodeId))
    dailyChallengeLevelChooseButton[0].button.button_pressed = true

func ChooseLevel(id) -> void :
    chooseId = id

func CloseButtonPressed() -> void :
    AudioManager.AudioPlay("ButtonPress", AudioManagerEnum.TYPE.SFX)
    Close()

func PlayButtonPressed() -> void :
    AudioManager.AudioPlay("ButtonPress", AudioManagerEnum.TYPE.SFX)
    var meta = ResourceManager.DAILY_LEVEL_DATA["LevelMeta"]
    var levelId = levelList[chooseId]
    var levelName = "DailyLevel-%s-%s" % [date, levelId]
    var level = GameSaveManager.GetDailyLevel(levelName)
    if !level:
        levelHTTPRequest.request("https://api.pvzhe.com%s" % meta[levelId]["api"], Global.header)
        for buttonNode in dailyChallengeLevelChooseButton:
            buttonNode.button.disabled = true
        playButton.disabled = true
    else:
        ToBattle(level)

@warning_ignore("unused_parameter")
func LevelHttpRequestCompleted(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void :
    var meta = ResourceManager.DAILY_LEVEL_DATA["LevelMeta"]
    var levelId = levelList[chooseId]
    var levelName = "DailyLevel-%s-%s" % [date, levelId]
    var json = JSON.new()
    json.parse(body.get_string_from_utf8(), true)
    if json.data:
        json.data["Name"] = levelName
        json.data["Reward"] = {}
        json.data["Reward"]["RewardType"] = meta[levelId]["reward"]["type"]
        json.data["Reward"]["RewardFirst"] = meta[levelId]["reward"]["value"]
        var saveJson = JSON.new()
        saveJson.parse(JSON.stringify(json.data), true)
        GameSaveManager.SaveDailyLevel(levelName, saveJson)
        ToBattle(saveJson)
    else:
        BroadCastManager.BroadCastFloatCreate("获取关卡失败,请重新尝试", Color.RED)
        for buttonNode in dailyChallengeLevelChooseButton:
            buttonNode.button.disabled = false
        playButton.disabled = false

func ToBattle(json: JSON) -> void :
    var config: TowerDefenseLevelConfig = TowerDefenseLevelConfig.new()
    config.data = json
    config.Init()
    TowerDefenseManager.currentLevelConfig = config
    Global.enterLevelMode = "DailyLevel"
    SceneManager.ChangeScene("TowerDefense")
