@tool
extends TowerDefensePlantBowlingBase

@onready var magnetComponent: MagnetComponent = %MagnetComponent

var hitArmor: bool = false

func _physics_process(delta: float) -> void :
    if Engine.is_editor_hint():
        return
    super ._physics_process(delta)
    if magnetComponent.breakDownArmor:
        var hurt: TowerDefenseCharacterEventBowlingHurt = hitEvent[0].duplicate()
        hurt.num = 1800 + magnetComponent.breakDownArmor.hitPoints * 4.5
        hitEvent[0] = hurt
    else:
        if await magnetComponent.CanArmorDraw():
            magnetComponent.ArmorDraw()
        else:
            var hurt: TowerDefenseCharacterEventBowlingHurt = hitEvent[0].duplicate()
            hurt.num = 1800
            hitEvent[0] = hurt

func Bowling(character: TowerDefenseCharacter) -> void :
    super .Bowling(character)
    if magnetComponent.breakDownArmor:
        magnetComponent.BreakDownOver()

@warning_ignore("unused_parameter")
func Destroy(freeInsance: bool = true) -> void :
    magnetComponent.Destroy()
    super .Destroy(freeInsance)
