class_name TutorialConditionCheckSunCollect extends TutorialConditionConfig

@export var num: int = 25

var currentNum: int = 0

func Init(data: Dictionary) -> void :
    super.Init(data)
    num = data.get("Num", 1)

func Enter() -> void :
    super.Enter()
    TowerDefenseManager.GetSeedBank().sunCollect.connect(SunCollect)

func Step() -> bool:
    return currentNum >= num

func SunCollect(_sun: int) -> void :
    currentNum += _sun
