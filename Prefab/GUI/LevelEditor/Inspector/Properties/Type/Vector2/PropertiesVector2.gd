class_name PropertiesVector2 extends PropertiesBase

@onready var spinBoxX: SpinBox = %SpinBoxX
@onready var spinBoxY: SpinBox = %SpinBoxY

signal value_changed(_value: Vector2)

var value: Vector2 = Vector2.ZERO:
    set(_value):
        if is_node_ready():
            value = _value
            spinBoxX.value_changed.disconnect(ValueChange)
            spinBoxY.value_changed.disconnect(ValueChange)
            spinBoxX.value = value.x
            spinBoxY.value = value.y
            spinBoxX.value_changed.connect(ValueChange)
            spinBoxY.value_changed.connect(ValueChange)

func _ready() -> void :
    value = Vector2(spinBoxX.value, spinBoxY.value)

func ValueChange(_value: float):
    value = Vector2(spinBoxX.value, spinBoxY.value)
    value_changed.emit(value)

func CanSetValue() -> bool:
    return !spinBoxX.get_line_edit().has_focus() && !spinBoxY.get_line_edit().has_focus()

func GetType() -> String:
    return "Vector2"
