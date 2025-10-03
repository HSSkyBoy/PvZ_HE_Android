class_name SlotComponent extends ComponentBase

var parent: TowerDefenseCharacter

@export var posMark: Marker2D

@export var heightFollow: bool = false
@export var hideShadow: bool = true

var cell: TowerDefenseCellInstance
var slotCharacter: TowerDefenseCharacter
var surroundCharacter: TowerDefenseCharacter

func _ready() -> void :
    parent = get_parent()
    if TowerDefenseManager.GetMapControl():
        cell = TowerDefenseManager.GetMapCell(parent.gridPos)

@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void :
    if !alive:
        return
    if parent.die:
        return
    var getSlot: TowerDefenseCharacter = cell.GetSlot(parent)
    if is_instance_valid(slotCharacter) && slotCharacter == getSlot:
        slotCharacter.shadowFollowHeight = heightFollow
        slotCharacter.groundHeight = (parent.global_position.y - posMark.global_position.y) / parent.transformPoint.global_scale.y
        slotCharacter.shadowSprite.visible = !hideShadow
    else:
        if is_instance_valid(slotCharacter):
            slotCharacter.groundHeight = 0
            slotCharacter.shadowSprite.visible = hideShadow
        slotCharacter = getSlot

    var getSurround: TowerDefenseCharacter = cell.GetSurround()
    if is_instance_valid(surroundCharacter) && surroundCharacter == getSurround:
        surroundCharacter.shadowFollowHeight = heightFollow
        surroundCharacter.groundHeight = (parent.global_position.y - posMark.global_position.y) / parent.transformPoint.global_scale.y
        surroundCharacter.shadowSprite.visible = !hideShadow
    else:
        if is_instance_valid(surroundCharacter):
            surroundCharacter.groundHeight = 0
            surroundCharacter.shadowSprite.visible = hideShadow
        surroundCharacter = getSurround
