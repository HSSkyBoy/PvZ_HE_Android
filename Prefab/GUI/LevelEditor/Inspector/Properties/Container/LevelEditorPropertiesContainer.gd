class_name LevelEditorPropertiesContainer extends VBoxContainer

@onready var innerContainer: HBoxContainer = %InnerContainer
@onready var outerContainer: VBoxContainer = %OuterContainer

@onready var keyLabel: Label = %KeyLabel
@onready var refreshButton: Button = %RefreshButton

var propertyEditor: PropertiesBase

var restValue: Variant:
    set(_restValue):
        restValue = _restValue
        refreshButton.visible = restValue != null

@warning_ignore("unused_parameter")
func _process(delta: float) -> void :
    if restValue != null:
        if propertyEditor:
            refreshButton.visible = propertyEditor.GetValue() != restValue
