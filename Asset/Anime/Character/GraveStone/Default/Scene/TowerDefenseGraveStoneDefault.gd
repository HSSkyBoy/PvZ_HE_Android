@tool
extends TowerDefenseGravestone

func _ready() -> void :
    super ._ready()
    idleAnimeClip = "&".join(PackedStringArray(sprite.flashAnimeData.clips.keys()))
    HitBoxDestroy()

func IdleEntered() -> void :
    super .IdleEntered()
