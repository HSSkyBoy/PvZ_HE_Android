extends Node

@onready var fullScreenColorRect: ColorRect = %FullScreenColorRect

func FullScreenColorBlink(color: Color, duration: float = 0.2, rise: bool = true):
    fullScreenColorRect.visible = true
    fullScreenColorRect.color = color
    var tween = create_tween()
    if rise:
        tween.tween_property(fullScreenColorRect, "modulate:a", color.a, duration / 2.0).from(0.0)
        tween.tween_property(fullScreenColorRect, "modulate:a", 0.0, duration / 2.0).from(color.a)
    else:
        tween.tween_property(fullScreenColorRect, "modulate:a", 0.0, duration).from(color.a)
    await tween.finished
    fullScreenColorRect.visible = false

func CameraShake(dir: Vector2, force: float, intervsl: float = 0.05, time: int = 1):
    var camera = get_viewport().get_camera_2d()
    if camera:
        for i in range(time):
            if camera:
                if i == 0:
                    camera.offset = dir.normalized() * force
                else:
                    camera.offset = - camera.offset / 2.0
                await get_tree().create_timer(intervsl, false).timeout
        if camera:
            camera.offset = Vector2.ZERO
