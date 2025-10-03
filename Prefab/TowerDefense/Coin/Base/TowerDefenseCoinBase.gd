@tool
class_name TowerDefenseCoinBase extends TowerDefenseGroundItemBase

@onready var spriteNode: Node2D = %SpriteNode
@onready var moveComponent: MoveComponent = %MoveComponent

@export var fallAudio: String = "CoinFall"
@export var pickAudio: String = "CoinPick"
@export var num: int = 10
var height: float = 500
var isCollect: bool = false
var die: bool = false

var disabledInput: bool = false

var over: bool = false

var view: Viewport
var camera: Camera2D
var viewSize: Vector2

var autoCollect: bool = false

@export_enum("Silver", "Gold", "Diamond") var coinObjectId: int

signal collect(_num: int)

func Refresh() -> void :
    add_to_group("Coin", true)
    spriteNode.position = Vector2.ZERO
    spriteNode.modulate.a = 1.0
    height = 0.0
    isCollect = false
    die = false
    disabledInput = false
    over = false

    view = get_viewport()
    camera = view.get_camera_2d()
    viewSize = view.get_visible_rect().size

func Recycle() -> void :
    pass

func Init(_height: float = 0.0, _velocity: Vector2 = Vector2.ZERO, _gravity: float = 0.0):
    height = _height

    moveComponent.SetVelocity(_velocity)
    moveComponent.SetGravity(_gravity)

    await get_tree().physics_frame
    autoCollect = GameSaveManager.GetFeatureValue("CoinCollect")
    if autoCollect:
        get_tree().create_timer(0.5, false).timeout.connect(Collection)

func _ready() -> void :
    if Engine.is_editor_hint():
        return
    super ._ready()
    collect.connect(TowerDefenseManager.AddCoin)
    view = get_viewport()
    camera = view.get_camera_2d()
    viewSize = view.get_visible_rect().size
    AudioManager.AudioPlay(fallAudio, AudioManagerEnum.TYPE.SFX)

@warning_ignore("unused_parameter")
func _input(event: InputEvent) -> void :
    if Geometry2D.is_point_in_circle(get_global_mouse_position(), spriteNode.global_position, 30 * scale.x):
        Collection()

@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void :
    if Engine.is_editor_hint():
        return
    if autoCollect:
        return

    if camera:
        if !camera.get_viewport_rect().has_point(spriteNode.global_position):
            var cameraPos: Vector2 = camera.global_position
            spriteNode.global_position.x = clamp(spriteNode.global_position.x, cameraPos.x + 40, cameraPos.x + viewSize.x - 40)
            spriteNode.global_position.y = clamp(spriteNode.global_position.y, cameraPos.y + 40, cameraPos.y + viewSize.y - 40)

    if !over:
        if spriteNode.position.y > height:
            moveComponent.MoveClear()
            spriteNode.position.y = height
            over = true

func Collection() -> void :
    if die:
        return
    if isCollect:
        return
    if !GameSaveManager.GetFeatureValue("Shop"):
        var broadcastConfig: BroadCastConfig = BroadCastConfig.new()
        broadcastConfig.broadCastString = "SHOP_OPEN"
        broadcastConfig.broadCastTime = 7.5
        BroadCastManager.BroadCastAdd(broadcastConfig)
        GameSaveManager.SetFeatureValue("Shop", true)
        GameSaveManager.Save()
    AudioManager.AudioPlay(pickAudio, AudioManagerEnum.TYPE.SFX)
    moveComponent.MoveClear()
    isCollect = true
    TowerDefenseManager.coinBank.Show()
    remove_from_group("Coin")
    var cameraPos: Vector2 = camera.global_position
    var tween = create_tween()
    tween.set_ease(Tween.EASE_OUT)
    tween.set_trans(Tween.TRANS_CUBIC)
    tween.tween_property(spriteNode, "global_position", cameraPos + Vector2(120.0, 580), 1.0)
    await tween.finished
    collect.emit(num)
    tween = create_tween()
    tween.tween_property(spriteNode, "modulate:a", 0.0, 0.25)
    await tween.finished
    Destroy()

func DieDown() -> void :
    if isCollect:
        return
    moveComponent.MoveClear()
    remove_from_group("Coin")
    die = true
    var tween = create_tween()
    tween.set_ease(Tween.EASE_OUT)
    tween.set_trans(Tween.TRANS_CUBIC)
    tween.tween_property(spriteNode, "modulate:a", 0.0, 0.25)
    await tween.finished
    Destroy()

func Destroy() -> void :
    match coinObjectId:
        0:
            ObjectManager.PoolPush(ObjectManagerConfig.OBJECT.COIN_SILVER, self)
        1:
            ObjectManager.PoolPush(ObjectManagerConfig.OBJECT.COIN_GOLD, self)
        2:
            ObjectManager.PoolPush(ObjectManagerConfig.OBJECT.COIN_DIAMOND, self)
