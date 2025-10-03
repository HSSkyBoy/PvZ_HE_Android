class_name TutorialConditionCheckCharaterNum extends TutorialConditionConfig

@export var characterName: String = ""
@export_enum(">", ">=", "==", "<", "<=") var method: String = ">"
@export var num: int = 1

func Init(data: Dictionary) -> void :
    super.Init(data)
    characterName = data.get("CharacterName", "")
    method = data.get("Method", ">")
    num = data.get("Num", 1)

func Step() -> bool:

    match method:
        ">":
            return TowerDefenseManager.GetCharacterFromName(characterName).size() > num
        ">=":
            return TowerDefenseManager.GetCharacterFromName(characterName).size() >= num
        "==":
            return TowerDefenseManager.GetCharacterFromName(characterName).size() == num
        "<":
            return TowerDefenseManager.GetCharacterFromName(characterName).size() < num
        "<=":
            return TowerDefenseManager.GetCharacterFromName(characterName).size() <= num
    return false
