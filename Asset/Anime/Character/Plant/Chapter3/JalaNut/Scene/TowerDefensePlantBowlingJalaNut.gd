@tool
extends TowerDefensePlantBowlingBase

@export var eventList: Array[TowerDefenseCharacterEventBase] = []
@export var allEventList: Array[TowerDefenseCharacterEventBase] = []

@warning_ignore("unused_parameter")
func Bowling(character: TowerDefenseCharacter) -> void :

    Explode()
    Destroy()

func Explode() -> void :
    TowerDefenseExplode.CreateExplodeLine(gridPos.y, eventList, [], camp, -1)
    TowerDefenseExplode.CreateExplodeLine(gridPos.y, allEventList, [], TowerDefenseEnum.CHARACTER_CAMP.ALL, -1)
    visible = false
    if is_instance_valid(TowerDefenseMapControl.instance.iceCapList[gridPos.y]):
        TowerDefenseMapControl.instance.iceCapList[gridPos.y].queue_free()
    CreateJalapenoFire(gridPos)
