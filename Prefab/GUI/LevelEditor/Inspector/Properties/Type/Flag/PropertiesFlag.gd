class_name PropertiesFlag extends PropertiesBase

@onready var checkBoxContainer: VBoxContainer = %CheckBoxContainer

signal value_changed(_value: int)

var checkBoxList: Array[CheckBox] = []

var hintDictionary: Dictionary = {}:
    set(_hintDictionary):
        if is_node_ready():
            hintDictionary = _hintDictionary
            for node in checkBoxContainer.get_children():
                node.queue_free()
            for hint: String in hintDictionary.keys():
                var checkBox = CheckBox.new()
                checkBox.text = hint
                checkBox.toggled.connect(ValueChange)
                checkBoxContainer.add_child(checkBox)
                checkBoxList.append(checkBox)

var value: int = 0:
    set(_value):
        if is_node_ready():
            value = _value
            if CanSetValue():
                for checkBoxId in range(checkBoxList.size()):
                    var checkBox: CheckBox = checkBoxList[checkBoxId]
                    checkBox.toggled.disconnect(ValueChange)
                    checkBox.button_pressed = (value & (1 << checkBoxId))
                    checkBox.toggled.connect(ValueChange)

func ValueChange(_value: bool):
    var getValue: int = 0
    for checkBoxId in range(checkBoxList.size()):
        var checkBox: CheckBox = checkBoxList[checkBoxId]
        if checkBox.button_pressed:
            getValue += (1 << checkBoxId)

    value = getValue
    value_changed.emit(value)

func CanSetValue() -> bool:
    return true

func GetType() -> String:
    return "Flag"
