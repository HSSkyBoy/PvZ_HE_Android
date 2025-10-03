@tool
extends TowerDefenseZombie
const ZOMBIE_FLLAG_1 = preload("uid://daats4s58txqp")
const ZOMBIE_FLLAG_2 = preload("uid://dxoshvi4ee5up")
const ZOMBIE_FLLAG_3 = preload("uid://dyi8c7kqovn5h")

@onready var flag: AdobeAnimateSpriteBase = %ZombieFlagpole

var halfHp: bool = false
var isAttack: bool = false

func _ready() -> void :
    super._ready()
    if Engine.is_editor_hint():
        return
    if randf() > 0.5:
        sprite.SetFliter("anim_tongue", true)
    if TowerDefenseMapControl.instance && TowerDefenseMapControl.instance.LineHasType(gridPos.y, TowerDefenseEnum.PLANTGRIDTYPE.WATER):
        sprite.SetFliters(["Zombie_duckytube", "Zombie_whitewater", "Zombie_whitewater2"], true)

func AttackEntered():
    super.AttackEntered()
    isAttack = true
    if HasShield():
        sprite.SetFliters(["Zombie_outerarm_upper"], true)
        if !halfHp:
            sprite.SetFliters(["Zombie_outerarm_hand", "Zombie_outerarm_lower"], true)

func AttackExited() -> void :
    super.AttackExited()
    isAttack = false
    if HasShield():
        sprite.SetFliters(["Zombie_outerarm_upper", "Zombie_outerarm_hand", "Zombie_outerarm_lower"], false)

func DieProcessing(delta: float) -> void :
    super.DieProcessing(delta)
    sprite.timeScale = timeScale * 2.0

@warning_ignore("unused_parameter")
func DamagePointReach(damangePointName: String) -> void :
    super.DamagePointReach(damangePointName)
    match damangePointName:
        "Arm":
            flag.SetReplace("Zombie_flag1.png", ZOMBIE_FLLAG_2)
            sprite.SetFliters(["Zombie_outerarm_upper"], true)
            halfHp = true
        "Head":
            flag.SetReplace("Zombie_flag1.png", ZOMBIE_FLLAG_3)
            flag.visible = false
            sprite.SetFliters(["anim_innerarm1", "anim_innerarm2", "anim_innerarm3"], true)
            sprite.SetFliters(["Zombie_flaghand", "Zombie_innerarm_screendoor"], false)

func ArmorDamagePointReach(armorName: String, stage: int) -> void :
    super.ArmorDamagePointReach(armorName, stage)
    if isAttack && HasShield() && stage > 0:
        sprite.SetFliters(["Zombie_outerarm_upper"], true)
        if !halfHp:
            sprite.SetFliters(["Zombie_outerarm_hand", "Zombie_outerarm_lower"], true)
