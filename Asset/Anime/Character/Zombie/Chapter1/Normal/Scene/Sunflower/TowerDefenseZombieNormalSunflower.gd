@tool
extends TowerDefenseZombie

@onready var produceComponent: ProduceComponent = %ProduceComponent

@export var produceInterval: float = 25.0
@export var sunNum: int = 25

var halfHp: bool = false
var isAttack: bool = false

func _ready() -> void :
    super ._ready()
    if Engine.is_editor_hint():
        return
    produceComponent.produceInterval = produceInterval
    produceComponent.num = sunNum

    if TowerDefenseMapControl.instance && TowerDefenseMapControl.instance.LineHasType(gridPos.y, TowerDefenseEnum.PLANTGRIDTYPE.WATER):
        sprite.SetFliters(["Zombie_duckytube", "Zombie_whitewater", "Zombie_whitewater2"], true)

func _physics_process(delta: float) -> void :
    super ._physics_process(delta)
    if Engine.is_editor_hint():
        return
    produceComponent.alive = !instance.hypnoses

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
            produceComponent.process_mode = Node.PROCESS_MODE_DISABLED

func ArmorDamagePointReach(armorName: String, stage: int) -> void :
    super .ArmorDamagePointReach(armorName, stage)
    if isAttack && HasShield() && stage > 0:
        sprite.SetFliters(["Zombie_outerarm_upper"], true)
        if !halfHp:
            sprite.SetFliters(["Zombie_outerarm_hand", "Zombie_outerarm_lower"], true)

func Hypnoses(time: float = -1) -> void :
    super .Hypnoses(time)
    produceComponent.produceType = "Sun"
