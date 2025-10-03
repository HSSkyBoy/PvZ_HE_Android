class_name ScreenEffectControl extends Control

static  var instance: ScreenEffectControl

static  var EFFECT: Dictionary = {
    "Rain": preload("uid://brduo5wtglu0")
}

var currentEffect: Dictionary = {}

func _ready() -> void :
    instance = self

func AddScreenEffect(effectName: String) -> void :
    if currentEffect.has(effectName):
        return
    if !EFFECT.has(effectName):
        return
    currentEffect[effectName] = EFFECT[effectName].instantiate()
    add_child(currentEffect[effectName])

func DeleteScreenEffect(effectName: String) -> void :
    if !currentEffect.has(effectName):
        return
    if is_instance_valid(currentEffect[effectName]):
        currentEffect[effectName].queue_free()
        currentEffect.erase(effectName)
