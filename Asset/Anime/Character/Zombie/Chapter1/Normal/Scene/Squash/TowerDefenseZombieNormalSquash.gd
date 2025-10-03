@tool
extends TowerDefenseZombie

@onready var attackComponent2: AttackComponent = %AttackComponent2

@export var eventList: Array[TowerDefenseCharacterEventBase] = []

var savePos: Vector2

var halfHp: bool = false
var isAttack: bool = false

func _ready() -> void :
    super ._ready()
    sprite.head.animeCompleted.connect(AnimeCompleted)

    if TowerDefenseMapControl.instance && TowerDefenseMapControl.instance.LineHasType(gridPos.y, TowerDefenseEnum.PLANTGRIDTYPE.WATER):
        sprite.SetFliters(["Zombie_duckytube", "Zombie_whitewater", "Zombie_whitewater2"], true)

@warning_ignore("unused_parameter")
func IdleProcessing(delta: float) -> void :
    if isRise:
        return
    sprite.timeScale = timeScale

@warning_ignore("unused_parameter")
func WalkProcessing(delta: float) -> void :
    if global_position.x > TowerDefenseManager.GetMapGroundRight():
        sprite.timeScale = timeScale * walkSpeedScale * 2.0
    else:
        sprite.timeScale = timeScale * walkSpeedScale

    if !sprite.pause && attackComponent2.CanAttack():
        savePos = attackComponent2.target.global_position
        sprite.head.usePos = false
        sprite.head.useRotate = false
        Idle()
        sprite.head.timeScale = 4.0
        sprite.head.SetAnimation("JumpUp", false, 0.2)
        var tween = create_tween()
        tween.set_parallel(true)
        tween.set_ease(Tween.EASE_OUT)
        tween.set_trans(Tween.TRANS_QUART)
        tween.tween_property(sprite.head, ^"offsetRotate", 0.0, 0.5)
        tween.tween_property(sprite.head, ^"rotation", 0.0, 0.5)
        tween.tween_property(sprite.head, ^"offset:y", -100.0, 0.5)
        tween.tween_property(sprite.head, ^"offset:x", global_position.x - savePos.x, 0.5)

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
        "JumpUp":
            await get_tree().create_timer(0.25, false).timeout
            sprite.head.SetAnimation("JumpDown", false, 0.2)
            var tween = create_tween()
            tween.set_ease(Tween.EASE_OUT)
            tween.set_trans(Tween.TRANS_QUART)
            tween.tween_property(sprite.head, ^"offset:y", 40.0, 0.1)
        "JumpDown":
            AudioManager.AudioPlay("GargantuarThump", AudioManagerEnum.TYPE.SFX)
            ViewManager.CameraShake(Vector2(randf_range(-1, 1), randf_range(-1, 1)), 5.0, 0.05, 4)
            TowerDefenseExplode.CreateExplode(savePos, Vector2(0.5, 0.2), eventList, [], camp, instance.collisionFlags)
            await get_tree().create_timer(0.5, false).timeout
            Die()
            sprite.head.visible = false
