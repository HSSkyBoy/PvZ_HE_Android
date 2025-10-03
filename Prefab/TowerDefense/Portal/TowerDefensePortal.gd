@tool
class_name TowerDefensePortal extends TowerDefenseGroundItemBase
const PORTAL_CIRCLE = preload("uid://duxojv3j24ulx")
const PORTAL_SQUARE = preload("uid://c0h2t4iq8wbd")
@onready var protalNode1: Node2D = %ProtalNode1
@onready var protalNode2: Node2D = %ProtalNode2
@onready var hitBox1: Area2D = %HitBox1
@onready var hitBox2: Area2D = %HitBox2

var posRange: Vector4i
var protalSprite1: AdobeAnimateSprite
var protalSprite2: AdobeAnimateSprite
var gridPos1: Vector2i
var gridPos2: Vector2i

var changeTime: float = 0.0
var changeTimer: float = 0.0
var isChange: bool = false

var exclude: Array[TowerDefenseGroundItemBase]

var gridSize: Vector2

func Init(shape: String, _posRange: Vector4i, _changeTime: float = 0.0) -> void :
    posRange = _posRange
    changeTime = _changeTime
    match shape:
        "Circle":
            protalSprite1 = PORTAL_CIRCLE.instantiate()
            protalSprite2 = PORTAL_CIRCLE.instantiate()
        "Square":
            protalSprite1 = PORTAL_SQUARE.instantiate()
            protalSprite2 = PORTAL_SQUARE.instantiate()

    protalSprite1.SetAnimation("Appear", false, 0.2)
    protalSprite1.AddAnimation("Pulse", 0.0, true, 0.2)
    protalNode1.add_child(protalSprite1)
    protalSprite2.SetAnimation("Appear", false, 0.2)
    protalSprite2.AddAnimation("Pulse", 0.0, true, 0.2)
    protalNode2.add_child(protalSprite2)
    ChangePos(true)

func _ready() -> void :
    super ._ready()
    if Engine.is_editor_hint():
        return
    add_to_group("Portal")
    gridPos.y = 0
    gridSize = TowerDefenseManager.GetMapGridSize()

func _physics_process(delta: float) -> void :
    if changeTime != 0.0:
        if changeTimer < changeTime:
            changeTimer += delta
        else:
            changeTimer -= changeTime
            ChangePos()

func ChangePos(isInit: bool = false) -> void :
    isChange = true
    if !isInit:
        protalSprite1.SetAnimation("Dissappar")
        protalSprite2.SetAnimation("Dissappar")
        await protalSprite1.animeCompleted
    var posList: Array = []
    var protalList = get_tree().get_nodes_in_group("Portal")
    for protal: TowerDefensePortal in protalList:
        posList.append(protal.gridPos1)
        posList.append(protal.gridPos2)
    var randPos: Vector2i = Vector2i(randi_range(posRange.x, posRange.z), randi_range(posRange.y, posRange.w))
    while posList.has(randPos):
        randPos = Vector2i(randi_range(posRange.x, posRange.z), randi_range(posRange.y, posRange.w))
    gridPos1 = randPos
    posList.erase(gridPos1)
    posList.append(gridPos1)
    while posList.has(randPos):
        randPos = Vector2i(randi_range(posRange.x, posRange.z), randi_range(posRange.y, posRange.w))
    gridPos2 = randPos
    protalNode1.global_position = TowerDefenseManager.GetMapCellPlantPos(gridPos1) + Vector2(gridSize.x / 2, 0)
    protalNode2.global_position = TowerDefenseManager.GetMapCellPlantPos(gridPos2) + Vector2(gridSize.x / 2, 0)
    protalSprite1.SetAnimation("Appear", false, 0.2)
    protalSprite1.AddAnimation("Pulse", 0.0, true, 0.2)
    protalSprite2.SetAnimation("Appear", false, 0.2)
    protalSprite2.AddAnimation("Pulse", 0.0, true, 0.2)
    isChange = false
    protalSprite1.z_index = 0 + gridPos1.y * TowerDefenseEnum.LAYER_GROUNDITEM.MAX
    protalSprite2.z_index = 0 + gridPos2.y * TowerDefenseEnum.LAYER_GROUNDITEM.MAX

func AreaEntered1(area: Area2D) -> void :
    var character = area.get_parent()
    if character is TowerDefenseGroundItemBase:
        if character.gridPos.y != gridPos1.y:
            return
        if exclude.has(character):
            exclude.erase(character)
            return
        if character is TowerDefensePlant && !character is TowerDefensePlantBowlingBase:
            return
        if character is TowerDefenseItem && !character is TowerDefenseMower:
            return
        if character is TowerDefenseCrater:
            return
        if character is TowerDefenseGravestone:
            return
        if character is TowerDefenseCharacter:
            character.saveShadowPosition.y += protalNode2.global_position.y - character.global_position.y
            character.global_position = protalNode2.global_position
        elif character is TowerDefenseProjectile:
            character.global_position.x = protalNode2.global_position.x
            character.global_position.y += gridSize.y * (gridPos2.y - character.gridPos.y)
        else:
            character.global_position = protalNode2.global_position
        character.gridPos = gridPos2
        exclude.append(character)

func AreaEntered2(area: Area2D) -> void :
    var character = area.get_parent()
    if character is TowerDefenseGroundItemBase:
        if character.gridPos.y != gridPos2.y:
            return
        if exclude.has(character):
            exclude.erase(character)
            return
        if character is TowerDefensePlant && !character is TowerDefensePlantBowlingBase:
            return
        if character is TowerDefenseItem && !character is TowerDefenseMower:
            return
        if character is TowerDefenseCrater:
            return
        if character is TowerDefenseGravestone:
            return
        if character is TowerDefenseCharacter:
            character.saveShadowPosition.y += protalNode2.global_position.y - character.global_position.y
            character.global_position = protalNode2.global_position
        elif character is TowerDefenseProjectile:
            character.global_position.x = protalNode1.global_position.x
            character.global_position.y += gridSize.y * (gridPos1.y - character.gridPos.y)
        else:
            character.global_position = protalNode1.global_position
        character.gridPos = gridPos1
        exclude.append(character)
