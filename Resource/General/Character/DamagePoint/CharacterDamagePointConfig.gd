@tool
class_name CharacterDamagePointConfig extends Resource

@export var damagePointName: String = ""
@export var damagePersontage: float = 0.5
@export var animeEffect: PackedScene
@export var animeEffectOffset: Vector2 = Vector2(0, 0)
@export var isDrop: bool = true
@export_multiline var animeFliterOpen: String = "":
    set(_animeFliterOpen):
        animeFliterOpen = _animeFliterOpen
        emit_changed()
@export_multiline var animeFliterClose: String = "":
    set(_animeFliterClose):
        animeFliterClose = _animeFliterClose
        emit_changed()
@export var replaceMediaName: StringName
@export var replaceMediaTexture: Texture2D
@export var damageAudio: String = "LimbsPop"
