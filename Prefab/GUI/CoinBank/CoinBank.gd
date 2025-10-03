class_name CoinBank extends Control

@onready var coinBankTexture: NinePatchRect = %CoinBankTexture
@onready var coinNumLabel: Label = %CoinNumLabel

@export var num: int = 0:
    set(_num):
        num = _num
var numShow: float = 0.0:
    set(_numShow):
        if coinNumLabel:
            numShow = _numShow
            coinNumLabel.text = str(int(round(numShow)))

var timer: float = 0.0

func _ready() -> void :
    modulate.a = 0.0

@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void :
    if Global.debugCoinMax:
        num = 999999999
    numShow = num
    if timer > 0.0:
        timer -= delta
    else:
        if modulate.a > 0:
            modulate.a = lerp(modulate.a, 0.0, 5.0 * delta)

func Show(pos: Vector2 = Vector2(86, 557), still: bool = false) -> void :
    position = pos
    modulate.a = 1.0

    if !still:
        timer = 5.0
    else:
        timer = 10000000000.0

func Hide() -> void :
    timer = 0.0

func AddNum(_num: int) -> void :
    num += _num

func UseCoin(_num: int) -> void :
    num -= _num

func SetNum(_num: int) -> void :
    num = _num
