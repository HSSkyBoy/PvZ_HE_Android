extends TowerDefenseMap

@onready var frontlawnFloor: Sprite2D = %FrontlawnFloor
@onready var frontlawnDoor: Sprite2D = %FrontlawnDoor
@onready var pool: Polygon2D = %Pool

@export var waveSpeed: float = 0.1
var waveTimer: float = 0.0

func _physics_process(delta: float) -> void :
    waveTimer += delta * waveSpeed
    pool.material.set_shader_parameter("timer", waveTimer)

func EnterRoom(character: TowerDefenseCharacter) -> void :
    var tween = create_tween()
    tween.set_parallel(true)
    tween.tween_property(character, ^"global_position:y", 375.0, abs(global_position.y - 375) / 200.0)
    tween.tween_property(character, ^"saveShadowPosition:y", 375.0 + 36.0, abs(global_position.y - 375) / 200.0)
    await tween.finished
    if is_instance_valid(character):
        character.timeScaleInit *= 2
    frontlawnDoor.visible = true
    frontlawnFloor.visible = true
    await get_tree().create_timer(3.0, false).timeout
