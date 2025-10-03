@tool
class_name TowerDefensePlant extends TowerDefenseCharacter

@export var plantAnimeClip: String = ""

@export var plantfoodOnAnimeClip: String = "plantfood_on"
@export var plantfoodAnimeClip: String = "plantfood"
@export var plantfoodOffAnimeClip: String = "plantfood_off"
@export_enum("Noone", "Time", "Count") var plantfoodEndMethod: String = "Noone"
@export var plantfoodLoopTime: float = -1
@export var plantfoodLoopCount: int = -1

var plntfoodFx: AdobeAnimateSprite = null
var plantfoodMode: bool = false
var plantfoodLoopTimer: float = 0.0
var plantfoodLoopCountCurrent: int = 0

func _ready() -> void :
    if Engine.is_editor_hint():
        return
    super ._ready()
    add_to_group("Plant", true)
    instance.hitpointsEmpty.connect(Destroy)

func _physics_process(delta: float) -> void :
    super ._physics_process(delta)
    if Engine.is_editor_hint():
        return
    showHealthComponent.alive = GameSaveManager.GetConfigValue("ShowPlantHealth")

func Plantfood() -> void :
    if !config.canUsePlantfood:
        return
    state.send_event("ToPlantfood")

func PlantfoodEnd() -> void :
    state.send_event("PlantfoodLoopToPlantfoodDown")

func PlantEntered() -> void :



    if plantAnimeClip == "":
        Idle()
        return
    if !sprite.flashAnimeData.HasClip(plantAnimeClip):
        Idle()
        return

    sprite.SetAnimation(plantAnimeClip, false)

@warning_ignore("unused_parameter")
func PlantProcessing(delta: float) -> void :
    sprite.timeScale = timeScale

func PlantExited() -> void :
    pass

func AnimeEvent(command: String, argument: Variant) -> void :
    super .AnimeEvent(command, argument)

func AnimeCompleted(clip: String) -> void :
    super .AnimeCompleted(clip)
    match clip:
        plantAnimeClip:
            Idle()
        plantfoodAnimeClip:
            if plantfoodEndMethod == "Noone":
                PlantfoodEnd()
            if plantfoodEndMethod == "Count":
                plantfoodLoopCountCurrent += 1
                if plantfoodLoopCountCurrent >= plantfoodLoopCount:
                    PlantfoodEnd()
        plantfoodOnAnimeClip:
            state.send_event("PlantfoodOnToPlantfoodLoop")
        plantfoodOffAnimeClip:
            Idle()

func Hurt(num: float, playSplatSound: bool = true, velocity: Vector2 = Vector2.ZERO, createDamagePart: bool = true) -> float:
    if plantfoodMode:
        return 0
    return super .Hurt(num, playSplatSound, velocity, createDamagePart)

func SmashHurt(num: float, playSplatSound: bool = true, velocity: Vector2 = Vector2.ZERO) -> float:
    if plantfoodMode:
        return 0
    return super .SmashHurt(num, playSplatSound, velocity)

func ExplodeHurt(num: float, type: String = "Bomb", playSplatSound: bool = true, velocity: Vector2 = Vector2.ZERO) -> float:
    if plantfoodMode:
        return 0
    return super .ExplodeHurt(num, type, playSplatSound, velocity)

func Burnt() -> void :
    pass
