class_name TowerDefenseMapControl extends Node2D

const TOWER_DEFENSE_ICE_CAP = preload("uid://b7eq2mfpja1dy")

@onready var canvasModulate: CanvasModulate = %CanvasModulate
@onready var spriteNode: Node2D = %SpriteNode
@onready var fireModeMowerNode: Node2D = %FireModeMowerNode

@onready var mapNode: Node2D = %MapNode
@onready var mapIceCap: Node2D = %MapIceCap
@onready var shovelSprite: Sprite2D = %ShovelSprite
@onready var plantfoodSprite: Sprite2D = %PlantfoodSprite
@onready var changeMapLayer: CanvasLayer = %ChangeMapLayer

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
var plantSpriteList: Array[AdobeAnimateSprite]

var packetPick: TowerDefenseInGamePacketShow

var shovelPick: bool = false
var plantfoodPick: bool = false

var rect: Rect2
var groundRect: Rect2

var strigeRow: int = -1

var iceCapList: Array[TowerDefenseIceCap] = []

var editorSprite: Sprite2D

var selectPacketTimer: int = 0

var mowerMovePlantPressed: bool = false
var mowerSpriteList: Array[AdobeAnimateSprite] = [null, null, null]
var mowerSpritePosList: Array[Vector2i] = [Vector2i.ZERO, Vector2i.ZERO, Vector2i.ZERO]

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
    var gridPos: Vector2i = TowerDefenseManager.GetMapGridPosFromMouse(mousePos)
    var cell: TowerDefenseCellInstance = TowerDefenseManager.GetMapCell(gridPos)

    if TowerDefenseManager.IsGameRunning():
        if Input.is_action_just_pressed("Press"):
            if is_instance_valid(cell) && cell.CanMowerMove():
                if !is_instance_valid(mowerSpriteList[0]):
                    mowerSpriteList[0] = TowerDefenseManager.GetCharacterSprite("MowerDefault")
                    mowerSpriteList[0].global_position = TowerDefenseManager.GetMapCellPlantPos(gridPos) - Vector2(0, 10)
                    mowerSpriteList[0].scale = Vector2.ONE * 1.0
                    var characterNode: Node2D = TowerDefenseManager.GetCharacterNode()
                    characterNode.add_child(mowerSpriteList[0])
                var mowerTween = create_tween()
                mowerTween.set_ease(Tween.EASE_OUT)
                mowerTween.set_trans(Tween.TRANS_QUART)
                mowerTween.tween_property(mowerSpriteList[0], "global_position", TowerDefenseManager.GetMapCellPlantPos(gridPos) - Vector2(0, 10), 0.5)
                mowerSpriteList[0].z_index = gridPos.y * TowerDefenseEnum.LAYER_GROUNDITEM.MAX + TowerDefenseEnum.LAYER_GROUNDITEM.GROUNDITEM
                mowerSpritePosList[0] = gridPos
                mowerMovePlantPressed = true
        if Input.is_action_just_released("Press"):
            mowerMovePlantPressed = false

        if mowerMovePlantPressed:
            if is_instance_valid(cell):
                var offset: Vector2i = gridPos - mowerSpritePosList[0]


                if offset != Vector2i.ZERO:
                    var beginCell: TowerDefenseCellInstance = TowerDefenseManager.GetMapCell(mowerSpritePosList[0])
                    if beginCell.CanMoveToCell(cell):
                        var mowerTween = create_tween()
                        mowerTween.set_ease(Tween.EASE_OUT)
                        mowerTween.set_trans(Tween.TRANS_QUART)
                        mowerTween.tween_property(mowerSpriteList[0], "global_position", TowerDefenseManager.GetMapCellPlantPos(gridPos) - Vector2(0, 10), 0.5)
                        beginCell.MoveToCell(cell)
                        mowerSpritePosList[0] = gridPos
                        mowerSpriteList[0].z_index = gridPos.y * TowerDefenseEnum.LAYER_GROUNDITEM.MAX + TowerDefenseEnum.LAYER_GROUNDITEM.GROUNDITEM
        if is_instance_valid(mowerSpriteList[0]):
            var mowerXAxis: int = 0
            var mowerYAxis: int = 0
            var pressFlag: bool = false
            if mowerSpritePosList[0].y - 1 >= 1 && Input.is_action_just_pressed("P1Up"):
                mowerYAxis -= 1
                pressFlag = true
            if mowerSpritePosList[0].y + 1 <= config.gridNum.y && Input.is_action_just_pressed("P1Down"):
                mowerYAxis += 1
                pressFlag = true
            if mowerSpritePosList[0].x - 1 >= 1 && Input.is_action_just_pressed("P1Left"):
                mowerXAxis -= 1
                pressFlag = true
            if mowerSpritePosList[0].x + 1 <= config.gridNum.x && Input.is_action_just_pressed("P1Right"):
                mowerXAxis += 1
                pressFlag = true
            if pressFlag:
                var mowerOffset: Vector2i = Vector2i(mowerXAxis, mowerYAxis)
                if mowerOffset != Vector2i.ZERO:
                    var gridCell: TowerDefenseCellInstance = TowerDefenseManager.GetMapCell(mowerSpritePosList[0])
                    var moveCell: TowerDefenseCellInstance = TowerDefenseManager.GetMapCell(mowerSpritePosList[0] + mowerOffset)
                    if gridCell.CanMoveToCell(moveCell):
                        var mowerTween = create_tween()
                        mowerTween.set_ease(Tween.EASE_OUT)
                        mowerTween.set_trans(Tween.TRANS_QUART)
                        mowerTween.tween_property(mowerSpriteList[0], "global_position", TowerDefenseManager.GetMapCellPlantPos(mowerSpritePosList[0] + mowerOffset) - Vector2(0, 10), 0.5)
                        gridCell.MoveToCell(moveCell)
                        mowerSpritePosList[0] += mowerOffset
                        mowerSpriteList[0].z_index = mowerSpritePosList[0].y * TowerDefenseEnum.LAYER_GROUNDITEM.MAX + TowerDefenseEnum.LAYER_GROUNDITEM.GROUNDITEM

    if packetPick != null:
        var isPlantColumn: bool = is_instance_valid(TowerDefenseManager.currentControl) && TowerDefenseManager.currentControl.levelConfig.plantColumn
        var limitPlantGridNum: int = -1
        if is_instance_valid(TowerDefenseManager.currentControl):
            limitPlantGridNum = TowerDefenseManager.currentControl.levelConfig.limitGridPlantNum
        if selectPacketTimer > 0:
            selectPacketTimer -= 1
            return
        if followSprite:
            followSprite.visible = true
            followSprite.global_position = mousePos - Vector2(0.0, 20.0)
        if plantSprite:
            plantSprite.visible = false
        if isPlantColumn:
            for sprite in plantSpriteList:
                sprite.visible = false
        if is_instance_valid(cell):
            var plantFlag: bool = true
            if !TowerDefenseManager.CheckMapGridPosIn(gridPos):
                plantFlag = false
            if packetPick.config.IsLimitGridNum():
                if !(limitPlantGridNum == -1 || (limitPlantGridNum > GetCellPlantNum() || cell.HasPlant())):
                    plantFlag = false
            if packetPick.config.characterConfig is TowerDefenseZombieConfig:
                plantFlag = true
            if !cell.CanPacketPlant(packetPick.config):
                plantFlag = false

            if !(strigeRow == -1 || (strigeRow >= gridPos.x && packetPick.config.characterConfig is TowerDefensePlantConfig) || (strigeRow < gridPos.x && packetPick.config.characterConfig is TowerDefenseZombieConfig)):
                plantFlag = false
            if plantFlag:
                if !isPlantColumn:
                    var plantPos: Vector2 = TowerDefenseManager.GetMapCellPlantPos(gridPos)
                    var groundHeight = 0
                    if is_instance_valid(cell.groundHeightCurve):
                        groundHeight = cell.groundHeightCurve.curve.sample(0.5) * global_scale.y
                    if plantSprite:
                        plantSprite.visible = true
                        plantSprite.global_position = plantPos - Vector2(0.0, groundHeight)

                    var flag = false
                    if Global.isMobile:
                        if Input.is_action_just_released("Press"):
                            if selectPacketTimer > 0:
                                return
                            flag = true
                    else:
                        if Input.is_action_just_pressed("Press"):
                            flag = true
                    if flag:
                        packetPick.Plant(gridPos)
                        if !Global.isEditor || SceneManager.currentScene != "LevelEditorStage":
                            seedBank.Release()
                        else:
                            LevelEditorMapEditor.instance.levelConfig.canExport = false
                else:
                    for i in config.gridNum.y:
                        var plantPos: Vector2 = TowerDefenseManager.GetMapCellPlantPos(Vector2(gridPos.x, i + 1))
                        var getCell: TowerDefenseCellInstance = TowerDefenseManager.GetMapCell(Vector2(gridPos.x, i + 1))
                        if getCell.CanPacketPlant(packetPick.config):
                            var groundHeight = 0
                            if is_instance_valid(getCell.groundHeightCurve):
                                groundHeight = getCell.groundHeightCurve.curve.sample(0.5) * global_scale.y
                            if plantSpriteList.size() > i:
                                var sprite: AdobeAnimateSprite = plantSpriteList[i]
                                sprite.visible = true
                                sprite.global_position = plantPos - Vector2(0.0, groundHeight)
                    var flag = false
                    if Global.isMobile:
                        if Input.is_action_just_released("Press"):
                            if selectPacketTimer > 0:
                                return
                            flag = true
                    else:
                        if Input.is_action_just_pressed("Press"):
                            flag = true
                    if flag:
                        for i in config.gridNum.y:
                            packetPick.Plant(Vector2(gridPos.x, i + 1), i == 0)
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
            var shovelPlant: TowerDefenseCharacter = cell.GetShovelCharacter(percentage)
            if shovelPlant:
                shovelPlant.Bright(0.5, 0.0)
            if cell.CanShovel(percentage):
                var flag = false
                if Global.isMobile:
                    if Input.is_action_just_released("Press"):
                        flag = true
                else:
                    if Input.is_action_just_pressed("Press"):
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
            var plantfoodPlant: TowerDefenseCharacter = cell.GetPlantfoodCharacter()
            if plantfoodPlant:
                plantfoodPlant.Bright(0.5, 0.0)
            if cell.CanPlantfood():
                var flag = false
                if Global.isMobile:
                    if Input.is_action_just_released("Press"):
                        flag = true
                else:
                    if Input.is_action_just_pressed("Press"):
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









func PickShovel(open: bool) -> void :
    if is_instance_valid(packetPick):
        packetPick.Reset()
        packetPick = null
        if followSprite:
            followSprite.queue_free()
            followSprite = null
        if plantSprite:
            plantSprite.queue_free()
            plantSprite = null
    if open:
        AudioManager.AudioPlay("Shovel", AudioManagerEnum.TYPE.SFX)
        shovelPick = true
        shovelSprite.position = Vector2(-100, -100)
        shovelSprite.visible = true
    else:
        AudioManager.AudioPlay("ShovelDeny", AudioManagerEnum.TYPE.SFX)
        shovelPick = false
        shovelSprite.visible = false

func PickPacket(_packet: TowerDefenseInGamePacketShow) -> void :
    var isPlantColumn: bool = is_instance_valid(TowerDefenseManager.currentControl) && TowerDefenseManager.currentControl.levelConfig.plantColumn

    selectPacketTimer = 5
    shovelPick = false
    shovelSprite.visible = false
    if is_instance_valid(packetPick):
        if _packet != packetPick:
            packetPick.Reset()
            if !packetPick.config.GetPlantCover().is_empty():
                for character: TowerDefenseCharacter in TowerDefenseManager.GetCharacter():
                    if packetPick.config.GetPlantCover().has(character.config.name):
                        character.SetSpriteGroupShaderParameter("cover", false)
    if _packet.select:
        packetPick = _packet
        if !packetPick.config.GetPlantCover().is_empty():
            for character: TowerDefenseCharacter in TowerDefenseManager.GetCharacter():
                if packetPick.config.GetPlantCover().has(character.config.name):
                    character.SetSpriteGroupShaderParameter("cover", true)
        if is_instance_valid(followSprite):
            followSprite.queue_free()
        if is_instance_valid(plantSprite):
            plantSprite.queue_free()
        if isPlantColumn:
            for sprite in plantSpriteList:
                sprite.queue_free()
            plantSpriteList.clear()

        var characterConfig: TowerDefenseCharacterConfig = _packet.config.characterConfig
        followSprite = TowerDefenseManager.GetCharacterSprite(characterConfig.name)
        followSprite.light_mask = 0
        followSprite.z_index = 1000
        followSprite.position = Vector2(-100, -100)

        if !isPlantColumn:
            plantSprite = TowerDefenseManager.GetCharacterSprite(characterConfig.name)
            plantSprite.light_mask = 0
            plantSprite.modulate.a = 0.5
            plantSprite.z_index = 900
            plantSprite.position = Vector2(-100, -100)
        else:
            for i in config.gridNum.y:
                var sprite = TowerDefenseManager.GetCharacterSprite(characterConfig.name)
                sprite.light_mask = 0
                sprite.modulate.a = 0.5
                sprite.z_index = 900
                sprite.position = Vector2(-100, -100)
                plantSpriteList.append(sprite)

        if characterConfig.armorData:
            if _packet.config.initArmor.size() > 0:
                for armorName: String in _packet.config.initArmor:
                    var armor: CharacterArmorConfig = characterConfig.armorData.armorDictionary[armorName]
                    match armor.replaceMethod:
                        "Media":
                            characterConfig.armorData.OpenArmorFliters(followSprite, armorName)
                            characterConfig.armorData.SetArmorReplace(followSprite, armorName, 0)
                            if !isPlantColumn:
                                characterConfig.armorData.OpenArmorFliters(plantSprite, armorName)
                                characterConfig.armorData.SetArmorReplace(plantSprite, armorName, 0)
                            else:
                                for i in config.gridNum.y:
                                    var sprite: AdobeAnimateSprite = plantSpriteList[i]
                                    characterConfig.armorData.OpenArmorFliters(sprite, armorName)
                                    characterConfig.armorData.SetArmorReplace(sprite, armorName, 0)
                        "Sprite":
                            var followSlotNode: AdobeAnimateSlot = followSprite.get_node(armor.replaceSpriteSlotPath)
                            var _follosprite: Sprite2D = Sprite2D.new()
                            _follosprite.texture = armor.stageAnimeTexture[0]
                            _follosprite.position = armor.replaceSpriteOffset
                            _follosprite.rotation = armor.replaceSpriteRotation
                            _follosprite.scale = armor.replaceSpriteScale
                            followSlotNode.add_child(_follosprite)
                            if !isPlantColumn:
                                var plantSlotNode: AdobeAnimateSlot = plantSprite.get_node(armor.replaceSpriteSlotPath)
                                var _plantsprite: Sprite2D = Sprite2D.new()
                                _plantsprite.texture = armor.stageAnimeTexture[0]
                                _plantsprite.position = armor.replaceSpriteOffset
                                _plantsprite.rotation = armor.replaceSpriteRotation
                                _plantsprite.scale = armor.replaceSpriteScale
                                plantSlotNode.add_child(_plantsprite)
                            else:
                                for i in config.gridNum.y:
                                    var sprite: AdobeAnimateSprite = plantSpriteList[i]
                                    var plantSlotNode: AdobeAnimateSlot = sprite.get_node(armor.replaceSpriteSlotPath)
                                    var _plantsprite: Sprite2D = Sprite2D.new()
                                    _plantsprite.texture = armor.stageAnimeTexture[0]
                                    _plantsprite.position = armor.replaceSpriteOffset
                                    _plantsprite.rotation = armor.replaceSpriteRotation
                                    _plantsprite.scale = armor.replaceSpriteScale
                                    plantSlotNode.add_child(_plantsprite)
        if characterConfig.customData:
            var packetValue: Dictionary = GameSaveManager.GetTowerDefensePacketValue(_packet.config.saveKey)
            if packetValue.get_or_add("Key", {}).get_or_add("Custom", "") != "":
                characterConfig.customData.SetCustomFliters(followSprite, packetValue["Key"]["Custom"])
                if !isPlantColumn:
                    characterConfig.customData.SetCustomFliters(plantSprite, packetValue["Key"]["Custom"])
                else:
                    for i in config.gridNum.y:
                        var sprite: AdobeAnimateSprite = plantSpriteList[i]
                        characterConfig.customData.SetCustomFliters(sprite, packetValue["Key"]["Custom"])
        spriteNode.add_child(followSprite)
        if !isPlantColumn:
            spriteNode.add_child(plantSprite)
        else:
            for i in config.gridNum.y:
                var sprite: AdobeAnimateSprite = plantSpriteList[i]
                spriteNode.add_child(sprite)
    else:
        Release()

func Release() -> void :
    var isPlantColumn: bool = is_instance_valid(TowerDefenseManager.currentControl) && TowerDefenseManager.currentControl.levelConfig.plantColumn
    if shovelPick:
        AudioManager.AudioPlay("ShovelDeny", AudioManagerEnum.TYPE.SFX)
    if is_instance_valid(packetPick):
        if !packetPick.config.GetPlantCover().is_empty():
            for character: TowerDefenseCharacter in TowerDefenseManager.GetCharacter():
                character.SetSpriteGroupShaderParameter("cover", false)
        packetPick.Reset()
        packetPick = null
    shovelPick = false
    shovelSprite.visible = false
    plantfoodPick = false
    plantfoodSprite.visible = false

    if is_instance_valid(followSprite):
        followSprite.queue_free()
        followSprite = null
    if is_instance_valid(plantSprite):
        plantSprite.queue_free()
        plantSprite = null
    if isPlantColumn:
        for sprite in plantSpriteList:
            sprite.queue_free()
        plantSpriteList.clear()

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
        changeMapLayer.add_child(nextMap)
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
        if is_instance_valid(currentMap):
            currentMap.queue_free()
        if is_instance_valid(nextMap):
            currentMap = nextMap
        if is_instance_valid(currentMap):
            currentMap.reparent(mapNode)
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
    mower.groundHeight = TowerDefenseManager.GetMapCell(Vector2(1, line)).GetGroundHeight(0.0)
    mower.z = mower.groundHeight
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

func GetCellPlantNum() -> int:
    var num: int = 0
    for x in range(1, config.gridNum.x + 1):
        for y in range(1, config.gridNum.y + 1):
            if plantGrid[x][y].HasPlant():
                num += 1
    return num
