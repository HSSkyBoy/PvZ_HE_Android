class_name TowerDefenseZombieWon extends Node

@onready var colorRect: ColorRect = %ColorRect
@onready var sprite: AdobeAnimateSprite = %ZombiesWonSprite

func _ready() -> void :
    sprite.pause = true

func LevelFail() -> void :
    AudioManager.AudioStopAll()
    AudioManager.AudioPlay("ZombieWon", AudioManagerEnum.TYPE.MUSIC)
    sprite.visible = true
    sprite.pause = false
    var tween = create_tween()
    tween.tween_property(colorRect, ^"modulate:a", 0.5, 1.0)
    await get_tree().create_timer(2.0, false).timeout
    AudioManager.AudioPlay("CrazyDaveScream", AudioManagerEnum.TYPE.MUSIC)
    ShakeSprite()

func AnimeCompleted(clip: String) -> void :
    if clip == "Idle":
        sprite.visible = false
        DialogManager.DialogCreate("BattleFail")

func ShakeSprite() -> void :
    for time in 5:
        sprite.position = Vector2(540, 300) + Vector2(randf_range(-10, 10), randf_range(-10, 10))
        await get_tree().create_timer(0.05, false).timeout
