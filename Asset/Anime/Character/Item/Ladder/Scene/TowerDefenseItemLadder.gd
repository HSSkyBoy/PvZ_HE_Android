@tool
extends TowerDefenseItem

func ArmorHitpointsEmpty(armorName: String) -> void :
    super .ArmorHitpointsEmpty(armorName)
    match armorName:
        "Ladder":
            Destroy()
