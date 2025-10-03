extends NpcBase

@onready var handSlot: AdobeAnimateSlot = %HandSlot
@onready var shoulderSlot: AdobeAnimateSlot = %ShoulderSlot
@onready var headSlot: AdobeAnimateSlot = %HeadSlot

func _ready() -> void :
    super ._ready()
    sprite.SetAnimation("Enter", true, 0.0)

func AnimeCompleted(clip: String) -> void :
    match clip:
        "Enter":
            sprite.SetAnimation("Idle", true, 0.2)
            npcReady.emit()
        "EnterUp":
            sprite.SetAnimation("Idle", true, 0.2)
        "Leave":
            queue_free()

        "EnterHanding":
            sprite.SetAnimation("EnterHanding", true, 0.2)
        "TalkHanding":
            sprite.SetAnimation("IdleHanding", true, 0.2)

        "SmallTalk":
            sprite.SetAnimation("Idle", true, 0.2)
        "MediumTalk":
            sprite.SetAnimation("Idle", true, 0.2)
        "Blahblah":
            sprite.SetAnimation("Idle", true, 0.2)
        "Crazy":
            sprite.SetAnimation("Idle", true, 0.2)

func Talk(text: String, animeClip: String, audio: String) -> void :
    if animeClip == "Leave":
        Finish()
        return
    super .Talk(text, animeClip, audio)
    for node in handSlot.get_children():
        node.queue_free()

@warning_ignore("unused_parameter")
func Hand(hand: NpcTalkHandConfig) -> void :
    if hand.handScene:
        var instance = hand.handScene.instantiate()
        handSlot.add_child(instance)
    if hand.shoulderScene:
        var instance = hand.shoulderScene.instantiate()
        instance.rotation_degrees = -45
        shoulderSlot.add_child(instance)
    if hand.shoulder2Scene:
        var instance = hand.shoulder2Scene.instantiate()
        instance.position = Vector2(274, -8)
        instance.rotation_degrees = 45
        shoulderSlot.add_child(instance)
    if hand.headScene:
        var instance = hand.headScene.instantiate()
        instance.rotation_degrees = -12
        headSlot.add_child(instance)

func Finish() -> void :
    for node in handSlot.get_children():
        node.queue_free()
    sprite.SetAnimation("Leave", false, 0.2)
    talkBubble.visible = false
