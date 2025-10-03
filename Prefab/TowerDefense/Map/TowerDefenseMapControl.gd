class_name TowerDefenseMapControl extends Node2D

const TOWER_DEFENSE_ICE_CAP = preload("uid://b7eq2mfpja1dy")

@onready var canvasModulate: CanvasModulate = %CanvasModulate
@onready var spriteNode: Node2D = %SpriteNode
@onready var mapNode: Node2D = %MapNode
@onready var mapIceCap: Node2D = %MapIceCap
@onready var shovelSprite: Sprite2D = %ShovelSprite
@onready var plantfoodSprite: Sprite2D = %PlantfoodSprite

@export var canvasModulateCharacter: CanvasModulate
@export var config: TowerDefenseMapConfig
@export var seedBank: TowerDefenseInGameSeedBank

static  var instance: TowerDefenseMapControl = null

var mowerHasRun: bool = false

var plantGrid: Array[Array]
var mowerLine: Array[TowerDefenseMower]
var lineUse: Array[bool]

var currentMap: TowerDefenseMap = null
var nextMap: TowerDefenseMap = null

var isChange: bool = false
var currentGradientPos: float = 0.0
var currentGradient: GradientTexture1D

var followSprite: AdobeAnimateSprite
var plantSprite: AdobeAnimateSprite
var packetPick: TowerDefenseInGamePacketShow

var shovelPick: bool = false
var plantfoodPick: bool = false

var rect: Rect2
var groundRect: Rect2

var strigeRow: int = -1

var iceCapList: Array[TowerDefenseIceCap] = []

var editorSprite: Sprite2D

func Init(_config: TowerDefenseMapConfig) -> void :
    config = _config
    for x in range(0, 25 + 2):
        plantGrid.append([])
        for y in range(0, 25 + 2):
            plantGrid[x].append(null)

    for y in range(0, 25 + 2):
        mowerLine.append(null)
        lineUse.append(false)

    PlantGridInit()

    MapChange(config)

    rect = Rect2(-100, config.edge.y, config.edge.z + 100, config.edge.w - config.edge.y)
    groundRect = Rect2(config.edge.x + 40, config.edge.y, config.edge.z - config.edge.x, config.edge.w - config.edge.y)



func _ready() -> void :
    instance = self
    iceCapList.resize(25)
    if Global.isEditor && SceneManager.currentScene == "LevelEditorStage":
        spriteNode.scale = Vector2.ONE * 0.85
    for node: Node in mapNode.get_children():
        node.queue_free()





@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void :
    canvasModulate.visible = GameSaveManager.GetConfigValue("MapEffect")
    if is_instance_valid(canvasModulateCharacter):
        canvasModulateCharacter.visible = canvasModulate.visible
    if isChange:
        canvasModulate.color = currentGradient.gradient.sample(currentGradientPos)
        canvasModulateCharacter.color = canvasModulate.color
    var mousePos: Vector2 = get_global_mouse_position()
    var gridPos: Vector2i = TowerDefenseManager.GetMapGridPos(mousePos)
    if packetPick != null:
        if followSprite:
            followSprite.visible = true
            followSprite.global_position = mousePos - Vector2(0.0, 20.0)
        if plantSprite:
            plantSprite.visible = false
        if TowerDefenseManager.CheckMapGridPosIn(gridPos) && (strigeRow == -1 || strigeRow >= gridPos.x):
            var cell: TowerDefenseCellInstance = TowerDefenseManager.GetMapCell(gridPos)
            if cell.CanPacketPlant(packetPick.config):
                var plantPos: Vector2 = TowerDefenseManager.GetMapCellPlantPos(gridPos)
                if plantSprite:
                    plantSprite.visible = true
                    plantSprite.global_position = plantPos

                var flag = false
                if Input.is_action_just_pressed("Press"):
                    flag = true
                if Global.isMobile:
                    if Input.is_action_just_released("Press"):
                        flag = true
                if flag:
                    packetPick.Plant(gridPos)
                    if !Global.isEditor || SceneManager.currentScene != "LevelEditorStage":
                        seedBank.Release()
                    else:
                        LevelEditorMapEditor.instance.levelConfig.canExport = false

    if shovelPick:
        if shovelSprite:
            shovelSprite.visible = true
            shovelSprite.scale = Vector2.ONE * 80.0 / shovelSprite.texture.get_width()
            shovelSprite.global_position = mousePos - Vector2(-35.0, 35.0)
        if TowerDefenseManager.CheckMapGridPosIn(gridPos):
            var cellPos: Vector2 = TowerDefenseManager.GetMapCellPos(gridPos)
            var gridSize: Vector2 = TowerDefenseManager.GetMapGridSize()
            var offset: Vector2 = mousePos - cellPos
            var percentage: float = offset.y / gridSize.y
            var cell: TowerDefenseCellInstance = TowerDefenseManager.GetMapCell(gridPos)
            var shovelPlant: TowerDefenseCharacter = cell.GetShovelCharacter(percentage)
            if shovelPlant:
                shovelPlant.Bright(0.5, 0.0)
            if cell.CanShovel(percentage):
                var flag = false
                if Input.is_action_just_pressed("Press"):
                    flag = true
                if Global.isMobile:
                    if Input.is_action_just_released("Press"):
                        flag = true
                if flag:
                    AudioManager.AudioPlay("ShovelDig", AudioManagerEnum.TYPE.SFX)
                    if !Global.isEditor || SceneManager.currentScene != "LevelEditorStage":
                        cell.Shovel(seedBank.shovelConfig, percentage)
                        seedBank.Release()
                    else:
                        cell.Shovel(TowerDefenseManager.GetShovel("ShovelDefault"), percentage)
                        LevelEditorMapEditor.instance.levelConfig.canExport = false

    if plantfoodPick:
        if TowerDefenseManager.CheckMapGridPosIn(gridPos):
            var cell: TowerDefenseCellInstance = TowerDefenseManager.GetMapCell(gridPos)
            var plantfoodPlant: TowerDefenseCharacter = cell.GetPlantfoodCharacter()
            if plantfoodPlant:
                plantfoodPlant.Bright(0.5, 0.0)
            if cell.CanPlantfood():
                var flag = false
                if Input.is_action_just_pressed("Press"):
                    flag = true
                if Global.isMobile:
                    if Input.is_action_just_released("Press"):
                        flag = true
                if flag:
                    AudioManager.AudioPlay("PlantfoodApply", AudioManagerEnum.TYPE.SFX)
                    cell.Plantfood()
                    plantfoodSprite.visible = false
    if !Global.isEditor || SceneManager.currentScene != "LevelEditorStage":
        if Global.isMobile:
            if Input.is_action_just_pressed("Press"):
                if shovelPick:
                    if !groundRect.has_point(mousePos):
                        seedBank.Release()

            if Input.is_action_just_released("Press"):
                if is_instance_valid(plantSprite):
                    plantSprite.visible = false
                if is_instance_valid(followSprite):
                    followSprite.visible = false
                if is_instance_valid(shovelSprite):
                    shovelSprite.visible = false
        else:
            if Input.is_action_just_pressed("Release"):
                seedBank.Release()
    else:
        if Input.is_action_just_pressed("Release"):
            LevelEditorMapEditor.instance.Release()









func PlantGridInit() -> void :
    for x in range(1, config.gridNum.x + 1):
        for y in range(1, config.gridNum.y + 1):
            plantGrid[x][y] = TowerDefenseCellInstance.new()
            plantGrid[x][y].gridPos = Vector2i(x, y)
    for cellConfig: TowerDefenseCellConfig in config.cellConfig:
        SetGridType(cellConfig)

    for line: int in config.lineUse:
        SetLineUse(line, true)

func MapChange(_config: TowerDefenseMapConfig, duration: float = 0.0, delay: float = 0.0) -> void :
    if Global.isEditor && SceneManager.currentScene == "LevelEditorStage":
        if !is_instance_valid(editorSprite):
            editorSprite = Sprite2D.new()
            editorSprite.centered = false
            mapNode.add_child(editorSprite)
        editorSprite.texture = _config.mapTexture
        editorSprite.scale = Vector2.ONE * 600.0 / editorSprite.texture.get_height()
        return

    var refresh: bool = false
    if is_instance_valid(config) || _config.mapScene != config.mapScene:
        if config.gridNum != _config.gridNum:
            TowerDefenseManager.TipsPlay("格子数量不同的地图无法切换", 5.0)
            return
        refresh = true
    if delay != 0.0:
        await get_tree().create_timer(delay).timeout
    if refresh:
        nextMap = _config.mapScene.instantiate() as TowerDefenseMap
        mapNode.add_child(nextMap)
        currentGradient = nextMap.canvasModulateGradient.duplicate()
    if duration != 0.0:
        currentGradient.gradient.set_color(0, canvasModulate.color)
        var tween = create_tween()
        tween.set_parallel(true)
        tween.tween_property(nextMap, "modulate:a", 1.0, duration).from(0.0)
        tween.tween_property(currentMap, "modulate:a", 0.0, duration).from(1.0)
        tween.tween_property(self, "currentGradientPos", 1.0, duration).from(0.0)
        isChange = true
        get_tree().create_timer(duration, false).timeout.connect(
            func():
                config = _config
        )
        await tween.finished
        isChange = false
    else:
        canvasModulate.color = currentGradient.gradient.sample(1.0)
        canvasModulateCharacter.color = currentGradient.gradient.sample(1.0)
    if refresh:
        if currentMap:
            currentMap.queue_free()
        currentMap = nextMap
        nextMap = null

func SetGridType(cellConfig: TowerDefenseCellConfig) -> void :
    for x in range(cellConfig.pos.x, cellConfig.pos.z + 1):
        for y in range(cellConfig.pos.y, cellConfig.pos.w + 1):
            var cell: TowerDefenseCellInstance = plantGrid[x][y]
            cell.Init(cellConfig)

func SetLineUse(line: int, use: bool) -> void :
    lineUse[line] = use

func MowerInit() -> void :
    for line in range(1, config.gridNum.y + 1):
        if lineUse[line]:
            CreateMower(line)

func CreateMower(line: int) -> TowerDefenseMower:
    if mowerLine[line] != null:
        return
    var mowerPacket: TowerDefensePacketConfig = TowerDefenseManager.GetPacketConfig(GameSaveManager.GetKeyValue("CurrentMower"))
    if LineHasType(line, TowerDefenseEnum.PLANTGRIDTYPE.WATER):
        mowerPacket = TowerDefenseManager.GetPacketConfig("MowerPoolCleaner")
    var pos: Vector2 = TowerDefenseManager.GetMapCellPlantPos(Vector2i(0, line)) + Vector2(10, 0)
    var characterNode: Node2D = TowerDefenseManager.GetCharacterNode()
    var mower = mowerPacket.Create(pos, Vector2i(0, line))
    mower.characterFilter = true
    mower.running.connect(MowerRun)
    characterNode.add_child(mower)
    mowerLine[line] = mower
    return mower

func MowerRun(mower: TowerDefenseMower) -> void :
    var line: int = mowerLine.find(mower)
    mowerLine[line] = null
    mowerHasRun = true

func LineHasType(line: int, type: TowerDefenseEnum.PLANTGRIDTYPE) -> bool:
    for i in 25:
        var cell: TowerDefenseCellInstance = plantGrid[i][line]
        if !is_instance_valid(cell):
            continue
        if cell.gridType.has(type):
            return true
    return false

func SetIceCapPos(line: int, pos: Vector2) -> void :
    if !is_instance_valid(iceCapList[line]):
        iceCapList[line] = TOWER_DEFENSE_ICE_CAP.instantiate()
        iceCapList[line].gridPos = Vector2(0, line)
        iceCapList[line].global_position = Vector2(config.mapSize.x, TowerDefenseManager.GetMapCellPlantPos(Vector2i(0, line)).y)
        mapIceCap.add_child(iceCapList[line])
    iceCapList[line].length = max(iceCapList[line].length, config.mapSize.x - pos.x)
