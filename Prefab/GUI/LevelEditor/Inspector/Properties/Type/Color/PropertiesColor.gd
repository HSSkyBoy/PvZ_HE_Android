class_name PropertiesColor extends PropertiesBase

@onready var colorPickerButton: ColorPickerButton = %ColorPickerButton

signal value_changed(_value: Color)

var value: Color = Color.BLACK:
    set(_value):
        if is_node_ready():
            value = _value
            colorPickerButton.color_changed.disconnect(ValueChange)
            colorPickerButton.color = value
            colorPickerButton.color_changed.connect(ValueChange)

func _ready() -> void :
    value = colorPickerButton.color

func ValueChange(_value: Color):
    value = colorPickerButton.color
    value_changed.emit(value)

func CanSetValue() -> bool:
    return !colorPickerButton.has_focus()

func GetType() -> String:
    return "Color"
