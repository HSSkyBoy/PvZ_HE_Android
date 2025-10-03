@tool
extends TowerDefenseZombie

func _ready() -> void :
    super._ready()
    if Engine.is_editor_hint():
        return
    if TowerDefenseMapControl.instance && TowerDefenseMapControl.instance.LineHasType(gridPos.y, TowerDefenseEnum.PLANTGRIDTYPE.WATER):
        sprite.SetFliters(["Zombie_duckytube", "Zombie_whitewater"], true)

func AttackProcessing(delta: float) -> void :
    super.AttackProcessing(delta)
    sprite.timeScale = timeScale * 3.0

func DieProcessing(delta: float) -> void :
    super.DieProcessing(delta)
    sprite.timeScale = timeScale * 2.0
