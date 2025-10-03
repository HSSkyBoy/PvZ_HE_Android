@tool
extends NinePatchButtonBase

@onready var nameChangeLine: LineEdit = %NameChangeLine

signal saveGroup(_id: int)
signal loadGroup(_id: int)

@export var id: int = 1

var pressSave: bool = false

func _ready() -> void :
    if Engine.is_editor_hint():
        return
    labelText.text = GameSaveManager.GetKeyValue("PacketGroupName%d" % id)

func SaveButtonPressed() -> void :
    saveGroup.emit(id)

func LoadButtonPressed() -> void :
    if !pressSave:
        pressSave = true
        await get_tree().create_timer(0.2, false).timeout
        if pressSave:
            loadGroup.emit(id)
            pressSave = false
    else:
        pressSave = false
        labelText.visible = false
        nameChangeLine.visible = true
        nameChangeLine.text = labelText.text
        nameChangeLine.grab_focus()

func NameChangeOver(toggledOn: bool) -> void :
    if !toggledOn:
        labelText.text = nameChangeLine.text
        GameSaveManager.SetKeyValue("PacketGroupName%d" % id, labelText.text)
        GameSaveManager.Save()
        labelText.visible = true
        nameChangeLine.visible = false
