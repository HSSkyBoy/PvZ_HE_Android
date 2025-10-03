@tool
class_name AdobeAnimateSprite extends Node2D

static  var animeFreshMax: int = 200
static  var animeFreshNum: int = 0

signal animeCompleted(clip: String)
signal animeStoped(clip: String)
signal animeStarted(clip: String)
signal animeEvent(command: String, argument: Variant)
signal animeBlendCompleted(clip: String)

@export var flashAnimeData: AdobeAnimateData:
    set(_flashAnimeData):
        notify_property_list_changed()
        if !parentSprite:
            queue_redraw()
        flashAnimeData = _flashAnimeData
        CanRun()
        frameIndex = 0
        if flashAnimeData && flashAnimeData.animeFile:
            layerVisible.clear()
            layerVisible.resize(flashAnimeData.layerDictionary.size())
            layerVisible.fill(true)
            mediaReplace.clear()
            mediaReplace.resize(flashAnimeData.mediaDictionary.size())
            mediaReplace.fill(null)
            layerSlot.clear()
            layerSlot.resize(flashAnimeData.layerDictionary.size())
            layerSlot.fill(null)
            layerSprite.clear()
            layerSprite.resize(flashAnimeData.layerDictionary.size())
            layerSprite.fill(null)
@export var preview: bool = true:
    set(_preview):
        preview = _preview
        CanRun()
@export_group("Preset")
@export var normalAlpha: bool = false
@export var offset: Vector2 = Vector2.ZERO
@export var offsetRotate: float = 0.0
@export var timeScale: float = 1.0
@export var trueFrameRate: float = 30.0
@export var useTween: bool = true
@export var skipLastFrame: bool = true
@export var usePos: bool = true
@export var useRotate: bool = true
@export_group("Animation")
@export var blendTimeInit: float = 0.0
@export_group("", "")

@export var pause: bool = false:
    set(_pause):
        pause = _pause
        CanRun()
        if !parentSprite:
            queue_redraw()
var elapsedTimer: float = 0.0
var refreshTimer: float = 0.0
var blend: bool = false
var blendTime: float = 0.0
var blendTimer: float = 0.0
var frameIndex: int = 0:
    set(_frameIndex):
        frameIndex = _frameIndex
        if frameIndex + 1 > clipRange.y:
            frameNext = clipRange.x
        else:
            frameNext = frameIndex + 1
        frameNext = clamp(frameNext, clipRange.x, clipRange.y)

var frameBlend: int = 0
var frameNext: int = 0
var loop: bool = true

var clip: String = "":
    set = SetClip
var clipRange: Vector2i = Vector2i.ZERO
var clipOver: bool = false
var layerVisible: Array[bool] = []
@export var layerSlot: Array[AdobeAnimateSlot] = []
@export var layerSprite: Array[AdobeAnimateSprite] = []
var mediaReplace: Array[Texture2D] = []
var track: Array[AdobeAnimateTrack] = []

var canvasItem: RID

var canRun: bool = true

var initClip: bool = false

var refreshEveryFlame: bool = false
var nextFreshBuffer: bool = false
@export var parentSprite: AdobeAnimateSprite
var followParentSpriteLayerId: int = 0

func _get_property_list() -> Array[Dictionary]:
    var properties: Array[Dictionary] = []
    if flashAnimeData == null:
        return properties

    if flashAnimeData.clips.size() > 0:
        properties.append(
            {
                "name": "Animation/Clip", 
                "type": TYPE_STRING, 
                "hint": PROPERTY_HINT_ENUM, 
                "hint_string": "Null," + ",".join(flashAnimeData.clips.keys()), 
            }
        )
    for layerName in flashAnimeData.layerDictionary.keys():
        properties.append({
            "name": "Animation/LayerVisible/" + layerName, 
            "type": TYPE_BOOL
        })
    for mediaName in flashAnimeData.mediaDictionary.keys():
        properties.append({
            "name": "Animation/MediaReplace/" + mediaName, 
            "type": TYPE_OBJECT, 
            "hint": PROPERTY_HINT_RESOURCE_TYPE, 
            "hint_string": "Texture2D"
        })
    if parentSprite:
        if parentSprite.flashAnimeData.layerDictionary.size() > 0:
            properties.append({
                "name": "Layer", 
                "type": TYPE_INT, 
                "hint": PROPERTY_HINT_ENUM, 
                "hint_string": ",".join(parentSprite.flashAnimeData.layerList), 
            })
    return properties

func _set(property: StringName, value: Variant) -> bool:
    if property == "Animation/Clip" && flashAnimeData.clips.size() > 0:
        clip = value
        return true
    if property.begins_with("Animation/LayerVisible"):
        if flashAnimeData.layerDictionary.has(property.trim_prefix("Animation/LayerVisible/")):
            var id = flashAnimeData.layerDictionary[property.trim_prefix("Animation/LayerVisible/")]
            if id < layerVisible.size():
                layerVisible[id] = value
            if !parentSprite:
                queue_redraw()
            return true
    if property.begins_with("Animation/MediaReplace"):
        if flashAnimeData.mediaDictionary.has(property.trim_prefix("Animation/MediaReplace/")):
            var id = flashAnimeData.mediaDictionary[property.trim_prefix("Animation/MediaReplace/")]
            if id < layerVisible.size():
                mediaReplace[id] = value
            if !parentSprite:
                queue_redraw()
            return true
    if property == "Layer":
        if parentSprite && parentSprite.flashAnimeData && parentSprite.layerSprite.size() >= followParentSpriteLayerId - 1:
            parentSprite.layerSprite[followParentSpriteLayerId] = null
        followParentSpriteLayerId = value
        return true
    return false

func _get(property: StringName) -> Variant:
    if !flashAnimeData:
        return null
    if property.begins_with("Animation/Clip"):
        return clip
    if property.begins_with("Animation/LayerVisible"):
        return layerVisible[flashAnimeData.layerDictionary[property.trim_prefix("Animation/LayerVisible/")]]
    if property.begins_with("Animation/MediaReplace"):
        return mediaReplace[flashAnimeData.mediaDictionary[property.trim_prefix("Animation/MediaReplace/")]]
    if parentSprite && parentSprite.flashAnimeData:
        if property == "Layer":
            return followParentSpriteLayerId
    return null

func _property_can_revert(property: StringName):
    if property == "Animation/Clip":
        if flashAnimeData.clips.size() > 0:
            return clip != flashAnimeData.clips.keys()[0]
    if property.begins_with("Animation/LayerVisible"):
        return true
    if property.begins_with("Animation/MediaReplace"):
        return true

    if property == "Layer":
        return true

func _property_get_revert(property: StringName):
    if property == "Animation/Clip":
        if flashAnimeData.clips.size() > 0:
            return flashAnimeData.clips.keys()[0]
    if property.begins_with("Animation/LayerVisible"):
        return true
    if property.begins_with("Animation/MediaReplace"):
        return null

    if property == "Layer":
        return 0

func _on_tree_exiting() -> void :
    if !parentSprite:
        return
    if parentSprite.layerSprite.size() >= followParentSpriteLayerId - 1:
        parentSprite.layerSprite[followParentSpriteLayerId] = null

func _on_tree_entered() -> void :
    if !parentSprite:
        return
    if parentSprite.layerSprite.size() >= followParentSpriteLayerId - 1:
        parentSprite.layerSprite[followParentSpriteLayerId] = self

func CanRun() -> bool:
    canRun = false
    if !is_visible_in_tree():
        return false
    if !flashAnimeData || !flashAnimeData.animeFile:
        return false
    if Engine.is_editor_hint():
        if !preview:
            return false
    if pause:
        return false
    canRun = true
    return true

func _ready() -> void :
    refreshEveryFlame = ProjectSettings.get_setting("application/run/max_fps") <= trueFrameRate
    visibility_changed.connect(CanRun)
    tree_entered.connect(_on_tree_entered)
    tree_exiting.connect(_on_tree_exiting)
    canvasItem = get_canvas_item()
    CanRun()
    var parent = get_parent()
    if parent is AdobeAnimateSprite:
        parentSprite = parent
        parentSprite.layerSprite[followParentSpriteLayerId] = self
        canvasItem = parentSprite.canvasItem
    elif parent is CanvasItem:
        RenderingServer.canvas_item_set_parent(canvasItem, get_parent().get_canvas_item())
        RenderingServer.canvas_item_set_z_as_relative_to_parent(canvasItem, true)
    frameIndex = clipRange.x
    elapsedTimer = randf()
    clipOver = false

    if clip != "":
        if !parentSprite:
            queue_redraw()
        var clipRangeGet = flashAnimeData.GetClip(clip)
        clipRange = clipRangeGet
        frameIndex = clipRange.x

func _physics_process(delta: float) -> void :
    if !canRun:
        return
    if parentSprite && parentSprite.layerSprite.size() >= followParentSpriteLayerId - 1:
        parentSprite.layerSprite[followParentSpriteLayerId] = self
    if !clipOver:
        if clipRange.x != clipRange.y:
            elapsedTimer += delta * abs(timeScale) * flashAnimeData.frameRate
        else:
            frameIndex = clipRange.x
            frameNext = clipRange.x
            if !parentSprite:
                queue_redraw()
        while elapsedTimer >= 1.0:
            elapsedTimer -= 1.0
            if frameIndex < clipRange.y && flashAnimeData.events[frameIndex]:
                for eventDictionary: Dictionary in flashAnimeData.events[frameIndex]:
                    animeEvent.emit(eventDictionary["Command"], eventDictionary["Argument"])
            frameIndex += 1
            if frameIndex + 1 > clipRange.y:
                if frameIndex == clipRange.y && flashAnimeData.events[frameIndex]:
                    for eventDictionary: Dictionary in flashAnimeData.events[frameIndex]:
                        animeEvent.emit(eventDictionary["Command"], eventDictionary["Argument"])

                if !loop:
                    clipOver = true
                    var saveClip: String = clip
                    NextAnimation()
                    if !Engine.is_editor_hint():
                        animeCompleted.emit(saveClip)
                else:
                    if !Engine.is_editor_hint():
                        if !parentSprite:
                            queue_redraw()
                        animeCompleted.emit(clip)
                    frameIndex = clipRange.x

        if !clipOver:
            if !parentSprite:
                if refreshEveryFlame:
                    if !parentSprite:
                        queue_redraw()
                elif nextFreshBuffer:
                    if !parentSprite:
                        queue_redraw()
                    nextFreshBuffer = false
                else:
                    refreshTimer += delta * max(12, trueFrameRate)
                    if refreshTimer >= 1.0:
                        if !parentSprite:
                            queue_redraw()
                        refreshTimer = 0.0

            if blend:
                blendTimer = clamp(blendTimer + delta, 0.0, 1.0)
                if blendTimer > blendTime:
                    animeBlendCompleted.emit(clip)
                    blendTime = 0.0
                    blendTimer = 0.0
                    blend = false

func _draw() -> void :
    animeFreshNum += 1
    if !pause && !nextFreshBuffer:
        if animeFreshNum >= 600:
            nextFreshBuffer = true
            return
    if parentSprite:
        canvasItem = parentSprite.canvasItem
    if !canvasItem.is_valid():
        return
    if !is_visible_in_tree():
        return
    if !flashAnimeData:
        return
    if !parentSprite:
        RenderingServer.canvas_item_clear(canvasItem)
    if clipOver:
        return
    var timeline = flashAnimeData.timeline
    var imageAtlas = flashAnimeData.imageAtlas
    var percentage: float
    if blend:
        percentage = clampf(blendTimer / blendTime, 0.0, 1.0)
    else:
        percentage = clampf(elapsedTimer, 0.0, 1.0)

    for layerId in timeline.size():
        if !layerVisible[layerId] && !layerSlot[layerId] && !layerSprite[layerId]:
            continue
        var layerFrameList: Array = timeline[layerId]
        if frameIndex >= layerFrameList.size():
            return
        var elementList: Array
        var nextElementList: Array
        if blend:
            elementList = layerFrameList[frameBlend]
            nextElementList = layerFrameList[frameIndex]
        else:
            elementList = layerFrameList[frameIndex]
            nextElementList = layerFrameList[frameNext]
        var elmentSize: int = elementList.size()
        var isFirstElement: bool = true
        var canUseTween: bool = (blend || useTween) && elementList.size() == nextElementList.size()
        for elementId in elmentSize:
            var empty: bool = false
            var element: Array = elementList[elementId]
            if element[0] == 65535:
                empty = true
                if !useTween:
                    continue
            var mediaTransform: Transform2D
            var mediaColor: Color
            var mediaRect: Rect2
            if !empty:
                mediaTransform = element[1]
                mediaColor = element[2]
                mediaRect = flashAnimeData.mediaList[element[0]]
            if canUseTween:
                var nextElement: Array = nextElementList[elementId]
                if nextElement[0] == 65535:
                    continue
                if empty:
                    element = nextElementList[elementId]
                    mediaTransform = element[1]
                    mediaColor = element[2]
                    mediaRect = flashAnimeData.mediaList[element[0]]
                var nextElementTransform: Transform2D = nextElement[1]

                mediaTransform = Transform2D(mediaTransform.x.lerp(nextElementTransform.x, percentage), mediaTransform.y.lerp(nextElementTransform.y, percentage), mediaTransform.origin.lerp(nextElementTransform.origin, percentage))

                if !normalAlpha:
                    mediaColor = mediaColor.lerp(nextElement[2], percentage)
            if normalAlpha:
                mediaColor.a = 1.0
            mediaTransform = mediaTransform.translated(offset)
            if parentSprite:
                mediaTransform = transform * mediaTransform
            RenderingServer.canvas_item_add_set_transform(canvasItem, mediaTransform)
            if isFirstElement:
                isFirstElement = false
                var slot: AdobeAnimateSlot = layerSlot[layerId]
                if slot:
                    pass
                    match slot.mode:
                        0:
                            var offsetTransform: Transform2D = mediaTransform.translated_local(slot.offset)
                            if !slot.useRotate:
                                offsetTransform = offsetTransform.rotated_local( - offsetTransform.get_rotation())
                            if !slot.useScale:
                                offsetTransform = offsetTransform.scaled_local(Vector2.ONE / offsetTransform.get_scale())
                            slot.transform = offsetTransform
                            if !slot.useSkew:
                                slot.skew = 0.0
                            slot.modulate = mediaColor
                        1:
                            var offsetTransform: Transform2D = slot.transform.translated_local( - slot.offset)
                            if parentSprite:
                                RenderingServer.canvas_item_add_set_transform(canvasItem, transform * offsetTransform)
                            else:
                                RenderingServer.canvas_item_add_set_transform(canvasItem, offsetTransform)
            if layerVisible[layerId]:
                if element[0] == 65535:
                    continue
                if !mediaReplace[element[0]]:
                    RenderingServer.canvas_item_add_texture_rect_region(canvasItem, Rect2(Vector2(0, 0), mediaRect.size), imageAtlas, mediaRect, mediaColor)
                else:
                    RenderingServer.canvas_item_add_texture_rect_region(canvasItem, Rect2(Vector2(0, 0), mediaReplace[element[0]].get_size()), mediaReplace[element[0]], Rect2(Vector2(0, 0), mediaReplace[element[0]].get_size()), mediaColor)
            var spriteSlot: AdobeAnimateSprite = layerSprite[layerId]
            if spriteSlot:
                var offsetTransform: Transform2D = mediaTransform
                if spriteSlot.usePos:
                    spriteSlot.position = offsetTransform.get_origin()
                if spriteSlot.useRotate:
                    spriteSlot.rotation = offsetTransform.get_rotation() + spriteSlot.offsetRotate
                spriteSlot._draw()
                RenderingServer.canvas_item_add_set_transform(canvasItem, mediaTransform)

func SetClip(_clip: String) -> void :
    clip = _clip
    if flashAnimeData:
        var clipRangeGet = flashAnimeData.GetClip(clip)
        if clipRangeGet != Vector2i.ONE * -1:
            frameBlend = clamp(frameIndex, clipRange.x, clipRange.y)
            if initClip:
                if !skipLastFrame || (skipLastFrame && frameBlend != clipRange.x && frameBlend != clipRange.y):
                    blendTime = blendTimeInit
                    blendTimer = 0.0
                    blend = true
                clipRange = clipRangeGet
                frameIndex = clipRange.x
                set_deferred("clipOver", false)
    initClip = true
    if !parentSprite:
        queue_redraw()

func ResetAnimation() -> void :
    frameIndex = clipRange.x
    if !parentSprite:
        queue_redraw()

func SetAnimation(_clip: String, _loop: bool = true, _blendTime: float = 0.0) -> void :
    track.clear()
    AddAnimation(_clip, 0.0, _loop, _blendTime)
    clipOver = false
    NextAnimation()

func AddAnimation(_clip: String, _delay: float, _loop: bool = true, _blendTime: float = 0.0) -> void :
    track.insert(0, AdobeAnimateTrack.new(Array(_clip.split("&", false)).pick_random(), _delay, _loop, _blendTime))

func NextAnimation() -> AdobeAnimateTrack:
    if track.size() <= 0:
        return null
    var trackConfig: AdobeAnimateTrack = track.pop_back()
    if trackConfig:
        if trackConfig.delay != 0.0:
            await get_tree().create_timer(trackConfig.delay, false).timeout
        if clip != trackConfig.clip:
            clipOver = false
        clip = trackConfig.clip
        loop = trackConfig.loop
        blendTime = trackConfig.blendTime
        if blendTime > 0.0:
            blend = true
        if !Engine.is_editor_hint():
            animeStarted.emit(clip)
            clipOver = false
    else:
        if !Engine.is_editor_hint():
            animeStoped.emit(clip)
    return trackConfig

func GetProgress() -> float:
    return (frameIndex - clipRange.x) / (clipRange.y - clipRange.x + 1.0)

func SetFliter(layerName: StringName, open: bool) -> void :
    if flashAnimeData.layerDictionary.has(layerName):
        layerVisible[flashAnimeData.layerDictionary[layerName]] = open

func GetFliter(layerName: StringName) -> bool:
    if flashAnimeData.layerDictionary.has(layerName):
        return layerVisible[flashAnimeData.layerDictionary[layerName]]
    return false

func SetFliters(layerNameList: Array, open: bool) -> void :
    for layerName in layerNameList:
        SetFliter(layerName, open)
    if !parentSprite:
        queue_redraw()

func SetReplace(mediaName: StringName, texture: Texture2D) -> void :
    if flashAnimeData.mediaDictionary.has(mediaName):
        mediaReplace[flashAnimeData.mediaDictionary[mediaName]] = texture
    if !parentSprite:
        queue_redraw()

func GetReplace(mediaName: StringName) -> Texture2D:
    if flashAnimeData.mediaDictionary.has(mediaName):
        return mediaReplace[flashAnimeData.mediaDictionary[mediaName]]
    return null

func CreatePart(layerList: Array[StringName], index: int = frameIndex, _offset: Vector2 = Vector2.ZERO) -> AdobeAnimatePart:
    var layerCheckList: Array[int] = []
    for layerName in layerList:
        if flashAnimeData.layerDictionary.has(layerName):
            layerCheckList.append(flashAnimeData.layerDictionary[layerName])
    var instance: AdobeAnimatePart = AdobeAnimatePart.new()
    instance.flashAnimeData = flashAnimeData
    instance.mediaReplace = mediaReplace
    instance.offset = _offset
    var timeline = flashAnimeData.timeline
    var elementOutputList: Array[Array] = []
    for layerId in timeline.size():
        if !layerCheckList.has(layerId):
            continue
        var layerFrameList: Array = timeline[layerId]
        var elementList: Array = layerFrameList[index]
        var elmentSize: int = elementList.size()
        for elementId in elmentSize:
            var element: Array = elementList[elementId]
            if element[0] == 65535:
                continue
            var elemetOutput: Array = element.duplicate()
            elemetOutput[1].origin = Vector2.ZERO
            elementOutputList.append(elemetOutput)
    instance.elementList = elementOutputList
    return instance
