@tool
extends TowerDefenseZombie

@onready var headState: StateChart = %HeadStateChart

@onready var fireComponent: FireComponent = %FireComponent

@export var fireInterval: float = 1.5
@export var fireNum: int = 1

var currentFireNum: int = 0

var halfHp: bool = false
var isAttack: bool = false

func _ready() -> void :
    super ._ready()
    if Engine.is_editor_hint():
        return

    fireComponent.fireInterval = fireInterval

    sprite.head.animeCompleted.connect(HeadAnimeCompleted)
    sprite.head.animeEvent.connect(AnimeEvent)

    if TowerDefenseMapControl.instance && TowerDefenseMapControl.instance.LineHasType(gridPos.y, TowerDefenseEnum.PLANTGRIDTYPE.WATER):
        sprite.SetFliters(["Zombie_duckytube", "Zombie_whitewater", "Zombie_whitewater2"], true)

func _physics_process(delta: float) -> void :
    if Engine.is_editor_hint():
        return
    super ._physics_process(delta)
    fireComponent.fireInterval = fireInterval

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
            headState.process_mode = Node.PROCESS_MODE_DISABLED

func ArmorDamagePointReach(armorName: String, stage: int) -> void :
    super .ArmorDamagePointReach(armorName, stage)
    if isAttack && HasShield() && stage > 0:
        sprite.SetFliters(["Zombie_outerarm_upper"], true)
        if !halfHp:
            sprite.SetFliters(["Zombie_outerarm_hand", "Zombie_outerarm_lower"], true)

func HeadIdleEntered() -> void :
    sprite.head.SetAnimation("HeadIdle", true, 0.5)
    fireComponent.alive = true

@warning_ignore("unused_parameter")
func HeadIdleProcessing(delta: float) -> void :
    sprite.head.timeScale = timeScale

    if global_position.x <= groundRight && fireComponent.CanFire("SnowPea", TowerDefenseEnum.CHARACTER_COLLISION_FLAGS.GROUND_CHARACTRE):
        headState.send_event("ToAttack")
        return

func HeadIdleExited() -> void :
    super .IdleExited()

func HeadAttackEntered() -> void :
    fireComponent.Refresh()
    sprite.head.SetAnimation("HeadFire", true, 0.2)

@warning_ignore("unused_parameter")
func HeadAttackProcessing(delta: float) -> void :
    sprite.head.timeScale = timeScale * 2.0

func HeadAttackExited() -> void :
    pass

@warning_ignore("unused_parameter")
func AnimeEvent(command: String, argument: Variant) -> void :
    super .AnimeEvent(command, argument)
    match command:
        "fire":
            AudioManager.AudioPlay("ProjectileThrow", AudioManagerEnum.TYPE.SFX)
            var projectile: TowerDefenseProjectile = fireComponent.CreateProjectile(0, Vector2(-300, 0), "SnowPea", TowerDefenseEnum.CHARACTER_COLLISION_FLAGS.GROUND_CHARACTRE, camp, Vector2.ZERO)
            projectile.gridPos = gridPos
            projectile.scale.x = - scale.x
            currentFireNum += 1
            if currentFireNum == fireNum:
                currentFireNum = 0
            else:
                sprite.head.SetAnimation("HeadFire", true, 0.1)

func HeadAnimeCompleted(clip: String) -> void :
    match clip:
        "HeadFire":
            if currentFireNum == 0:
                headState.send_event("ToIdle")
