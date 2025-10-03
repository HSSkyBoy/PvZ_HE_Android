@tool
extends TowerDefensePlant

@export var eventList: Array[TowerDefenseCharacterEventBase] = []
@export var allEventList: Array[TowerDefenseCharacterEventBase] = []

var over: bool = false

func _ready() -> void :
    if Engine.is_editor_hint():
        return
    super._ready()

func _physics_process(delta: float) -> void :
    if Engine.is_editor_hint():
        return
    super._physics_process(delta)

func IdleEntered() -> void :
    super.IdleEntered()
    if !is_instance_valid(TowerDefenseManager.currentControl) || !TowerDefenseManager.currentControl.isGameRunning:
        return
    if !inGame:
        return
    instance.invincible = true
    AudioManager.AudioPlay("ReverseExplosion", AudioManagerEnum.TYPE.SFX)
    sprite.SetAnimation("Explode", false)

@warning_ignore("unused_parameter")
func IdleProcessing(delta: float) -> void :
    super.IdleProcessing(delta)
    sprite.timeScale = timeScale * 0.5

func IdleExited() -> void :
    super.IdleExited()

func AnimeCompleted(clip: String) -> void :
    super.AnimeCompleted(clip)
    match clip:
        "Explode":
            if over:
                return
            over = true
            Explode()
            Destroy()

func Explode() -> void :
    if sprite.clip != "Explode":
        return
    if gridPos.y > 1:
        TowerDefenseExplode.CreateExplodeLine(gridPos.y - 1, eventList, [], camp, -1)
        TowerDefenseExplode.CreateExplodeLine(gridPos.y - 1, allEventList, [], TowerDefenseEnum.CHARACTER_CAMP.ALL, -1)
        if is_instance_valid(TowerDefenseMapControl.instance.iceCapList[gridPos.y - 1]):
            TowerDefenseMapControl.instance.iceCapList[gridPos.y - 1].queue_free()
        CreateJalapenoFire(gridPos - Vector2i(0, 1))
    TowerDefenseExplode.CreateExplodeLine(gridPos.y, eventList, [], camp, -1)
    TowerDefenseExplode.CreateExplodeLine(gridPos.y, allEventList, [], TowerDefenseEnum.CHARACTER_CAMP.ALL, -1)
    if is_instance_valid(TowerDefenseMapControl.instance.iceCapList[gridPos.y]):
        TowerDefenseMapControl.instance.iceCapList[gridPos.y].queue_free()
    CreateJalapenoFire(gridPos)
    if gridPos.y < TowerDefenseManager.GetMapGridNum().y:
        TowerDefenseExplode.CreateExplodeLine(gridPos.y + 1, eventList, [], camp, -1)
        TowerDefenseExplode.CreateExplodeLine(gridPos.y + 1, allEventList, [], TowerDefenseEnum.CHARACTER_CAMP.ALL, -1)
        if is_instance_valid(TowerDefenseMapControl.instance.iceCapList[gridPos.y + 1]):
            TowerDefenseMapControl.instance.iceCapList[gridPos.y + 1].queue_free()
        CreateJalapenoFire(gridPos + Vector2i(0, 1))
    visible = false
