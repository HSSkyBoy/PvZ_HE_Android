@tool
extends TowerDefensePlant

func AttackDeal(character: TowerDefenseCharacter, type: String) -> void :
    super.AttackDeal(character, type)
    if type == "Eat":
        Hurt(10)
        character.Garlic()
        character.Hypnoses()
