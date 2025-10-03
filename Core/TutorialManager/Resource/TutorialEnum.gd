class_name TutorialEnum

static func GetCondition(conditionName: String) -> TutorialConditionConfig:
    match conditionName:
        "CheckCharacterNum":
            return TutorialConditionCheckCharaterNum.new()
        "CheckSunCollect":
            return TutorialConditionCheckSunCollect.new()
    return null
