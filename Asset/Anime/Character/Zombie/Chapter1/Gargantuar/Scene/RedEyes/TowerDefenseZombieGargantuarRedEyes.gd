@tool
extends TowerDefenseZombieGargantuarBase

const ZOMBIE_GARGANTUAR_HEAD_2_REDEYE = preload("uid://dkgcc1dscx4mc")

const ZOMBIE_GARGANTUAR_DUCKXING = preload("uid://6dy81rx4gaue")
const ZOMBIE_GARGANTUAR_ZOMBIE = preload("uid://dtrl03qm2d0u7")

func _ready() -> void :
    super ._ready()
    if Engine.is_editor_hint():
        return
    var randWeapon = randf()
    if randWeapon < 0.3:
        sprite.SetReplace("Zombie_gargantuar_telephonepole.png", ZOMBIE_GARGANTUAR_DUCKXING)
    elif randWeapon < 0.6:
        sprite.SetReplace("Zombie_gargantuar_telephonepole.png", ZOMBIE_GARGANTUAR_ZOMBIE)

    if TowerDefenseMapControl.instance && TowerDefenseMapControl.instance.LineHasType(gridPos.y, TowerDefenseEnum.PLANTGRIDTYPE.WATER):
        sprite.SetFliter("Zombie_duckytube", true)

func DamagePointReach(damangePointName: String):
    super .DamagePointReach(damangePointName)
    match damangePointName:
        "Head":
            sprite.SetReplace("Zombie_gargantuar_head.png", ZOMBIE_GARGANTUAR_HEAD_2_REDEYE)

func InWater() -> void :
    super .InWater()
    sprite.SetFliter("Zombie_whitewater", true)

func OutWater() -> void :
    super .OutWater()
    sprite.SetFliter("Zombie_whitewater", false)
