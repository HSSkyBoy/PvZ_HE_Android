@tool
extends TowerDefensePlant

const SNOW_FLAKES = preload("uid://b1ba7ajcvcgj8")

@export var eventList: Array[TowerDefenseCharacterEventBase] = []

var over: bool = false
var run: bool = false

func SleepEntered() -> void :
    super.SleepEntered()
    instance.invincible = false

func IdleEntered() -> void :
    super.IdleEntered()
    if !is_instance_valid(TowerDefenseManager.currentControl) || !TowerDefenseManager.currentControl.isGameRunning:
        return
    if !inGame:
        return
    if CanSleep():
        Sleep()
        return
    instance.invincible = true
    sprite.SetAnimation("Idle", false, 0.2)
    run = true

@warning_ignore("unused_parameter")
func IdleProcessing(delta: float) -> void :
    super.IdleProcessing(delta)
    sprite.timeScale = timeScale

func IdleExited() -> void :
    super.IdleExited()

func AnimeCompleted(clip: String) -> void :
    if !inGame:
        return
    super.AnimeCompleted(clip)
    match clip:
        "Idle":
            if !run:
                return
            if over:
                return
            over = true
            ViewManager.FullScreenColorBlink(Color(0.117647, 0.564706, 1, 0.5), 0.2)
            AudioManager.AudioPlay("Frozen", AudioManagerEnum.TYPE.SFX)
            var characterNode = TowerDefenseManager.GetCharacterNode()
            var effect = TowerDefenseManager.CreateEffectParticlesOnce(SNOW_FLAKES, gridPos)
            effect.global_position = global_position
            characterNode.add_child(effect)
            var targetList = TowerDefenseManager.GetCharacterTarget(self, false, false)
            for target: TowerDefenseCharacter in targetList:
                for event: TowerDefenseCharacterEventBase in eventList:
                    event.Execute(target.global_position, target)
            Destroy()
