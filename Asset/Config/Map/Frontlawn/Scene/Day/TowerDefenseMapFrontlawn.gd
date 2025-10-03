extends TowerDefenseMap

@onready var frontlawnFloor: Sprite2D = %FrontlawnFloor
@onready var frontlawnDoor: Sprite2D = %FrontlawnDoor

func EnterRoom(character: TowerDefenseCharacter) -> void :
    var tween = create_tween()
    tween.tween_property(character, ^"global_position:y", 375.0, abs(global_position.y - 375) / 200.0)
    await tween.finished
    character.timeScaleInit *= 2
    frontlawnDoor.visible = true
    frontlawnFloor.visible = true
    await get_tree().create_timer(3.0, false).timeout
