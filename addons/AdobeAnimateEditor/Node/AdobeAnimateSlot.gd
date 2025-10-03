@tool
class_name AdobeAnimateSlot extends Node2D

var sprite: AdobeAnimateSprite
@export_enum("Follow", "Drive") var mode: int = 0
@export_storage var followSlotId: int = 0

@export var offset: Vector2 = Vector2.ZERO
@export var useRotate: bool = true
@export var useScale: bool = true
@export var useSkew: bool = true

func _ready() -> void :
    tree_entered.connect(_on_tree_entered)
    tree_exiting.connect(_on_tree_exiting)
    var parent = get_parent()
    if parent is AdobeAnimateSprite:
        sprite = parent
        sprite.layerSlot[followSlotId - 1] = self

func _get_property_list() -> Array[Dictionary]:
    var properties: Array[Dictionary] = []
    if !sprite || sprite.flashAnimeData == null:
        return properties

    if sprite.flashAnimeData.layerDictionary.size() > 0:
        properties.append({
            "name": "Layer", 
            "type": TYPE_INT, 
            "hint": PROPERTY_HINT_ENUM, 
            "hint_string": "Noone," + ",".join(sprite.flashAnimeData.layerList), 
        })

    return properties

func _set(property: StringName, value: Variant) -> bool:
    if property == "Layer":
        if sprite && sprite.flashAnimeData && sprite.layerSlot.size() >= followSlotId - 2:
            sprite.layerSlot[followSlotId - 1] = null
        followSlotId = value
        if sprite && sprite.flashAnimeData && sprite.layerSlot.size() >= followSlotId - 2:
            sprite.layerSlot[followSlotId - 1] = self
        return true
    return false

func _get(property: StringName) -> Variant:
    if sprite && sprite.flashAnimeData:
        if property == "Layer":
            return followSlotId
    return null

func _property_can_revert(property: StringName):
    if property == "Layer":
        return true

func _property_get_revert(property: StringName):
    if property == "Layer":
        return 0

func _on_tree_exiting() -> void :
    if !sprite || followSlotId == 0:
        return
    if sprite.layerSlot.size() >= followSlotId - 2:
        sprite.layerSlot[followSlotId - 1] = null

func _on_tree_entered() -> void :
    if !sprite || followSlotId == 0:
        return
    if sprite.layerSlot.size() >= followSlotId - 2:
        sprite.layerSlot[followSlotId - 1] = self

func CreatePart(layerList: Array[StringName]) -> AdobeAnimatePart:
    var layerCheckList: Array[int] = []
    for layerName in layerList:
        if sprite.flashAnimeData.layerDictionary.has(layerName):
            layerCheckList.append(sprite.flashAnimeData.layerDictionary[layerName])
    if !sprite:
        return
    var instance: AdobeAnimatePart = AdobeAnimatePart.new()
    instance.flashAnimeData = sprite.flashAnimeData
    instance.mediaReplace = sprite.mediaReplace
    instance.offset = offset
    var timeline = sprite.flashAnimeData.timeline
    var elementOutputList: Array[Array] = []

    var saveOffset: Vector2 = Vector2.ZERO
    var _layerFrameList: Array = timeline[followSlotId - 1]
    var _elementList: Array = _layerFrameList[sprite.frameIndex]
    var _elmentSize: int = _elementList.size()
    for elementId in _elmentSize:
        var element: Array = _elementList[elementId]
        if element[0] == 65535:
            continue
        saveOffset = element[1].origin
        break

    for layerId in timeline.size():
        if !layerCheckList.has(layerId):
            continue
        if !sprite.layerVisible[layerId]:
            continue
        var layerFrameList: Array = timeline[layerId]
        var elementList: Array = layerFrameList[sprite.frameIndex]
        var elmentSize: int = elementList.size()
        for elementId in elmentSize:
            var element: Array = elementList[elementId]
            if element[0] == 65535:
                continue
            var elemetOutput: Array = element.duplicate()
            elemetOutput[1].origin -= saveOffset
            elementOutputList.append(elemetOutput)
    instance.elementList = elementOutputList
    return instance
