extends TowerDefenseMap

const SOD_ROLL = preload("res://Asset/Anime/Effect/SodRoll/SodRoll.tscn")

@onready var frontlawnFloor: Sprite2D = %FrontlawnFloor
@onready var frontlawnDoor: Sprite2D = %FrontlawnDoor

@onready var frontlawnRow: Array[Sprite2D] = [ %FrontlawnSod1Row, %FrontlawnSod3Row, %FrontlawnSod5Row]
@onready var rowBeginForm: Array[float] = [0, 0, 10]
@onready var rowEndForm: Array[float] = [0, 2, 0]
@onready var rowLong: Array[float] = [1580, 1580, 1580]

var alive: bool = false
var createRowId: int = -1
var followSodRoll: AdobeAnimateSprite

func _ready() -> void :
    for rowId in range(frontlawnRow.size()):
        frontlawnRow[rowId].visible = false
        frontlawnRow[rowId].region_rect.size.x = rowBeginForm[rowId]

@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void :
    if alive:
        if is_instance_valid(followSodRoll):
            var progress: float = followSodRoll.GetProgress()
            frontlawnRow[createRowId].region_rect.size.x = rowBeginForm[createRowId] + progress * rowLong[createRowId] + rowEndForm[createRowId]

func EnterRoom(character: TowerDefenseCharacter) -> void :
    var tween = create_tween()
    tween.set_parallel(true)
    tween.tween_property(character, ^"global_position:y", 375.0, abs(global_position.y - 375) / 200.0)
    tween.tween_property(character, ^"saveShadowPosition:y", 375.0 + 36.0, abs(global_position.y - 375) / 200.0)
    await tween.finished
    if is_instance_valid(character):
        character.timeScaleInit *= 2
    frontlawnDoor.visible = true
    frontlawnFloor.visible = true
    await get_tree().create_timer(3.0, false).timeout


func Row1Create() -> void :
    AudioManager.AudioPlay("DirtRiseLong", AudioManagerEnum.TYPE.SFX)
    TowerDefenseManager.SetMapLineUse(3, true)
    frontlawnRow[0].visible = true
    var cellConfig: TowerDefenseCellConfig = TowerDefenseCellConfig.new()
    cellConfig.gridType = [TowerDefenseEnum.PLANTGRIDTYPE.GROUND, TowerDefenseEnum.PLANTGRIDTYPE.AIR]
    cellConfig.pos = Vector4i(1, 3, 9, 3)
    TowerDefenseManager.SetMapGridType(cellConfig)
    followSodRoll = CreateSodRoll(2)
    followSodRoll.animeCompleted.connect(Finish)
    createRowId = 0

    alive = true

@warning_ignore("unused_parameter")
func Row1Finish(clip: String = "") -> void :
    TowerDefenseManager.SetMapLineUse(3, true)
    frontlawnRow[0].visible = true
    frontlawnRow[1].visible = false
    frontlawnRow[2].visible = false
    var cellConfig: TowerDefenseCellConfig = TowerDefenseCellConfig.new()
    cellConfig.gridType = [TowerDefenseEnum.PLANTGRIDTYPE.GROUND, TowerDefenseEnum.PLANTGRIDTYPE.AIR]
    cellConfig.pos = Vector4i(1, 3, 9, 3)
    TowerDefenseManager.SetMapGridType(cellConfig)

func Row3CreateFromRow1() -> void :
    AudioManager.AudioPlay("DirtRiseLong", AudioManagerEnum.TYPE.SFX)
    TowerDefenseManager.SetMapLineUse(2, true)
    TowerDefenseManager.SetMapLineUse(4, true)
    TowerDefenseManager.CreateMower(2)
    TowerDefenseManager.CreateMower(4)
    followSodRoll = CreateSodRoll(1)
    @warning_ignore("unused_parameter")
    followSodRoll.animeCompleted.connect(
        func(clip: String):
            frontlawnRow[0].visible = false
            Finish()
    )
    CreateSodRoll(3)
    frontlawnRow[0].visible = true
    frontlawnRow[1].visible = true
    var cellConfig: TowerDefenseCellConfig = TowerDefenseCellConfig.new()
    cellConfig.gridType = [TowerDefenseEnum.PLANTGRIDTYPE.GROUND, TowerDefenseEnum.PLANTGRIDTYPE.AIR]
    cellConfig.pos = Vector4i(1, 2, 9, 2)
    TowerDefenseManager.SetMapGridType(cellConfig)
    cellConfig.pos = Vector4i(1, 4, 9, 4)
    TowerDefenseManager.SetMapGridType(cellConfig)
    createRowId = 1

    alive = true

@warning_ignore("unused_parameter")
func Row3Finish(clip: String = "") -> void :
    TowerDefenseManager.SetMapLineUse(2, true)
    TowerDefenseManager.SetMapLineUse(3, true)
    TowerDefenseManager.SetMapLineUse(4, true)
    frontlawnRow[0].visible = false
    frontlawnRow[1].visible = true
    frontlawnRow[2].visible = false
    var cellConfig: TowerDefenseCellConfig = TowerDefenseCellConfig.new()
    cellConfig.gridType = [TowerDefenseEnum.PLANTGRIDTYPE.GROUND, TowerDefenseEnum.PLANTGRIDTYPE.AIR]
    cellConfig.pos = Vector4i(1, 2, 9, 4)
    TowerDefenseManager.SetMapGridType(cellConfig)

func Row5CreateFromRow3() -> void :
    AudioManager.AudioPlay("DirtRiseLong", AudioManagerEnum.TYPE.SFX)
    TowerDefenseManager.SetMapLineUse(1, true)
    TowerDefenseManager.SetMapLineUse(5, true)
    TowerDefenseManager.CreateMower(1)
    TowerDefenseManager.CreateMower(5)
    followSodRoll = CreateSodRoll(0)
    @warning_ignore("unused_parameter")
    followSodRoll.animeCompleted.connect(
        func(clip: String):
            frontlawnRow[1].visible = false
            Finish()
    )
    CreateSodRoll(4)
    frontlawnRow[1].visible = true
    frontlawnRow[2].visible = true
    var cellConfig: TowerDefenseCellConfig = TowerDefenseCellConfig.new()
    cellConfig.gridType = [TowerDefenseEnum.PLANTGRIDTYPE.GROUND, TowerDefenseEnum.PLANTGRIDTYPE.AIR]
    cellConfig.pos = Vector4i(1, 1, 9, 1)
    TowerDefenseManager.SetMapGridType(cellConfig)
    cellConfig.pos = Vector4i(1, 5, 9, 5)
    TowerDefenseManager.SetMapGridType(cellConfig)
    createRowId = 2

    alive = true

@warning_ignore("unused_parameter")
func Row5Finish(clip: String = "") -> void :
    TowerDefenseManager.SetMapLineUse(1, true)
    TowerDefenseManager.SetMapLineUse(2, true)
    TowerDefenseManager.SetMapLineUse(3, true)
    TowerDefenseManager.SetMapLineUse(4, true)
    TowerDefenseManager.SetMapLineUse(5, true)
    frontlawnRow[0].visible = false
    frontlawnRow[1].visible = false
    frontlawnRow[2].visible = true
    var cellConfig: TowerDefenseCellConfig = TowerDefenseCellConfig.new()
    cellConfig.gridType = [TowerDefenseEnum.PLANTGRIDTYPE.GROUND, TowerDefenseEnum.PLANTGRIDTYPE.AIR]
    cellConfig.pos = Vector4i(1, 1, 9, 1)
    TowerDefenseManager.SetMapGridType(cellConfig)
    cellConfig.pos = Vector4i(1, 5, 9, 5)
    TowerDefenseManager.SetMapGridType(cellConfig)

@warning_ignore("unused_parameter")
func Finish(clip: String = "") -> void :
    frontlawnRow[createRowId].region_rect.size.x = rowBeginForm[createRowId] + rowLong[createRowId] + rowEndForm[createRowId]
    alive = false

@warning_ignore("unused_parameter")
func Delete(clip: String = "", instance: AdobeAnimateSprite = null) -> void :
    instance.queue_free()

func CreateSodRoll(line: int) -> AdobeAnimateSprite:
    var instance = SOD_ROLL.instantiate()
    instance.position = Vector2(210, 110 + 100 * line)
    instance.SetAnimation("Idle")
    instance.animeCompleted.connect(Delete.bind(instance))
    add_child(instance)
    return instance

func ShowRow1() -> void :
    frontlawnRow[0].visible = true
    frontlawnRow[0].region_rect.size.x = rowBeginForm[0] + rowLong[0] + rowEndForm[0]
    Row1Finish()

func ShowRow3() -> void :
    frontlawnRow[1].visible = true
    frontlawnRow[1].region_rect.size.x = rowBeginForm[1] + rowLong[1] + rowEndForm[1]
    Row3Finish()

func ShowRow5() -> void :
    frontlawnRow[2].visible = true
    frontlawnRow[2].region_rect.size.x = rowBeginForm[2] + rowLong[2] + rowEndForm[2]
    Row5Finish()
