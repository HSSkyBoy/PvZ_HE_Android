class_name DialogBoxBase extends Control

signal close()

@export var pasue: bool = false
@export var aliveProcessMode: ProcessMode = PROCESS_MODE_PAUSABLE
@export var dragControl: Control

var isRoot: bool = false

var savePauseState: bool = false
var saveTimeScale: float = 1.0

var dragStart: bool = false
var isInDrag: bool = false
var savePos: Vector2 = Vector2.ZERO
var saveMousePos: Vector2 = Vector2.ZERO

@warning_ignore("unused_parameter")
func Init(data: Dictionary) -> void :
    pass

func _ready() -> void :
    saveTimeScale = Engine.time_scale
    Engine.time_scale = 1.0
    if pasue:
        savePauseState = get_tree().paused
        process_mode = PROCESS_MODE_ALWAYS
        get_tree().paused = true

    if dragControl:
        dragControl.gui_input.connect(DragInput)
        dragControl.mouse_entered.connect(
            func():
                isInDrag = true
        )
        dragControl.mouse_exited.connect(
            func():
                isInDrag = false
        )

@warning_ignore("unused_parameter")
func DragInput(event: InputEvent) -> void :
    if isInDrag:
        if Input.is_action_just_pressed("Press"):
            dragStart = true
            savePos = dragControl.global_position
            saveMousePos = get_global_mouse_position()
        if Input.is_action_just_released("Press"):
            dragStart = false

        if dragStart:
            dragControl.global_position = savePos + (get_global_mouse_position() - saveMousePos)

func ChildClose() -> void :
    process_mode = aliveProcessMode

func Close() -> void :
    Engine.time_scale = saveTimeScale
    if pasue:
        get_tree().paused = savePauseState
    close.emit()
    queue_free()

func DialogCreate(dialogName: String, _data: Dictionary = {}) -> DialogBoxBase:
    var dialog: DialogBoxBase = DialogManager.DIALOGS[dialogName].instantiate()
    dialog.close.connect(ChildClose)
    dialog.Init(_data)
    add_child(dialog)
    dialog.global_position = Vector2.ZERO
    return dialog
