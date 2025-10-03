class_name PropertiesBool extends PropertiesBase

@onready var checkbox: CheckBox = %Checkbox

signal value_changed(_value: bool)

var value: bool = false:
    set(_value):
        if is_node_ready():
            value = _value
            checkbox.toggled.disconnect(ValueChange)
            checkbox.button_pressed = value
            checkbox.toggled.connect(ValueChange)

func _ready() -> void :
    value = checkbox.button_pressed

func ValueChange(_value: bool):
    if is_node_ready():
        value = checkbox.button_pressed
        value_changed.emit(value)

func CanSetValue() -> bool:
    return !checkbox.has_focus()

func GetType() -> String:
    return "Bool"
