class_name PropertiesVector4i extends PropertiesBase

@onready var spinBoxX1: SpinBox = %SpinBoxX1
@onready var spinBoxY1: SpinBox = %SpinBoxY1
@onready var spinBoxX2: SpinBox = %SpinBoxX2
@onready var spinBoxY2: SpinBox = %SpinBoxY2

signal value_changed(_value: Vector4i)

var value: Vector4i = Vector4i.ZERO:
    set(_value):
        if is_node_ready():
            value = _value
            spinBoxX1.value_changed.disconnect(ValueChange)
            spinBoxY1.value_changed.disconnect(ValueChange)
            spinBoxX2.value_changed.disconnect(ValueChange)
            spinBoxY2.value_changed.disconnect(ValueChange)
            spinBoxX1.value = value.x
            spinBoxY1.value = value.y
            spinBoxX2.value = value.z
            spinBoxY2.value = value.w
            spinBoxX1.value_changed.connect(ValueChange)
            spinBoxY1.value_changed.connect(ValueChange)
            spinBoxX2.value_changed.connect(ValueChange)
            spinBoxY2.value_changed.connect(ValueChange)

func _ready() -> void :
    @warning_ignore("narrowing_conversion")
    value = Vector4i(spinBoxX1.value, spinBoxY1.value, spinBoxX2.value, spinBoxY2.value)

func ValueChange(_value: float):
    @warning_ignore("narrowing_conversion")
    value = Vector4i(spinBoxX1.value, spinBoxY1.value, spinBoxX2.value, spinBoxY2.value)
    value_changed.emit(value)

func CanSetValue() -> bool:
    return !spinBoxX1.get_line_edit().has_focus() && !spinBoxY1.get_line_edit().has_focus() && !spinBoxX2.get_line_edit().has_focus() && !spinBoxY2.get_line_edit().has_focus()

func GetType() -> String:
    return "Vector4i"
