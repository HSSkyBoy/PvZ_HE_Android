extends DialogBoxBase

const DAILY_CHALLENGE_AWARD_ITEM = preload("uid://b1cbbcykkioe0")

@onready var dailyChallengeAwardProgressBar: TextureProgressBar = %DailyChallengeAwardProgressBar
@onready var itemContainer: VBoxContainer = %ItemContainer
@onready var textLabel: Label = %TextLabel

var year: int = 2025
var month: int = 1
var finish: int = 0
var dayAll: int = 1

var currentAwardList: Array

func InitDialog(_year: int, _month: int, _finish: int, _dayAll: int) -> void :
    year = _year
    month = _month
    finish = _finish
    dayAll = _dayAll
    textLabel.text = "%d/%d月奖励" % [year, month]
    if ResourceManager.DAILY_LEVEL_AWARD.data.has("%d-%02d" % [year, month]):
        currentAwardList = ResourceManager.DAILY_LEVEL_AWARD.data["%d-%02d" % [year, month]]
    else:
        currentAwardList = []
    dailyChallengeAwardProgressBar.Init(currentAwardList, finish, dayAll)

    for awardData in currentAwardList:
        var item = DAILY_CHALLENGE_AWARD_ITEM.instantiate()
        itemContainer.add_child(item)
        item.Init(awardData, finish)

func CloseButtonPressed() -> void :
    AudioManager.AudioPlay("ButtonPress", AudioManagerEnum.TYPE.SFX)
    Close()
