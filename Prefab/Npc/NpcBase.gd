class_name NpcBase extends Node2D

@warning_ignore("unused_signal")
signal npcReady()
signal talkNext()

@onready var talkLabel: Label = %TalkLabel
@onready var talkBubble: TextureRect = %TalkBubble

@export var sprite: AdobeAnimateSprite

var canPress: bool = false

func _ready() -> void :
    sprite.animeCompleted.connect(AnimeCompleted)

@warning_ignore("unused_parameter")
func _input(event: InputEvent) -> void :
    if canPress && Input.is_action_just_pressed("Press"):
        talkNext.emit()
        canPress = false

@warning_ignore("unused_parameter")
func AnimeCompleted(clip: String) -> void :
    pass

func Talk(text: String, animeClip: String, audio: String) -> void :
    AudioManager.AudioPlay(audio, AudioManagerEnum.TYPE.SFX)
    sprite.SetAnimation(animeClip, true, 0.1)
    talkLabel.text = text
    talkBubble.visible = true
    var tween = create_tween()
    tween.set_ease(Tween.EASE_IN_OUT)
    tween.set_trans(Tween.TRANS_QUART)
    tween.tween_property(talkBubble, ^"scale", Vector2.ONE, 0.5).from(Vector2.ZERO)
    await tween.finished
    canPress = true

@warning_ignore("unused_parameter")
func Hand(hand: NpcTalkHandConfig) -> void :
    pass

func Finish() -> void :
    queue_free()
