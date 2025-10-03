@tool
extends TowerDefensePlant
const TOWER_DEFENSE_PROJECTILE_EFFECT_GROOM = preload("res://Prefab/ProjectileEffect/Groom/TowerDefenseProjectileEffectGroom.tscn")
@onready var fireComponent: FireComponent = %FireComponent
@onready var attackComponent: AttackComponent = %AttackComponent

@onready var collisionShape: CollisionShape2D = %CollisionShape

@export var fireInterval: float = 3.0

func _ready() -> void :
    if Engine.is_editor_hint():
        return
    super ._ready()
    fireComponent.fireInterval = fireInterval
    collisionShape.shape.size = TowerDefenseManager.GetMapGridSize() * 2.75

func _physics_process(delta: float) -> void :
    if Engine.is_editor_hint():
        return
    super ._physics_process(delta)
    fireComponent.fireInterval = fireInterval

func IdleEntered() -> void :
    if Engine.is_editor_hint():
        return
    super .IdleEntered()
    fireComponent.alive = true

@warning_ignore("unused_parameter")
func IdleProcessing(delta: float) -> void :
    super .IdleProcessing(delta)

    if attackComponent.CanAttack():
        state.send_event("ToAttack2")
        return

    if fireComponent.CanFire("GloomDefault"):
        state.send_event("ToAttack")
        return

func IdleExited() -> void :
    super .IdleExited()

func AttackEntered() -> void :
    fireComponent.Refresh()
    sprite.SetAnimation("Fire", true, 0.2)

@warning_ignore("unused_parameter")
func AttackProcessing(delta: float) -> void :
    sprite.timeScale = timeScale * 4.0 * (4.5 / (fireInterval + 1.5))

func AttackExited() -> void :
    pass

func Attack2Entered() -> void :
    fireComponent.Refresh()
    sprite.SetAnimation("Attack", true, 0.2 * (fireInterval + 3.0) / 6.0)

@warning_ignore("unused_parameter")
func Attack2Processing(delta: float) -> void :
    sprite.timeScale = timeScale * 0.75 * (4.5 / (fireInterval + 1.5))

func Attack2Exited() -> void :
    pass

@warning_ignore("unused_parameter")
func AnimeEvent(command: String, argument: Variant) -> void :
    super .AnimeEvent(command, argument)
    match command:
        "fire":
            AudioManager.AudioPlay("ProjectileThrow", AudioManagerEnum.TYPE.SFX)
            var projectile: TowerDefenseProjectile
            projectile = fireComponent.CreateProjectile(0, Vector2(300, 0), "GloomDefault", -1, camp, Vector2.ZERO)
            projectile.gridPos = gridPos
        "attack":
            var characterNode: Node2D = TowerDefenseManager.GetCharacterNode()
            var effect = TOWER_DEFENSE_PROJECTILE_EFFECT_GROOM.instantiate()
            effect.Init(gridPos, camp, config.collisionFlags)
            effect.global_position = global_position
            characterNode.add_child(effect)

func AnimeCompleted(clip: String) -> void :
    super .AnimeCompleted(clip)
    match clip:
        "Fire":
            Idle()
        "Attack":
            Idle()
