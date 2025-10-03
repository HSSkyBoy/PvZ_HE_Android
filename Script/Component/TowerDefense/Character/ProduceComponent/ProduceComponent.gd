class_name ProduceComponent extends ComponentBase

@onready var light: Array[PointLight2D] = [ %Light, %Light2]

@export_enum("Sun", "BrainSun", "JalaSun", "Coin") var produceType: String = "Sun"
@export var produceInterval: float = 25.0
@export var num: int = 25
@export var sunOnceMax: int = 50
@export var marker: Array[Marker2D]
var timer: float = 0.0

var parent: TowerDefenseCharacter

var currentTarget: TowerDefenseCharacter

func _ready() -> void :
    parent = get_parent()
    timer = produceInterval - randf_range(3.0, 6.0)

func _physics_process(delta: float) -> void :
    if !alive:
        return
    if !parent:
        return
    if parent.die:
        return
    if parent.instance.sleep:
        return
    if TowerDefenseManager.currentControl && !TowerDefenseManager.currentControl.isGameRunning:
        return
    for i in marker.size():
        light[i].global_position = marker[i].global_position
    if timer > produceInterval:
        timer -= produceInterval
        if TowerDefenseManager.GetMapIsNight() && GameSaveManager.GetConfigValue("MapEffect"):
            for i in marker.size():
                light[i].visible = true
                var tween = create_tween()
                tween.tween_property(light[i], ^"energy", 1.0, 1.5).from(0.0)
                tween.tween_property(light[i], ^"energy", 0.0, 0.5).from(1.0)
                tween.finished.connect(
                    func():
                        light[i].visible = false
                )
        await parent.Bright(0.0, 0.0, 0.5, 1.5, 0.5)
        if TowerDefenseManager.currentControl && !TowerDefenseManager.currentControl.isGameRunning:
            return
        if marker.size() > 0:
            for i in marker.size():
                Create(marker[i].global_position, num)
        else:
            Create(parent.global_position, num)
    else:
        timer += delta

func Create(pos: Vector2, _num: int) -> void :
    var createNum: int = _num
    match produceType:
        "Sun":
            while (createNum > sunOnceMax):
                parent.SunCreate(pos, sunOnceMax, TowerDefenseEnum.SUN_MOVING_METHOD.GRAVITY, Vector2(randf_range(-50.0, 50.0), -400.0), 980.0)
                createNum -= sunOnceMax
            parent.SunCreate(pos, createNum, TowerDefenseEnum.SUN_MOVING_METHOD.GRAVITY, Vector2(randf_range(-50.0, 50.0), -400.0), 980.0)
        "BrainSun":
            while (createNum > sunOnceMax):
                parent.BrainSunCreate(pos, sunOnceMax, TowerDefenseEnum.SUN_MOVING_METHOD.GRAVITY, Vector2(randf_range(-50.0, 50.0), -400.0), 980.0)
                createNum -= sunOnceMax
            parent.BrainSunCreate(pos, createNum, TowerDefenseEnum.SUN_MOVING_METHOD.GRAVITY, Vector2(randf_range(-50.0, 50.0), -400.0), 980.0)
        "JalaSun":
            while (createNum > sunOnceMax):
                parent.JalapenoSunCreate(pos, sunOnceMax, TowerDefenseEnum.SUN_MOVING_METHOD.GRAVITY, Vector2(randf_range(-50.0, 50.0), -400.0), 980.0)
                createNum -= sunOnceMax
            parent.JalapenoSunCreate(pos, createNum, TowerDefenseEnum.SUN_MOVING_METHOD.GRAVITY, Vector2(randf_range(-50.0, 50.0), -400.0), 980.0)
