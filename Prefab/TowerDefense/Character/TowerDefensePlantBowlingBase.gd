@tool
class_name TowerDefensePlantBowlingBase extends TowerDefensePlant

@onready var moveComponent: MoveComponent = %MoveComponent

@export var rollAnimeClip: String = "Roll"
@export var rollYVelocity: float = 250.0
@export var hitEvent: Array[TowerDefenseCharacterEventBase]

var hitNum: int = 0
var hitCharacter: TowerDefenseCharacter
var hitLineSave: int = -1

var coinNum: int = 0

func _ready() -> void :
    super._ready()
    hitEvent.duplicate(true)

func _physics_process(delta: float) -> void :
    if Engine.is_editor_hint():
        return
    super._physics_process(delta)
    if !is_instance_valid(TowerDefenseManager.currentControl) || !TowerDefenseManager.currentControl.isGameRunning:
        moveComponent.moveScale = 0.0
    else:
        moveComponent.moveScale = 1.0
    if global_position.x > TowerDefenseManager.GetMapGroundRight() + 300:
        Destroy()

    if TowerDefenseMapControl.instance:
        var cell = TowerDefenseManager.GetMapCell(gridPos)
        if is_instance_valid(cell):
            inWater = cell.IsWater()
        else:
            inWater = false

func IdleEntered() -> void :
    AudioManager.AudioPlay("Bowling", AudioManagerEnum.TYPE.SFX)
    sprite.SetAnimation(rollAnimeClip, true)
    moveComponent.velocity.x = randf_range(200.0, 250.0)

@warning_ignore("unused_parameter")
func IdleProcessing(delta: float) -> void :
    super.IdleProcessing(delta)
    moveComponent.moveScale = timeScale
    var up: float = TowerDefenseManager.GetMapGroundUp()
    var down: float = TowerDefenseManager.GetMapGroundDown()
    if global_position.y < up + 50:
        hitLineSave = -1
        global_position.y = up + 50
        ChangeSpeed()
    if global_position.y > down - 20:
        hitLineSave = -1
        global_position.y = down - 20
        ChangeSpeed()

func IdleExited() -> void :
    super.IdleExited()

func HitCheck(area: Area2D) -> void :
    if Global.isEditor && SceneManager.currentScene == "LevelEditorStage":
        return
    var character = area.get_parent()
    if character is TowerDefenseCharacter:
        if hitCharacter == character:
            return
        if CanTarget(character) && CanCollision(character.instance.maskFlags):
            if hitLineSave != character.gridPos.y:
                Bowling(character)

func Bowling(character: TowerDefenseCharacter) -> void :
    hitNum += 1
    if hitNum == 4:
        coinNum += 10
    if hitNum == 5:
        coinNum += 10
    if hitNum == 6:
        coinNum += 10
    if hitNum == 7:
        coinNum += 20
    if coinNum > 0:
        CoinFall(character, coinNum)
    AudioManager.AudioPlay("BowlingImpact", AudioManagerEnum.TYPE.SFX)
    ViewManager.CameraShake(Vector2(randf_range(-1, 1), randf_range(-1, 1)), 2.0, 0.05, 4)
    hitLineSave = character.gridPos.y
    hitCharacter = character
    for event: TowerDefenseCharacterEventBase in hitEvent:
        event.Execute(global_position, character)
    ChangeSpeed()

func ChangeSpeed() -> void :
    var mapSize: Vector2 = TowerDefenseManager.GetMapGridNum()
    if hitLineSave == 1:
        moveComponent.velocity.y = rollYVelocity
        return
    if hitLineSave == mapSize.y:
        moveComponent.velocity.y = - rollYVelocity
        return
    if moveComponent.velocity.y != 0:
        moveComponent.velocity.y = - moveComponent.velocity.y
    else:
        if randf() > 0.5:
            moveComponent.velocity.y = rollYVelocity
        else:
            moveComponent.velocity.y = - rollYVelocity

func CoinFall(character: TowerDefenseCharacter, num: int) -> void :
    if (Global.isEditor && Global.enterLevelMode == "DiyLevel") || Global.enterLevelMode == "LoadLevel" || Global.enterLevelMode == "OnlineLevel":
        return
    while num >= 1000:
        var item = TowerDefenseManager.FallingObjectItemCreate(ObjectManagerConfig.OBJECT.COIN_DIAMOND, character.global_position, character.GetGroundHeight(character.global_position.y), Vector2(randf_range(-50.0, 50.0), -400.0), 980.0)
        item.gridPos = gridPos
        num -= 1000
    while num >= 50:
        var item = TowerDefenseManager.FallingObjectItemCreate(ObjectManagerConfig.OBJECT.COIN_GOLD, character.global_position, character.GetGroundHeight(character.global_position.y), Vector2(randf_range(-50.0, 50.0), -400.0), 980.0)
        item.gridPos = gridPos
        num -= 50
    while num >= 10:
        var item = TowerDefenseManager.FallingObjectItemCreate(ObjectManagerConfig.OBJECT.COIN_SILVER, character.global_position, character.GetGroundHeight(character.global_position.y), Vector2(randf_range(-50.0, 50.0), -400.0), 980.0)
        item.gridPos = gridPos
        num -= 10

func InWater() -> void :
    super.InWater()
    CreateSplash()
    Destroy()
