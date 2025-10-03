@tool
class_name TutorialConfig extends Resource

@export var data: JSON:
    set(_data):
        data = _data
        Init()
        notify_property_list_changed()
@export var saveKey: String = ""
@export var step: Array[TutorialStepConfig]

func Init() -> void :
    saveKey = ""
    step.clear()
    if is_instance_valid(data):
        Load(data.data)

@warning_ignore("shadowed_variable")
func Load(_data: Dictionary) -> void :
    saveKey = _data.get("SaveKey", "")
    for stepData: Dictionary in _data.get("Step", []):
        var stepConfig = TutorialStepConfig.new()
        stepConfig.Init(stepData)
        step.append(stepConfig)

func GetTutorialStep(_step: int) -> TutorialStepConfig:
    return step[_step]

func GetStepNum() -> int:
    return step.size()
