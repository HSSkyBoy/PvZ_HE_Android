extends DialogBoxBase

const HELP_MOBILE = preload("res://Asset/Texture/GUI/Help/HelpMobile.png")

@onready var helpTexture: TextureRect = %HelpTexture

func _ready() -> void :
    if Global.isMobile:
        helpTexture.texture = HELP_MOBILE


func BackButtonPressed() -> void :
    Close()
