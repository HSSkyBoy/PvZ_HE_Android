class_name PropertiesInt extends PropertiesBase

@onready var spinBox: SpinBox = %SpinBox

signal value_changed(_value: int)

var value: int = 0:
    set(_value):
        if is_node_ready():
            value = _value
            spinBox.value_changed.disconnect(ValueChange)
            spinBox.value = value
            spinBox.value_changed.connect(ValueChange)

func _ready() -> void :
    @warning_ignore("narrowing_conversion")
    value = spinBox.value

func ValueChange(_value: int):
    @warning_ignore("narrowing_conversion")
    value = spinBox.value
    value_changed.emit(value)

func CanSetValue() -> bool:
    return !spinBox.get_line_edit().has_focus()

func GetType() -> String:
    return "Int"
