@tool
extends TowerDefenseCrater

func _physics_process(delta: float) -> void :
    super ._physics_process(delta)
    sprite.global_position.y = transformPoint.global_position.y - 18.0
