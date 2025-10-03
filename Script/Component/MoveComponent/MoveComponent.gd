class_name MoveComponent extends ComponentBase

@export var velocity: Vector2 = Vector2.ZERO
@export var gravity: float = 0.0
@export var moveScale: float = 1.0
var parent: Node2D

func _ready() -> void :
    parent = get_parent()

func _physics_process(delta) -> void :
    if gravity:
        velocity.y += gravity * delta * moveScale
    if velocity:
        parent.global_position += velocity * delta * moveScale

func SetVelocity(_velocity: Vector2 = Vector2.ZERO):
    velocity = _velocity

func SetGravity(_gravity: float = 0.0):
    gravity = _gravity

func MoveClear():
    velocity = Vector2.ZERO
    gravity = 0.0
