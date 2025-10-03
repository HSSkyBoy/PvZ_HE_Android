@tool
extends TowerDefensePlant

@onready var fireComponent: FireComponent = %FireComponent
@onready var attackComponent: AttackComponent = %AttackComponent
@onready var checkShape: CollisionShape2D = %CheckShape
@onready var fireParticles: GPUParticles2D = %FireParticles

@export var fireInterval: float = 1.5
@export var eventList: Array[TowerDefenseCharacterEventBase]

func _ready() -> void :
    if Engine.is_editor_hint():
        return
    super._ready()
    fireComponent.fireInterval = fireInterval
    checkShape.shape.b.x = TowerDefenseManager.GetMapGridSize().x * 4.5

func _physics_process(delta: float) -> void :
    if Engine.is_editor_hint():
        return
    super._physics_process(delta)
    fireComponent.fireInterval = fireInterval

func IdleEntered() -> void :
    if Engine.is_editor_hint():
        return
    super.IdleEntered()
    fireComponent.alive = true

@warning_ignore("unused_parameter")
func IdleProcessing(delta: float) -> void :
    super.IdleProcessing(delta)

    if fireComponent.timer <= 0 && attackComponent.CanAttack(true):
        state.send_event("ToAttack")
        return

func IdleExited() -> void :
    super.IdleExited()

func AttackEntered() -> void :
    fireComponent.Refresh()
    sprite.SetAnimation("Fire", true, 0.2)

@warning_ignore("unused_parameter")
func AttackProcessing(delta: float) -> void :
    sprite.timeScale = timeScale * 3.0

func AttackExited() -> void :
    pass

@warning_ignore("unused_parameter")
func AnimeEvent(command: String, argument: Variant) -> void :
    super.AnimeEvent(command, argument)
    match command:
        "fire":
            fireParticles.restart()
            AudioManager.AudioPlay("Fume", AudioManagerEnum.TYPE.SFX)
            var projectile = fireComponent.CreateProjectile(0, Vector2(600, 0), "WinterMelonLine", camp, Vector2.ZERO)
            projectile.gridPos = gridPos
            var targetList = attackComponent.GetTargetList()
            for target: TowerDefenseCharacter in targetList:
                for event in eventList:
                    event.Execute(target.global_position, target)

func AnimeCompleted(clip: String) -> void :
    super.AnimeCompleted(clip)
    match clip:
        "Fire":
            Idle()
