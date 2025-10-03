@tool
extends TowerDefenseZombie

func _ready() -> void :
    super._ready()
    if Engine.is_editor_hint():
        return

func AttackProcessing(delta: float) -> void :
    super.AttackProcessing(delta)
    sprite.timeScale = timeScale * 4.0

func DieProcessing(delta: float) -> void :
    super.DieProcessing(delta)
    sprite.timeScale = timeScale * 2.0
