extends DialogBoxBase

@onready var finishLabel: RichTextLabel = %FinishLabel

@onready var calendar: Control = %Calendar
@onready var playButton: MainButton = %PlayButton
@onready var awardLabel: RichTextLabel = %AwardLabel

var year: int = 2025
var month: int = 1
var day: int = 1
var currentDate: String = "-1--1--1"
var finishNum: int = 0

func _ready() -> void :
    var levelDataMap: Dictionary = ResourceManager.DAILY_LEVEL_DATA["LevelDateMap"]
    var levelMeta: Dictionary = ResourceManager.DAILY_LEVEL_DATA["LevelMeta"]
    if levelDataMap.has(calendar.today):
        var levelList = levelDataMap[calendar.today]
        for levelId in levelList.size():
            var level: String = levelList[levelId]
            var levelName = "DailyLevel-%s-%s" % [calendar.today, level]
            var levelData: Dictionary = GameSaveManager.GetLevelValue(levelName)
            if levelData.get("Key", {}).get("Finish", 0) <= 0:
                var award = levelMeta[level]["reward"]
                match award["type"]:
                    "Coin":
                        awardLabel.text = "今日第%s关悬赏:[img=60]uid://4hw45nbwv7f3[/img][color=green]%s$[/color]" % [levelId + 1, award["value"]]
                return
        awardLabel.text = "今日悬赏已完成"
@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void :
    playButton.disabled = ResourceManager.DAILY_LEVEL_DATA.is_empty() || !ResourceManager.DAILY_LEVEL_DATA["LevelDateMap"].has(currentDate)

func CalendarSelect(_year: int, _month: int, _day: int) -> void :
    if month != _month:
        RefreshMonthFinish()
    year = _year
    month = _month
    day = _day
    currentDate = "%d-%02d-%02d" % [year, month, day]

func CloseButtonPressed() -> void :
    AudioManager.AudioPlay("ButtonPress", AudioManagerEnum.TYPE.SFX)
    Close()

func PlayButtonPressed() -> void :
    AudioManager.AudioPlay("ButtonPress", AudioManagerEnum.TYPE.SFX)
    var levelChooseDialog = DialogCreate("DailyChallengeLevelChoose")
    levelChooseDialog.date = currentDate

func RefreshMonthFinish() -> void :
    await get_tree().physics_frame
    finishNum = 0
    var levelDataMap: Dictionary = ResourceManager.DAILY_LEVEL_DATA["LevelDateMap"]
    for date: String in levelDataMap.keys():
        var _month: int = date.split("-")[1].to_int()
        if month == _month:
            var finishFlag: bool = true
            var levelList: Array = levelDataMap[date]
            for level: String in levelList:
                var levelName = "DailyLevel-%s-%s" % [date, level]
                var levelData: Dictionary = GameSaveManager.GetLevelValue(levelName)
                if levelData.get("Key", {}).get("Finish", 0) <= 0:
                    finishFlag = false
            if finishFlag:
                finishNum += 1
    finishLabel.text = "本月已完成挑战[color=red]%d[/color]天" % finishNum

func AwardButtonPressed() -> void :
    var levelAwardDialog = DialogCreate("DailyChallengeLevelAward")
    levelAwardDialog.InitDialog(calendar.year, calendar.month, finishNum, calendar._get_days_in_month(calendar.month, calendar.year))
