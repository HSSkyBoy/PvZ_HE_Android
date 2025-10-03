@tool
extends TowerDefenseGravestone

@export var eventList: Array[TowerDefenseCharacterEventBase] = []

var boom: bool = false

func DestroySet() -> void :
    if boom:
        return
    boom = true
    ViewManager.FullScreenColorBlink(Color(0.117647, 0.564706, 1, 0.5), 0.1)
    TowerDefenseExplode.CreateExplode(global_position, Vector2(1.5, 1.5), eventList, [], TowerDefenseEnum.CHARACTER_CAMP.NOONE, -1)
