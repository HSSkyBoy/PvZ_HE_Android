extends Node

const BROAD_CAST_FLOAT: PackedScene = preload("uid://c43r0mavkmqxl")

@onready var broad = %Broad
@onready var broadCastLabel = %BroadCastLabel
@onready var broadCastTimer = %BroadCastTimer
@onready var floatBroaderNode: Control = %FloatBroaderNode

signal broadCastOver()

var broadCastList: Array[BroadCastConfig]
var stay: bool = false

func _ready() -> void :
    @warning_ignore("unused_parameter")
    SceneManager.sceneChange.connect(
        func(sceneName: String):
            BraodCastClear()
    )

@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void :
    if broadCastList.size() > 0:
        if !stay && broadCastTimer.is_stopped():
            broadCastLabel.text = broadCastList[0].broadCastString

            if broadCastList[0].broadCastTime != -1:
                broadCastTimer.start(broadCastList[0].broadCastTime)
            else:
                stay = true
            broad.visible = broadCastList.size() > 0
            broadCastList.remove_at(0)


func BroadCastAdd(config: ) -> void :
    if broadCastLabel.text == config.broadCastString:
        return
    if broadCastList.has(config):
        return
    broadCastList.append(config)

func BroadCastTimerTimeOut() -> void :
    stay = false
    broadCastOver.emit()
    if broadCastList.size() == 0:
        broadCastLabel.text = ""
        broad.visible = false

func Next() -> void :
    stay = false
    broadCastTimer.stop()
    if broadCastList.size() > 0:
        broadCastList.remove_at(0)

func BraodCastClear() -> void :
    stay = false
    broadCastLabel.text = ""
    broadCastTimer.stop()
    broadCastList.clear()
    broad.visible = false

func BroadCastFloatCreate(text: String, color: Color = Color.WHITE) -> void :
    var broadCastFloat = BROAD_CAST_FLOAT.instantiate()
    floatBroaderNode.add_child(broadCastFloat)
    broadCastFloat.Init(text, color)
