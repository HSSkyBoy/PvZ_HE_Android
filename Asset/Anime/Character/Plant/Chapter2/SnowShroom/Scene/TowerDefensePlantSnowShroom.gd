@tool
extends TowerDefensePlant

const SNOW_FLAKES = preload("uid://b1ba7ajcvcgj8")

@export var eventList: Array[TowerDefenseCharacterEventBase] = []

var projectileName: String = "SnowPeaFull"

func _ready() -> void :
    super._ready()
    if currentCustom.has("Custom0"):
        projectileName = "IceSwordFull"

func SleepEntered() -> void :
    super.SleepEntered()
    instance.invincible = false

func SleepProcessing(delta: float) -> void :
    super.SleepProcessing(delta)
    instance.invincible = false

func IdleEntered() -> void :
    if !is_instance_valid(TowerDefenseManager.currentControl) || !TowerDefenseManager.currentControl.isGameRunning:
        return
    if !inGame:
        return
    if CanSleep():
        Sleep()
        return
    super.IdleEntered()
    CreateProjectile()
    HitBoxDestroy()
    instance.invincible = true

func CreateProjectile() -> void :
    var gridNum: Vector2i = TowerDefenseManager.GetMapGridNum()
    var gridSize: Vector2 = TowerDefenseManager.GetMapGridSize()
    var height: float = 600
    for id in range(25):
        for x in range(1, gridNum.x + 1):
            for y in range(1, gridNum.y + 1):
                var pos: Vector2 = TowerDefenseManager.GetMapCellPlantPos(Vector2i(x, y)) - Vector2(150, 0.0) + Vector2(randf_range( - gridSize.x / 2, gridSize.x / 2), 0.0)
                var heightOffset: float = randf_range(0, 200)
                var projectile: TowerDefenseProjectile = FireComponent.CreateProjectilePosition(self, null, GetGroundHeight(self.global_position.y), pos, Vector2(randf_range(50, 150), 0.0), projectileName, camp)
                projectile.gridPos.y = y
                projectile.z = height + heightOffset
                projectile.ySpeed = 400
                projectile.useFall = true


        await get_tree().create_timer(0.3, false).timeout
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
