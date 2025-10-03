class_name PropertiesArrayVector2 extends PropertiesBase

@onready var prefab: HBoxContainer = %Prefab
@onready var root: VBoxContainer = %Root
@onready var addButton: Button = %AddButton

signal value_changed(_value: Array[Vector2])

var value: Array[Vector2] = []:
    set(_value):
        value = _value
        if is_node_ready():
            _update_ui()

func _ready() -> void :
    _update_ui()

    addButton.pressed.connect(_on_add_button_pressed)

func _update_ui():

    for child in root.get_children():
        child.queue_free()


    for i in range(value.size()):
        var box = prefab.duplicate()
        box.get_node("IndexLabel").text = str(i)


        var spinBoxContainer = box.get_child(1)
        var spinBoxX = spinBoxContainer.get_node("SpinBoxX")
        var spinBoxY = spinBoxContainer.get_node("SpinBoxY")


        spinBoxX.value = value[i].x
        spinBoxY.value = value[i].y


        spinBoxX.value_changed.connect(_on_value_change_x.bind(i))
        spinBoxY.value_changed.connect(_on_value_change_y.bind(i))


        var removeButton = box.get_node("RemoveButton")
        removeButton.pressed.connect(_on_remove_button_pressed.bind(i))

        box.visible = true
        root.add_child(box)

func _on_add_button_pressed():

    value.append(Vector2.ZERO)
    _update_ui()
    _emit_value_changed()

func _on_remove_button_pressed(index: int):
    print("remove_button_pressed", index)

    if index < value.size():
        value.remove_at(index)
        _update_ui()
        _emit_value_changed()

func _on_value_change_x(_value: float, index: int):
    if index < value.size():
        value[index].x = _value
        _emit_value_changed()

func _on_value_change_y(_value: float, index: int):
    if index < value.size():
        value[index].y = _value
        _emit_value_changed()

func _emit_value_changed():
    value_changed.emit(value)

func CanSetValue() -> bool:
    for child in root.get_children():
        var spinBoxContainer = child.get_child(1)
        var spinBoxX = spinBoxContainer.get_node("SpinBoxX")
        var spinBoxY = spinBoxContainer.get_node("SpinBoxY")
        var removeButton = child.get_node("RemoveButton")
        if spinBoxX.get_line_edit().has_focus() or spinBoxY.get_line_edit().has_focus() or removeButton.has_focus():
            return false
    return true

func GetType() -> String:
    return "ArrayVector2"
