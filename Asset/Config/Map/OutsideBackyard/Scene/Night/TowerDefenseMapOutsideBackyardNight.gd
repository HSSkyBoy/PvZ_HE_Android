extends TowerDefenseMap

@onready var backyardFloor: Sprite2D = %BackyardFloor
@onready var backyardDoor: Sprite2D = %BackyardDoor
@onready var pool1: Polygon2D = %Pool1
@onready var pool2: Polygon2D = %Pool2

@export var waveSpeed: float = 0.1
var waveTimer: float = 0.0

func _physics_process(delta: float) -> void :
    waveTimer += delta * waveSpeed
    pool1.material.set_shader_parameter("timer", waveTimer)
    pool2.material.set_shader_parameter("timer", waveTimer)

func EnterRoom(character: TowerDefenseCharacter) -> void :
    var tween = create_tween()
    tween.tween_property(character, ^"global_position:y", 375.0, abs(global_position.y - 375) / 200.0)
    await tween.finished
    character.timeScaleInit *= 2
    backyardDoor.visible = true
    backyardFloor.visible = true
    await get_tree().create_timer(3.0, false).timeout
