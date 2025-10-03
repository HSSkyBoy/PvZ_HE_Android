@tool
class_name DragMenu extends Control

@export var alive: bool = true
@export var currentIndex: int = 0
@export_group("Setting")
@export var interval: float = 400.0
@export var alphaDecrease: float = 0.75
@export var scaleBase: Vector2 = Vector2.ONE * 1.5
@export var scaleDecrease: float = 0.5

var currentPos: Vector2 = Vector2.ZERO
var mousePress: bool = false
var mouseSavePos: Vector2 = Vector2.ZERO

@warning_ignore("unused_parameter")
func _ready() -> void :
    child_entered_tree.connect(SetChildPos)

@warning_ignore("unused_parameter")
func _input(event: InputEvent) -> void :
    if !alive:
        return
    if Input.is_action_just_pressed("Press"):
        mousePress = true
        mouseSavePos = get_viewport().get_mouse_position()

    if Input.is_action_just_released("Press"):
        mousePress = false

    if mousePress:
        currentPos.x = currentPos.x + (mouseSavePos.x - get_viewport().get_mouse_position().x) * 2.0
        currentIndex = clamp(round(currentPos.x / interval), 0, max(0, get_child_count() - 1))
        mouseSavePos = get_viewport().get_mouse_position()
    else:
        currentPos.x = currentIndex * interval

func _physics_process(delta: float) -> void :
    for i in range(get_child_count()):
        var child: Node2D = get_child(i)
        var toPos: Vector2 = Vector2((i - currentIndex) * interval, 0)
        if child is DragMenuSelectItem:
            child.button.disabled = mousePress && currentIndex != i || child.lock
        if mousePress:
            toPos = Vector2(i * interval - currentPos.x, 0)
        else:
            toPos = Vector2((i - currentIndex) * interval, 0)
        child.position = lerp(child.position, toPos, 5.0 * delta)
        var effectScale: float = abs(child.position.x) / interval
        child.modulate.a = clamp(1.0 - alphaDecrease * effectScale, 0.0, 1.0)
        child.scale = clamp(scaleBase - Vector2.ONE * scaleDecrease * effectScale, Vector2.ZERO, Vector2.ONE)

func SetChildPos(node: Node) -> void :
    var toPos: Vector2 = Vector2((get_child_count() - 1) * interval, 0)
    node.position = toPos

func SetPos(index: int) -> void :
    currentIndex = index
    currentPos.x = currentIndex * interval
    for i in range(get_child_count()):
        var child: Node2D = get_child(i)
        var toPos: Vector2 = Vector2((i - currentIndex) * interval, 0)
        child.position = toPos
