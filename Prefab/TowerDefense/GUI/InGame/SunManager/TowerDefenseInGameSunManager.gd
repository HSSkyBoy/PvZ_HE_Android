class_name TowerDefenseInGameSunManager extends Node2D

@export var spawnInterval: float = 25.0
@export var spawnNum: int = 25
@export var movingMethod: TowerDefenseEnum.SUN_MOVING_METHOD = TowerDefenseEnum.SUN_MOVING_METHOD.LAND
@export var isRunning: bool = false

var config: TowerDefenseLevelSunManagerConfig
var timer: float = 0.0

func Init(_config: TowerDefenseLevelSunManagerConfig):
    config = _config
    TowerDefenseManager.SetSun(config.begin)
    spawnInterval = config.spawnInterval
    spawnNum = config.spawnNum
    movingMethod = config.movingMethod
    timer = spawnInterval - 6.0

@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void :
    var mapControl: TowerDefenseMapControl = TowerDefenseManager.GetMapControl()
    if isRunning && config.open && ( !mapControl.config.isNight || mapControl.config.useSunFall):
        if timer < spawnInterval:
            timer += delta
        else:
            SunCreate()
            timer = 0.0

func Running() -> void :
    isRunning = true

func SunCreate() -> TowerDefenseSun:
    var posX: float = randf_range(TowerDefenseManager.GetMapGridBeginPos().x, TowerDefenseManager.GetMapGroundRight())
    var height: float = randf_range(TowerDefenseManager.GetMapGridBeginPos().y + 200, TowerDefenseManager.GetMapGroundDown() - TowerDefenseManager.GetMapGridBeginPos().y)
    var sun: TowerDefenseSun = TowerDefenseManager.SunCreate(Vector2(posX, TowerDefenseManager.GetMapGridBeginPos().y - 100), spawnNum, movingMethod, height, Vector2(0, 100.0))
    return sun
