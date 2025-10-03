extends TowerDefenseMap




func EnterRoom(character: TowerDefenseCharacter) -> void :
    var tween = create_tween()
    tween.set_parallel(true)
    tween.tween_property(character, ^"global_position:y", 375.0, abs(global_position.y - 375) / 200.0)
    tween.tween_property(character, ^"saveShadowPosition:y", 375.0 + 36.0, abs(global_position.y - 375) / 200.0)
    await tween.finished
    if is_instance_valid(character):
        character.timeScaleInit *= 2


    await get_tree().create_timer(3.0, false).timeout
