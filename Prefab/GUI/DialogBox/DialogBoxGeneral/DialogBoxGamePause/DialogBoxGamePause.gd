extends DialogPopup

@onready var spriteNode: Control = %SpriteNode

var sprite: AdobeAnimateSprite


func _ready() -> void :
    super._ready()

    var spriteScene: PackedScene = ResourceManager.CHARCTAER_SPRITE.values().pick_random() as PackedScene
    sprite = spriteScene.instantiate()
    sprite.light_mask = 0
    spriteNode.add_child(sprite)

func TrueButtonPressed() -> void :
    Close()

@warning_ignore("unused_parameter")
func _input(event: InputEvent) -> void :
    if Input.is_action_just_pressed("Pause"):
        Close()
