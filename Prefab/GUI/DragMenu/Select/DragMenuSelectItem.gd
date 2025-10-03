@tool
class_name DragMenuSelectItem extends Node2D

signal select(index: int)

@onready var sprite: Sprite2D = %Sprite
@onready var button: Button = %Button

var index: int = -1
var lock: bool = false

func _on_sprite_texture_changed() -> void :
    if sprite.texture:
        button.size = sprite.texture.get_size()
        button.position = - button.size / 2

func _on_button_pressed() -> void :
    select.emit(index)
