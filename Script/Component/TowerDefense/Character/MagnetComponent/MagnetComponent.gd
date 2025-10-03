class_name MagnetComponent extends ComponentBase

signal breakDown(_armor: TowerDefenseArmorInstance)

@export var posMarker: Marker2D
@export var breakDownTime: float = 15.0
@export var checkRange: Vector2 = Vector2(2.5, 2.5)

var parent: TowerDefenseCharacter

var shape: RectangleShape2D = RectangleShape2D.new()
var params = PhysicsShapeQueryParameters2D.new()
var breakDownArmor: TowerDefenseArmorInstance
var breakDownTimer: float = 0.0
var magnet: TowerDefenseMagnet = null

var drawArmorCharacter: TowerDefenseCharacter
var drawArmor: TowerDefenseArmorInstance

var isArrive: bool = false

func _ready() -> void :
    parent = get_parent()

    params.shape = shape
    params.collide_with_areas = true
    params.collision_mask = 1

func _physics_process(delta: float) -> void :
    if !alive:
        return
    if breakDownArmor:
        if is_instance_valid(magnet):
            magnet.gridPos = parent.gridPos
            if !isArrive:
                if magnet.global_position.distance_to(posMarker.global_position) >= 0.01:
                    magnet.global_position = lerp(magnet.global_position, posMarker.global_position, 10.0 * delta)
                else:
                    isArrive = true
            else:
                magnet.global_position = posMarker.global_position
        ArmorBreakDown(delta)
        return

func CanArmorDraw() -> bool:
    var pos: Vector2 = TowerDefenseManager.GetMapCellPosCenter(TowerDefenseManager.GetMapGridPos(parent.global_position))
    shape.size = TowerDefenseManager.GetMapGridSize() * 2.0 * checkRange
    params.transform = Transform2D(0, pos)
    await get_tree().physics_frame
    var arr = get_world_2d().direct_space_state.intersect_shape(params)
    for infor: Dictionary in arr:
        if infor["collider"] is Area2D:
            var area: Area2D = infor["collider"]
            var character = area.get_parent()
            if character is TowerDefenseCharacter:
                if character.camp != parent.camp:
                    var armorList: Array[TowerDefenseArmorInstance] = []
                    armorList.append_array(character.GetArmorShield())
                    armorList.append_array(character.GetArmorHelment())
                    armorList.append_array(character.GetArmor())
                    for armor: TowerDefenseArmorInstance in armorList:
                        if armor.IsMetallic():
                            drawArmorCharacter = character
                            drawArmor = armor
                            return true
    return false

func GetCanArmorDrawCharacterList() -> Array:
    var characterList: Array = []
    var pos: Vector2 = TowerDefenseManager.GetMapCellPosCenter(TowerDefenseManager.GetMapGridPos(parent.global_position))
    shape.size = TowerDefenseManager.GetMapGridSize() * 2.0 * checkRange
    params.transform = Transform2D(0, pos)
    await get_tree().physics_frame
    var arr = get_world_2d().direct_space_state.intersect_shape(params)
    for infor: Dictionary in arr:
        if infor["collider"] is Area2D:
            var area: Area2D = infor["collider"]
            var character = area.get_parent()
            if character is TowerDefenseCharacter:
                if character.camp != parent.camp:
                    var armorList: Array[TowerDefenseArmorInstance] = []
                    armorList.append_array(character.GetArmorShield())
                    armorList.append_array(character.GetArmorHelment())
                    armorList.append_array(character.GetArmor())
                    for armor: TowerDefenseArmorInstance in armorList:
                        if armor.IsMetallic():
                            characterList.append(character)
    return characterList

func ArmorDraw() -> TowerDefenseArmorInstance:
    if !is_instance_valid(drawArmorCharacter):
        return null
    breakDownArmor = drawArmor

    AudioManager.AudioPlay("Magnet", AudioManagerEnum.TYPE.SFX)
    magnet = drawArmorCharacter.ArmorDraw(breakDownArmor)
    drawArmorCharacter.sprite.queue_redraw()
    if is_instance_valid(magnet):
        magnet.adsorbedObject = parent
        magnet.gridPos = parent.gridPos
        breakDownTimer = breakDownTime
    return breakDownArmor

func ArmorBreakDown(delta: float) -> void :
    if breakDownTimer > 0.0:
        breakDownTimer -= delta
        return
    BreakDownOver()

func BreakDownOver() -> void :
    breakDown.emit(breakDownArmor)
    breakDownArmor = null
    isArrive = false
    if is_instance_valid(magnet):
        magnet.queue_free()
        magnet = null

func Destroy() -> void :
    if is_instance_valid(magnet):
        magnet.queue_free()
        magnet = null
