class_name BroadCastFloat extends Control

@onready var label: Label = %Label111

func Init(text: String, color: Color = Color.WHITE) -> void :
    label.text = text
    label.modulate = color

func _ready() -> void :
    var tween = create_tween().set_parallel(true)
    tween.tween_property(label, "global_position:y", 68, 2.0)
    tween.tween_property(label, "modulate:a", 0.0, 2.0)
    await tween.finished
    queue_free()
