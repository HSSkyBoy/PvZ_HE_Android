@tool
extends TowerDefensePlant

@onready var collisionShape2D2: CollisionShape2D = %CollisionShape2D2
@onready var collisionShape2D3: CollisionShape2D = %CollisionShape2D3


@onready var fireComponent: FireComponent = %FireComponent

@export var fireInterval: float = 1.5
@export var fireNum: int = 1

var currentFireNum: int = 0
var projectileName: String = "PeaDefault"

func _ready() -> void :
    if Engine.is_editor_hint():
        return
    super ._ready()
    fireComponent.fireInterval = fireInterval

    sprite.head1.animeCompleted.connect(HeadAnimeCompleted)
    sprite.head1.animeEvent.connect(AnimeEvent)

    collisionShape2D2.position.y = TowerDefenseManager.GetMapGridSize().y
    collisionShape2D3.position.y = - TowerDefenseManager.GetMapGridSize().y

func _physics_process(delta: float) -> void :
    if Engine.is_editor_hint():
        return
    super ._physics_process(delta)
    fireComponent.fireInterval = fireInterval

func IdleEntered() -> void :
    sprite.head1.SetAnimation("HeadIdle1", true, 0.5)
    sprite.head2.SetAnimation("HeadIdle2", true, 0.5)
    sprite.head3.SetAnimation("HeadIdle3", true, 0.5)
    fireComponent.alive = true

@warning_ignore("unused_parameter")
func IdleProcessing(delta: float) -> void :
    super .IdleProcessing(delta)
    sprite.head1.timeScale = timeScale
    sprite.head2.timeScale = timeScale
    sprite.head3.timeScale = timeScale

    if fireComponent.CanFire(projectileName):
        state.send_event("ToAttack")
        return

func IdleExited() -> void :
    pass

func AttackEntered() -> void :
    fireComponent.Refresh()
    sprite.head1.SetAnimation("HeadFire1", true, 0.2 * (fireInterval + 4.5) / 6.0)
    sprite.head2.SetAnimation("HeadFire2", true, 0.2 * (fireInterval + 4.5) / 6.0)
    sprite.head3.SetAnimation("HeadFire3", true, 0.2 * (fireInterval + 4.5) / 6.0)

@warning_ignore("unused_parameter")
func AttackProcessing(delta: float) -> void :
    sprite.head1.timeScale = timeScale * 2.0 * (1.75 / (fireInterval + 0.25))
    sprite.head2.timeScale = timeScale * 2.0 * (1.75 / (fireInterval + 0.25))
    sprite.head3.timeScale = timeScale * 2.0 * (1.75 / (fireInterval + 0.25))

func AttackExited() -> void :
    pass

@warning_ignore("unused_parameter")
func AnimeEvent(command: String, argument: Variant) -> void :
    super .AnimeEvent(command, argument)
    match command:
        "fire":
            AudioManager.AudioPlay("ProjectileThrow", AudioManagerEnum.TYPE.SFX)
            var projectileUp: TowerDefenseProjectile = fireComponent.CreateProjectile(0, Vector2(300, 0), projectileName, -1, camp, Vector2.ZERO)
            if gridPos.y > 1:
                projectileUp.gridPos = gridPos + Vector2i(0, -1)
                projectileUp.moveTween = create_tween()
                projectileUp.moveTween.set_ease(Tween.EASE_OUT)
                projectileUp.moveTween.set_trans(Tween.TRANS_QUAD)
                projectileUp.moveTween.tween_property(projectileUp, ^"global_position:y", projectileUp.global_position.y - TowerDefenseManager.GetMapGridSize().y, 0.25)
            else:
                projectileUp.gridPos = gridPos
                projectileUp.global_position -= Vector2(25, 0)
            projectileUp.checkAll = true

            var projectileCenter: TowerDefenseProjectile = fireComponent.CreateProjectile(0, Vector2(300, 0), projectileName, -1, camp, Vector2.ZERO)
            projectileCenter.gridPos = gridPos

            var projectileDown: TowerDefenseProjectile = fireComponent.CreateProjectile(0, Vector2(300, 0), projectileName, -1, camp, Vector2.ZERO)
            if gridPos.y < TowerDefenseManager.GetMapGridNum().y:
                projectileDown.gridPos = gridPos + Vector2i(0, 1)
                projectileDown.moveTween = create_tween()
                projectileDown.moveTween.set_ease(Tween.EASE_OUT)
                projectileDown.moveTween.set_trans(Tween.TRANS_QUAD)
                projectileDown.moveTween.tween_property(projectileDown, ^"global_position:y", projectileDown.global_position.y + TowerDefenseManager.GetMapGridSize().y, 0.25)
            else:
                projectileDown.gridPos = gridPos
                projectileDown.global_position -= Vector2(25, 0)
            if fireComponent.CanFire(projectileName):
                currentFireNum = 0
                sprite.head1.SetAnimation("HeadFire1", true, 0.2 * (fireInterval + 4.5) / 6.0)
                sprite.head2.SetAnimation("HeadFire2", true, 0.2 * (fireInterval + 4.5) / 6.0)
                sprite.head3.SetAnimation("HeadFire3", true, 0.2 * (fireInterval + 4.5) / 6.0)
                return
            projectileDown.checkAll = true

            currentFireNum += 1
            if currentFireNum == fireNum:
                currentFireNum = 0
            else:
                sprite.head1.SetAnimation("HeadFire1", true, 0.1 * (fireInterval + 4.5) / 6.0)
                sprite.head2.SetAnimation("HeadFire2", true, 0.1 * (fireInterval + 4.5) / 6.0)
                sprite.head3.SetAnimation("HeadFire3", true, 0.1 * (fireInterval + 4.5) / 6.0)

func HeadAnimeCompleted(clip: String) -> void :
    match clip:
        "HeadFire1":
            if currentFireNum == 0:
                Idle()
