extends Control

const DAILY_CHALLENGE_TODAY_MARKER = preload("uid://cq333hjurbav3")

@onready var button: Button = %Button
@onready var finishTexture: TextureRect = %FinishTexture

func Toggled(toggledOn: bool) -> void :
    if toggledOn:
        button.icon = DAILY_CHALLENGE_TODAY_MARKER
    else:
        button.icon = null
