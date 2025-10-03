@tool
class_name GeneralProgressMeter extends Control

const GENERAL_PROGRESS_FLAG: PackedScene = preload("res://Prefab/GUI/ProgressMeter/ProgressFlag/GeneralProgressFlag.tscn")

@onready var progressBar: TextureProgressBar = %ProgressBar
@onready var headTexture: TextureRect = %HeadTexture
@onready var flagContainer: HBoxContainer = %FlagContainer

@export var waveNum: int = 1:
    set(_waveNum):
        waveNum = _waveNum
        if Engine.is_editor_hint():
            FlagRefresh()

@export var waveInterval: int = 1:
    set(_waveInterval):
        waveInterval = _waveInterval
        if Engine.is_editor_hint():
            FlagRefresh()

@export var previewWave: int = 1:
    set(_previewWave):
        previewWave = _previewWave
        previewWave = clamp(previewWave, 0, waveNum)
        if previewWave % waveInterval == 0:
            for flag: GeneralProgressFlag in flagList:
                flag.reach = false
            @warning_ignore("integer_division")
            for flagId in range(previewWave / waveInterval):
                flagList[flagId].reach = true

var flagList: Array[GeneralProgressFlag] = []

func Init(_waveNum: int, _waveInterval: int):
    await get_tree().create_timer(0.1, false).timeout
    waveNum = _waveNum
    waveInterval = _waveInterval
    FlagRefresh()

@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void :
    headTexture.position.x = 140.0 - 150.0 * progressBar.value / progressBar.max_value
    progressBar.value = lerp(progressBar.value, progressBar.max_value * float(previewWave) / float(waveNum), 0.1 * delta)

func SetWaveCurrent(waveCurrent: int):
    previewWave = waveCurrent

func FlagRefresh():
    if !flagContainer:
        return
    for flag in flagContainer.get_children():
        if flag:
            flag.queue_free()
    flagList.clear()
    @warning_ignore("integer_division")
    var flagNum: int = floor(waveNum / waveInterval)

    flagContainer.add_theme_constant_override("separation", floor(150.0 / flagNum))
    for flagId in range(flagNum):
        var flag: GeneralProgressFlag = GENERAL_PROGRESS_FLAG.instantiate() as GeneralProgressFlag
        flagContainer.add_child(flag)
        flagList.insert(0, flag)
