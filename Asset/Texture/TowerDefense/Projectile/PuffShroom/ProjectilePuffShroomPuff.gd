extends Sprite2D

func Refresh() -> void :
    var tween = create_tween()
    tween.tween_property(self, "scale", Vector2.ONE, 0.25).from(Vector2.ZERO)
