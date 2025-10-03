extends NpcBase

func _ready() -> void :
    super._ready()
    sprite.SetAnimation("Enter", true, 0.2)

func AnimeCompleted(clip: String) -> void :
    match clip:
        "Enter":
            sprite.SetAnimation("Idle", true, 0.2)
            npcReady.emit()
        "Exit":
            queue_free()

        "Talk":
            sprite.SetAnimation("Idle", true, 0.2)
        "Fire":
            sprite.SetAnimation("Idle", true, 0.2)

func Talk(text: String, animeClip: String, audio: String) -> void :
    if animeClip == "Exit":
        Finish()
        return
    super.Talk(text, animeClip, audio)

func Finish() -> void :
    sprite.SetAnimation("Exit", false, 0.2)
    talkBubble.visible = false
