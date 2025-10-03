class_name PropertiesString extends PropertiesBase

@onready var lineEdit: LineEdit = %LineEdit

signal value_changed(_value: String)

var value: String = "":
    set(_value):
        if is_node_ready():
            value = _value
            if CanSetValue():
                lineEdit.text_changed.disconnect(ValueChange)
                lineEdit.text = value
                lineEdit.text_changed.connect(ValueChange)

func _ready() -> void :
    value = lineEdit.text

func ValueChange(_value: String):
    value = lineEdit.text
    value_changed.emit(value)

func CanSetValue() -> bool:
    return !lineEdit.has_focus()

func GetType() -> String:
    return "String"
