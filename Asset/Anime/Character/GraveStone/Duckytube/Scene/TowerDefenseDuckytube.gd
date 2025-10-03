@tool
extends TowerDefenseGravestone

func _ready() -> void :
    if Engine.is_editor_hint():
        return
    super._ready()
    var cell: TowerDefenseCellInstance = TowerDefenseManager.GetMapCell(gridPos)
    if is_instance_valid(cell) && cell.IsWater():
        sprite.SetFliters(["Zombie_whitewater", "Zombie_whitewater_复制"], true)
        shadowSprite.visible = false
        SetSpriteGroupShaderParameter("surfaceDownPos", 0.48)
        groundHeight = -20
    else:
        ySpeed = -200
        sprite.pause = true

@warning_ignore("unused_parameter")
func IdleProcessing(delta: float) -> void :
    sprite.timeScale = timeScale * 0.5

func HitpointsEmpty():
    super.HitpointsEmpty()
    AudioManager.AudioPlay("BalloonPop", AudioManagerEnum.TYPE.SFX)
