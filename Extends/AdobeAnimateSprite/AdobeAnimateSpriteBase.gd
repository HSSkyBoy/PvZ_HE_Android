@tool
class_name AdobeAnimateSpriteBase extends AdobeAnimateSprite

func _ready() -> void :
    trueFrameRate = Global.trueAnimeFrameRate
    super ._ready()
    Global.animeFrameRateChange.connect(ChangeFrameRate)

func ChangeFrameRate() -> void :
    refreshEveryFlame = ProjectSettings.get_setting("application/run/max_fps") < Global.trueAnimeFrameRate
    trueFrameRate = Global.trueAnimeFrameRate
