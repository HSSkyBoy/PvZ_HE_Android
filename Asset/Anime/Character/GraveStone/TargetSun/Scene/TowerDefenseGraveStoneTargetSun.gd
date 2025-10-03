@tool
extends TowerDefenseGravestone

func DestroySet() -> void :
    if randf() > 0.5:
        SunCreate(global_position, 25, TowerDefenseEnum.SUN_MOVING_METHOD.GRAVITY, Vector2(randf_range(-50.0, 50.0), -400.0), 980.0)
    else:
        SunCreate(global_position, 15, TowerDefenseEnum.SUN_MOVING_METHOD.GRAVITY, Vector2(randf_range(-50.0, 50.0), -400.0), 980.0)
    await get_tree().physics_frame
