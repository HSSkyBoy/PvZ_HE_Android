@tool
extends TowerDefensePlant

@onready var magnetComponent: MagnetComponent = %MagnetComponent

var armor: TowerDefenseArmorInstance


@warning_ignore("unused_parameter")
func IdleProcessing(delta: float) -> void :
    super .IdleProcessing(delta)
    sprite.timeScale = timeScale
    if await magnetComponent.CanArmorDraw():
        state.send_event("ToShoot")

func IdleExited() -> void :
    super .IdleExited()

func ShootEntered() -> void :
    sprite.SetAnimation("Begin", false, 0.2)
    sprite.AddAnimation("Shooting", 0.0, false, 0.2)

@warning_ignore("unused_parameter")
func ShootProcessing(delta: float) -> void :
    sprite.timeScale = timeScale

func ShootExited() -> void :
    pass

func NoActiveEntered() -> void :
    sprite.SetAnimation("NonActiveIdle2", true, 0.2)

@warning_ignore("unused_parameter")
func NoActiveProcessing(delta: float) -> void :
    sprite.timeScale = timeScale

func NoActiveExited() -> void :
    pass

func AnimeEvent(command: String, argument: Variant) -> void :
    super .AnimeEvent(command, argument)
    match command:
        "action":
            armor = magnetComponent.ArmorDraw()

func AnimeCompleted(clip: String) -> void :
    super .AnimeCompleted(clip)
    match clip:
        "Shooting":
            if armor:
                state.send_event("ToNoActive")
            else:
                Idle()

func BreakDown(_armor: TowerDefenseArmorInstance) -> void :
    armor = null
    Idle()

@warning_ignore("unused_parameter")
func Destroy(freeInsance: bool = true) -> void :
    magnetComponent.Destroy()
    super .Destroy(freeInsance)
