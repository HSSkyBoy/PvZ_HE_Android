@tool
class_name TowerDefenseZombieImpBase extends TowerDefenseZombie

@export var flyAnimeClip: String = "Fly"
@export var landAnimeClip: String = "Land"

var collectonFlagsSave: int
var maskFlagsSave: int

var throw: bool = false
var landOver: bool = false

func _ready() -> void :
    if Engine.is_editor_hint():
        return
    super ._ready()
    collectonFlagsSave = instance.collisionFlags
    maskFlagsSave = instance.maskFlags
    if throw:
        Fly.call_deferred()

func WalkEntered() -> void :
    super .WalkEntered()

func FlyEntered() -> void :
    AudioManager.AudioPlay("Imp", AudioManagerEnum.TYPE.SFX)

    instance.collisionFlags = 0
    instance.maskFlags = 0
    sprite.SetAnimation(flyAnimeClip, false, 0.2)

@warning_ignore("unused_parameter")
func FlyProcessing(delta: float) -> void :
    sprite.timeScale = timeScale * 0.8

func FlyExited() -> void :
    pass

func LandEntered() -> void :
    sprite.SetAnimation(landAnimeClip, false, 0.2)

@warning_ignore("unused_parameter")
func LandProcessing(delta: float) -> void :
    sprite.timeScale = timeScale

func LandExited() -> void :
    pass

func Fly() -> void :
    state.send_event("ToFly")

func Land() -> void :
    if landOver:
        return
    landOver = true
    instance.collisionFlags = collectonFlagsSave
    instance.maskFlags = maskFlagsSave
    state.send_event("ToLand")

@warning_ignore("unused_parameter")
func AnimeCompleted(clip: String) -> void :
    super .AnimeCompleted(clip)
    match clip:
        landAnimeClip:
            Walk()
