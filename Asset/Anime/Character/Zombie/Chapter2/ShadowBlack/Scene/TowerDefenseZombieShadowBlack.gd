@tool
extends TowerDefenseZombie

var spawnOver: bool = false

func DieEntered() -> void :
    super.DieEntered()
    if inWater:
        sprite.SetAnimation(dieWaterAnimeClip, false, 0.0)
    else:
        sprite.SetAnimation(dieAnimeClip, false, 0.0)

func DieProcessing(delta: float) -> void :
    super.DieProcessing(delta)
    sprite.timeScale = timeScale * 2.0

func SpawnEntered() -> void :
    if Global.isEditor && is_instance_valid(LevelEditorMapEditor.instance):
        Idle()
        return
    sprite.SetAnimation("Spawn", false, 0.0)

@warning_ignore("unused_parameter")
func SpawnProcessing(delta: float) -> void :
    if (TowerDefenseManager.currentControl && !TowerDefenseManager.currentControl.isGameRunning):
        Idle()
        return
    sprite.timeScale = timeScale * 2.0

func Walk() -> void :
    if !spawnOver:
        return
    state.send_event("ToWalk")

func AnimeCompleted(clip: String) -> void :
    super.AnimeCompleted(clip)
    match clip:
        "Spawn":
            spawnOver = true
            Walk()
