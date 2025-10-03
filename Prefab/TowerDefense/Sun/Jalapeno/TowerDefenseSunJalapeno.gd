class_name TowerDefenseSunJalapeno extends Node2D

@onready var sprite: AdobeAnimateSprite = %SunSprite
@onready var moveComponent: MoveComponent = %MoveComponent
@onready var light: PointLight2D = %Light
@onready var dieDownTimer: Timer = %DieDownTimer

@export var allEventList: Array[TowerDefenseCharacterEventBase] = []

var sunNum: int = 25
var height: float = 500
var isCollect: bool = false
var die: bool = false
var movingMethod: TowerDefenseEnum.SUN_MOVING_METHOD = TowerDefenseEnum.SUN_MOVING_METHOD.LAND

var over: bool = false

var view: Viewport
var camera: Camera2D
var viewSize: Vector2

var autoCollect: bool = false

var gridPos: Vector2i

signal collect(num: int)

func Refresh() -> void :
    add_to_group("Sun", true)
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

    gridPos = Vector2.ZERO

    if is_instance_valid(dieDownTimer):
        dieDownTimer.start()

    autoCollect = GameSaveManager.GetFeatureValue("SunCollect")



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
    if isCollect:
        return
    if Geometry2D.is_point_in_circle(get_global_mouse_position(), sprite.global_position, 40 * scale.x):
        Collection()

@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void :






    if !over:
        if sprite.position.y > height:
            moveComponent.MoveClear()
            sprite.position.y = height
            over = true

func Explode() -> void :
    var eventList: Array[TowerDefenseCharacterEventBase] = []
    var explodeEvent: TowerDefenseCharacterEventExplodeHurt = TowerDefenseCharacterEventExplodeHurt.new()
    explodeEvent.burns = true
    explodeEvent.num = sunNum * 10.0
    explodeEvent.type = "Bomb"
    eventList.append(explodeEvent)
    TowerDefenseExplode.CreateExplodeLine(gridPos.y, eventList, [], TowerDefenseEnum.CHARACTER_CAMP.PLANT, -1)
    TowerDefenseExplode.CreateExplodeLine(gridPos.y, allEventList, [], TowerDefenseEnum.CHARACTER_CAMP.ALL, -1)
    TowerDefenseCharacter.CreateJalapenoFire(gridPos)


func Collection() -> void :
    if die:
        return
    if isCollect:
        return
    Explode()
    AudioManager.AudioPlay("Sun", AudioManagerEnum.TYPE.SFX)
    moveComponent.MoveClear()
    isCollect = true
    remove_from_group("Sun")
    var cameraPos: Vector2 = camera.global_position
    var tween = create_tween()
    tween.set_ease(Tween.EASE_OUT)
    tween.set_trans(Tween.TRANS_CUBIC)
    tween.tween_property(sprite, "global_position", cameraPos + Vector2(32.0, 32.0), 1.0)
    await tween.finished
    collect.emit(sunNum)
    tween = create_tween()
    tween.tween_property(sprite, "modulate:a", 0.0, 0.25)
    await tween.finished
    Destroy()

func DieDown() -> void :
    if isCollect:
        return
    if !autoCollect:
        moveComponent.MoveClear()
        remove_from_group("Sun")
        die = true
        var tween = create_tween()
        tween.set_ease(Tween.EASE_OUT)
        tween.set_trans(Tween.TRANS_CUBIC)
        tween.tween_property(sprite, "modulate:a", 0.0, 0.25)
        await tween.finished
        Destroy()
    else:
        Collection()

func Destroy() -> void :
    ObjectManager.PoolPush(ObjectManagerConfig.OBJECT.SUN_JALAPENO, self)
