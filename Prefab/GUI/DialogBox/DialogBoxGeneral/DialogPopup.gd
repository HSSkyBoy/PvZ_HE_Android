class_name DialogPopup extends DialogBoxBase

@onready var ninePatchRect: NinePatchRect = %NinePatchRect
@onready var headTextureRect: TextureRect = %HeadTextureRect

func _ready() -> void :
    super ._ready()
    headTextureRect.position.x = ninePatchRect.size.x / 2.0 - 100.0
    headTextureRect.position.y = -42.0

@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void :
    super ._physics_process(delta)
    headTextureRect.position.x = ninePatchRect.size.x / 2.0 - 100.0
    headTextureRect.position.y = -42.0
