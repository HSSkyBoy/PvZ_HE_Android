@tool
class_name AdobeAnimateData extends Resource

@export_file("*.dat") var animeFile: String:
    set(str):
        animeFile = str

        if str != "":
            Init()
        else:
            Clear()
        notify_property_list_changed()
@export var frameRate: float = 30.0
@export var frameScale: int = 1:
    set(_frameScale):
        frameScale = _frameScale
        if animeFile != "":
            Init()
        notify_property_list_changed()
@export var frameMax: int = 0
@export var imageAtlas: PortableCompressedTexture2D
@export_storage var mediaList: Array[Rect2]
@export var layerList: PackedStringArray
@export var timeline: Array[Array]
@export var events: Array[Array]
@export var clips: Dictionary[StringName, Vector2i]

@export var mediaDictionary: Dictionary[StringName, int]
@export_storage var layerDictionary: Dictionary[StringName, int]

func Init():
    if !Engine.is_editor_hint():
        return
    Clear()
    if !FileAccess.file_exists(animeFile):
        return
    var file: FileAccess = FileAccess.open(animeFile, FileAccess.READ)

    frameRate = file.get_float()
    if frameRate <= 0.01:
        frameRate = 24.0
    frameMax = file.get_16()


    var imageAtlasSize: Vector2i = Vector2i(file.get_16(), file.get_16())
    var imageAtlasDataBufferLength: int = file.get_64()
    var imageAtlasDataBuffer: PackedByteArray = file.get_buffer(imageAtlasDataBufferLength)
    var imageAtlasData: Image = Image.create_from_data(imageAtlasSize.x, imageAtlasSize.y, false, Image.FORMAT_RGBA8, imageAtlasDataBuffer)
    imageAtlas = PortableCompressedTexture2D.new()
    imageAtlas.create_from_image(imageAtlasData, PortableCompressedTexture2D.COMPRESSION_MODE_LOSSY)



    var mediaSize: int = file.get_16()
    for mediaId in mediaSize:
        var mediaName: String = file.get_pascal_string()
        var mediaRect: Rect2 = Rect2(file.get_float(), file.get_float(), file.get_float(), file.get_float())
        mediaDictionary[mediaName] = mediaId
        mediaList.append(mediaRect)

    var timelineGet: Array[Array] = []
    var layerSize: int = file.get_16()
    for layerId in layerSize:
        var layerName: String = file.get_pascal_string()
        layerDictionary[layerName] = layerId
        layerList.append(layerName)
        var layerFrameList: Array = []
        for index in frameMax:
            var elementSize: int = file.get_16()
            var elementList: Array = []
            for elementId in elementSize:
                var element: Array = []
                var mediaId: int = file.get_16()
                var transform: Transform2D = Transform2D(Vector2(file.get_float(), file.get_float()), Vector2(file.get_float(), file.get_float()), Vector2(file.get_float(), file.get_float()))
                var color: Color = Color.hex(file.get_32())
                element.append(mediaId)
                element.append(transform)
                element.append(color)
                elementList.append(element)
            layerFrameList.append(elementList)
        timelineGet.append(layerFrameList)

    var clipSize: int = file.get_16()
    for clipId in clipSize:
        var clipName: String = file.get_pascal_string()
        var _range: Vector2i = Vector2i(file.get_16(), file.get_16()) * frameScale
        clips[clipName] = _range


    var eventSize: int = file.get_16()
    events.resize((frameMax * frameScale) - frameScale + 1)
    for eventId in eventSize:
        var eventPos: int = file.get_16() * frameScale
        var eventListSize: int = file.get_16()
        var eventList: Array[Dictionary] = []
        for eventDictionaryId in eventListSize:
            var eventDictionary: Dictionary = {}
            eventDictionary["Command"] = file.get_pascal_string()
            eventDictionary["Argument"] = file.get_pascal_string()
            eventList.append(eventDictionary)
        events[eventPos] = eventList

    file.close()


    for layerId in timelineGet.size():
        var layerFrameListGet: Array = timelineGet[layerId]
        var layerFrameList: Array = []
        for index in layerFrameListGet.size() - 1:
            var elementGetList: Array = layerFrameListGet[index]
            var elementGetNextList: Array = layerFrameListGet[index + 1]
            layerFrameList.append(elementGetList)
            for i in frameScale - 1:
                var elemenList: Array = []
                for elementId in elementGetList.size():
                    var element: Array = []
                    var weight: float = float(i + 1) / frameScale
                    element.append(elementGetList[elementId][0])
                    if elementGetNextList.size() == elementGetList.size():
                        if elementGetNextList[elementId][0] != 65535:
                            element.append(elementGetList[elementId][1].interpolate_with(elementGetNextList[elementId][1], weight))
                            element.append(elementGetList[elementId][2].lerp(elementGetNextList[elementId][2], weight))
                        else:
                            element.append(elementGetList[elementId][1])
                            element.append(elementGetList[elementId][2])
                    else:
                        element.append(elementGetList[elementId][1])
                        element.append(elementGetList[elementId][2])
                    elemenList.append(element)

                layerFrameList.append(elemenList)
        layerFrameList.append(layerFrameListGet[layerFrameListGet.size() - 1])

        timeline.append(layerFrameList)

    frameMax = (frameMax * frameScale) - frameScale + 1
    frameRate = frameRate * frameScale

func Clear():
    imageAtlas = null
    mediaList.clear()
    layerList.clear()
    timeline.clear()
    clips.clear()
    events.clear()
    mediaDictionary.clear()
    layerDictionary.clear()

func HasClip(clipName: StringName) -> bool:
    if clips.has(clipName):
        return true
    return false

func GetClip(clipName: StringName) -> Vector2i:
    if clips.has(clipName):
        return clips[clipName]
    return Vector2i.ONE * -1
