class_name TowerDefenseAwardBase extends Node2D

@onready var awardRay: AwardRay = %AwardRay
@onready var awardPickupGlow: Sprite2D = %AwardPickupGlow
@onready var downArrow: Sprite2D = %DownArrow
@onready var button: Button = %Button

var press: bool = false

func _physics_process(delta: float) -> void :
    if press:
        return
    var camera: Camera2D = get_viewport().get_camera_2d()
    var centerPos: Vector2 = camera.get_screen_center_position()
    global_position = lerp(global_position, centerPos, delta * 0.5)
    global_scale = lerp(global_scale, Vector2.ONE * 1.5, delta * 0.5)

func Pressed() -> void :
    if press:
        return
    press = true
    AudioManager.AudioStopAll()
    AudioManager.AudioPlay("Win", AudioManagerEnum.TYPE.MUSIC)
    AudioManager.AudioPlay("AwardLightFill", AudioManagerEnum.TYPE.MUSIC)
    awardPickupGlow.visible = false
    downArrow.visible = false
    awardRay.Emit()
    var camera = get_viewport().get_camera_2d() as Camera2D
    var posTo = camera.get_screen_center_position()
    var tween = create_tween()
    tween.set_parallel(true)
    tween.set_ease(Tween.EASE_OUT)
    tween.set_trans(Tween.TRANS_QUART)
    tween.tween_property(self, ^"global_position", posTo, 5.0)
    tween.tween_property(self, ^"scale", Vector2.ONE * 2.0, 7.0)
    await tween.finished
    SceneManager.ChangeScene("LevelChoose", true)
