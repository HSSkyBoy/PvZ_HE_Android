@tool
class_name TowerDefenseCrater extends TowerDefenseCharacter

var dieDownTimer: float = 0.0
var stage: int = 0
var stageMax: int = 0
var timer: float = 0.0
var isWater: bool = false:
    set(_isWater):
        if isWater != _isWater:
            isWater = _isWater
            sprite.position.y = 0
            timer = 0.0

var isNight: bool = false

func _ready() -> void :
    if Engine.is_editor_hint():
        return
    super ._ready()
    HitBoxDestroy()
    add_to_group("Crater", true)
    stageMax = config.dieDownFliters.size()
    SetFliter(stage)
    isWater = cell.gridType.has(TowerDefenseEnum.PLANTGRIDTYPE.WATER)

func IdleProcessing(delta: float) -> void :
    super .IdleProcessing(delta)
    isNight = TowerDefenseMapControl.instance.config.isNight
    if isNight:
        if isWater:
            sprite.SetAnimation("WaterNight")
        else:
            sprite.SetAnimation("Night")
    else:
        if isWater:
            sprite.SetAnimation("Water")
        else:
            sprite.SetAnimation("Day")
    if isWater:
        timer += delta * timeScale
        sprite.position.y = sin(timer * 2.0) * 2.0

    dieDownTimer += delta
    if config is TowerDefenseCraterConfig:
        if dieDownTimer > config.dieDownTime / stageMax * (stage + 1):
            stage += 1
            if stage < stageMax:
                SetFliter(stage)
            else:
                Destroy()

func SetFliter(_stage: int) -> void :
    sprite.SetFliters(config.dieDownFliters, false)
    sprite.SetFliter(config.dieDownFliters[_stage], true)
