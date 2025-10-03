class_name SceneLoading extends CanvasLayer

@onready var background: Control = %Background
@onready var stinky: AdobeAnimateSpriteBase = %Stinky
@onready var label: Label = %Label

var pointNum: int = 0

signal enter()

func _ready() -> void :
    Enter()
    stinky.SetAnimation("Out", false)

func Enter():
    var tween = create_tween()
    tween.set_parallel(true)
    tween.set_ease(Tween.EASE_OUT)
    tween.set_trans(Tween.TRANS_BACK)
    tween.tween_property(stinky, "scale", Vector2(1, 1), 0.5).from(Vector2(2, 0))
    tween.tween_property(background, "modulate:a", 1.0, 0.5).from(0.0)
    await tween.finished
    enter.emit()

func Exit():
    var tween = create_tween()
    tween.set_parallel(true)
    tween.set_ease(Tween.EASE_IN)
    tween.set_trans(Tween.TRANS_BACK)
    tween.tween_property(stinky, "scale", Vector2(0, 0), 1).from(Vector2(1, 1))
    tween.tween_property(background, "modulate:a", 0.0, 0.75).from(1.0)
    await tween.finished
    queue_free()

func AnimeCompleted(clip: String) -> void :
    match clip:
        "In":
            stinky.SetAnimation("Out", false)
        "Out":
            stinky.SetAnimation("Crawl", false)
        "Crawl":
            stinky.SetAnimation("In", false)


func Timeout() -> void :
    pointNum = (pointNum + 1) %7
    label.text = "加载中%s" % " .".repeat(pointNum)
