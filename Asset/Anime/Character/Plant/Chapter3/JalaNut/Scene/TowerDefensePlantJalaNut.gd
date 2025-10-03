@tool
extends TowerDefensePlant

@export var eventList: Array[TowerDefenseCharacterEventBase] = []
@export var allEventList: Array[TowerDefenseCharacterEventBase] = []

var over: bool = false

func DestroySet() -> void :
    if over:
        return
    over = true
    Explode()

func Explode() -> void :
    TowerDefenseExplode.CreateExplodeLine(gridPos.y, eventList, [], camp, -1)
    TowerDefenseExplode.CreateExplodeLine(gridPos.y, allEventList, [], TowerDefenseEnum.CHARACTER_CAMP.ALL, -1)
    visible = false
    if is_instance_valid(TowerDefenseMapControl.instance.iceCapList[gridPos.y]):
        TowerDefenseMapControl.instance.iceCapList[gridPos.y].queue_free()
    CreateJalapenoFire(gridPos)
