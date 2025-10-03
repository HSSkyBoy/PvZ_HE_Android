class_name TowerDefenseBrainSun extends Node2D

@onready var sprite: AdobeAnimateSprite = %SunSprite
@onready var moveComponent: MoveComponent = %MoveComponent
@onready var light: PointLight2D = %Light
@onready var dieDownTimer: Timer = %DieDownTimer

var sunNum: int = 25
var height: float = 500
var isCollect: bool = false
var die: bool = false
var movingMethod: TowerDefenseEnum.SUN_MOVING_METHOD = TowerDefenseEnum.SUN_MOVING_METHOD.LAND

var over: bool = false

var view: Viewport
var camera: Camera2D
var viewSize: Vector2

signal collect(num: int)

func Refresh() -> void :
    add_to_group("BrainSun", true)
    sprite.position = Vector2.ZERO
    sunNum = 25
    height = 500
    isCollect = false
    die = false
    over = false

    view = get_viewport()
    camera = view.get_camera_2d()
    viewSize = view.get_visible_rect().size

    light.visible = TowerDefenseManager.GetMapIsNight() && GameSaveManager.GetConfigValue("MapEffect")
    sprite.scale = Vector2.ZERO
    sprite.modulate.a = 1.0

    if is_instance_valid(dieDownTimer):
        dieDownTimer.start()

func Recycle() -> void :
    pass

func Init(_sunNum: int, _movingMethod: TowerDefenseEnum.SUN_MOVING_METHOD, _height: float = 0.0, velocity: Vector2 = Vector2.ZERO, gravity: float = 0.0, moverStopTime: float = -1):
    sunNum = _sunNum
    movingMethod = _movingMethod
    height = _height

    match movingMethod:
        TowerDefenseEnum.SUN_MOVING_METHOD.LAND:
            moveComponent.SetVelocity(velocity)
        TowerDefenseEnum.SUN_MOVING_METHOD.GRAVITY:
            moveComponent.SetVelocity(velocity)
            moveComponent.SetGravity(gravity)

    var size: float = sunNum / 25.0
    var tween = create_tween()
    tween.tween_property(sprite, "scale", Vector2.ONE * size, 0.1).from(Vector2.ZERO)
    tween.finished.connect(Collection)
    if moverStopTime != -1:
        await get_tree().create_timer(moverStopTime, false).timeout
        moveComponent.MoveClear()

func _ready() -> void :
    collect.connect(TowerDefenseManager.AddSun)
    view = get_viewport()
    camera = view.get_camera_2d()
    viewSize = view.get_visible_rect().size
    sprite.SetAnimation("Idle", true)

@warning_ignore("unused_parameter")
func _input(event: InputEvent) -> void :
    if Geometry2D.is_point_in_circle(get_global_mouse_position(), sprite.global_position, 40 * scale.x):
        Collection()

@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void :






    if !over:
        if sprite.position.y > height:
            moveComponent.MoveClear()
            sprite.position.y = height
            over = true

func Collection() -> void :
    if die:
        return
    if isCollect:
        return
    AudioManager.AudioPlay("Sun", AudioManagerEnum.TYPE.SFX)
    moveComponent.MoveClear()
    isCollect = true
    remove_from_group("BrainSun")
    var cameraPos: Vector2 = camera.global_position
    var tween = create_tween()
    tween.set_ease(Tween.EASE_OUT)
    tween.set_trans(Tween.TRANS_CUBIC)
    tween.tween_property(sprite, "global_position", cameraPos + Vector2(32.0, 32.0), 1.0)
    await tween.finished
    collect.emit( - sunNum)
    tween = create_tween()
    tween.tween_property(sprite, "modulate:a", 0.0, 0.25)
    await tween.finished
    Destroy()

func DieDown() -> void :
    if isCollect:
        return
    moveComponent.MoveClear()
    remove_from_group("BrainSun")
    die = true
    var tween = create_tween()
    tween.set_ease(Tween.EASE_OUT)
    tween.set_trans(Tween.TRANS_CUBIC)
    tween.tween_property(sprite, "modulate:a", 0.0, 0.25)
    await tween.finished
    Destroy()

func Destroy() -> void :
    ObjectManager.PoolPush(ObjectManagerConfig.OBJECT.SUN_BRAIN, self)
