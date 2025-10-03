@tool
extends TowerDefensePlant

var over: bool = false

func AttackDeal(character: TowerDefenseCharacter, type: String) -> void :
    super .AttackDeal(character, type)
    if instance.sleep:
        return
    if over:
        return
    if type == "Eat":
        over = true
        character.Hypnoses()
        Destroy()
