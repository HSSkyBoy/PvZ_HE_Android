@tool
extends TowerDefenseZombie
@export var eventList: Array[TowerDefenseCharacterEventBase] = []

var savePos: Vector2

var halfHp: bool = false
var isAttack: bool = false

func _ready() -> void :
    super ._ready()
    if Engine.is_editor_hint():
        return
    sprite.head.animeCompleted.connect(AnimeCompleted)
    if TowerDefenseMapControl.instance && TowerDefenseMapControl.instance.LineHasType(gridPos.y, TowerDefenseEnum.PLANTGRIDTYPE.WATER):
        sprite.SetFliters(["Zombie_duckytube", "Zombie_whitewater", "Zombie_whitewater2"], true)

    if !TowerDefenseManager.currentControl || !TowerDefenseManager.currentControl.isGameRunning:
        return
    await get_tree().create_timer(randf_range(25.0, 30.0), false).timeout
    if nearDie || die:
        return
    AudioManager.AudioPlay("ReverseExplosion", AudioManagerEnum.TYPE.SFX)
    sprite.head.SetAnimation("Explode", false)
    sprite.head.timeScale = 1.0

@warning_ignore("unused_parameter")
func WalkProcessing(delta: float) -> void :
    if global_position.x > TowerDefenseManager.GetMapGroundRight():
        sprite.timeScale = timeScale * walkSpeedScale * 2.0
    else:
        sprite.timeScale = timeScale * walkSpeedScale
    if !sprite.pause && attackComponent.CanAttack():
        Attack()

func AttackEntered():
    super .AttackEntered()
    isAttack = true
    if HasShield():
        sprite.SetFliters(["Zombie_outerarm_upper"], true)
        if !halfHp:
            sprite.SetFliters(["Zombie_outerarm_hand", "Zombie_outerarm_lower"], true)

func AttackExited() -> void :
    super .AttackExited()
    isAttack = false
    if HasShield():
        sprite.SetFliters(["Zombie_outerarm_upper", "Zombie_outerarm_hand", "Zombie_outerarm_lower"], false)

func DieProcessing(delta: float) -> void :
    super .DieProcessing(delta)
    sprite.timeScale = timeScale * 2.0

func DamagePointReach(damangePointName: String) -> void :
    super .DamagePointReach(damangePointName)
    match damangePointName:
        "Arm":
            halfHp = true
            sprite.SetFliters(["Zombie_outerarm_upper"], true)
        "Head":
            sprite.head.visible = false

func ArmorDamagePointReach(armorName: String, stage: int) -> void :
    super .ArmorDamagePointReach(armorName, stage)
    if isAttack && HasShield() && stage > 0:
        sprite.SetFliters(["Zombie_outerarm_upper"], true)
        if !halfHp:
            sprite.SetFliters(["Zombie_outerarm_hand", "Zombie_outerarm_lower"], true)

func AnimeCompleted(clip: String) -> void :
    super .AnimeCompleted(clip)
    match clip:
        "Explode":
            TowerDefenseExplode.CreateExplodeLine(gridPos.y, eventList, [], camp, -1)
            visible = false
            CreateJalapenoFire(gridPos)
            Destroy()
