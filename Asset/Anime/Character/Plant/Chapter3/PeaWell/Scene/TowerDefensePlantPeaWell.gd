@tool
extends TowerDefensePlant

@onready var fireComponent: FireComponent = %FireComponent

@export var fireInterval: float = 3.0

func _ready() -> void :
    if Engine.is_editor_hint():
        return
    super ._ready()
    fireComponent.fireInterval = fireInterval

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
    if !TowerDefenseManager.currentControl || !TowerDefenseManager.currentControl.isGameRunning:
        return
    if fireComponent.timer <= 0:
        for i in 36:
            var dir: Vector2 = Vector2.from_angle(deg_to_rad(i * 10))
            var projectile = FireComponent.CreateProjectilePosition(self, null, GetGroundHeight(global_position.y), global_position, dir * 200.0, "PeaDefault", -1, camp)
            projectile.checkAll = true
            projectile.projectileBodyNode.rotation_degrees = i * 10
        fireComponent.Refresh()

func IdleExited() -> void :
    super .IdleExited()
