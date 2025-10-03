class_name AdobeAnimatePart extends Node2D

@export var flashAnimeData: AdobeAnimateData:
    set(_flashAnimeData):
        flashAnimeData = _flashAnimeData
        queue_redraw()

@export var offset = Vector2.ZERO:
    set(_offset):
        offset = _offset
        queue_redraw()

@export var elementList: Array[Array]:
    set(_elementList):
        elementList = _elementList
        queue_redraw()

@export var mediaReplace: Array[Texture2D]:
    set(_mediaReplace):
        mediaReplace = _mediaReplace
        queue_redraw()

func _draw() -> void :
    var imageAtlas = flashAnimeData.imageAtlas
    var elmentSize: int = elementList.size()
    for elementId in elmentSize:
        var element: Array = elementList[elementId]
        if element[0] == 65535:
            continue
        var mediaTransform: Transform2D = element[1].translated( - offset)
        var mediaColor: Color = element[2]
        draw_set_transform_matrix(mediaTransform)
        var mediaRect: Rect2 = flashAnimeData.mediaList[element[0]]
        if !mediaReplace[element[0]]:
            draw_texture_rect_region(imageAtlas, Rect2(Vector2(0, 0), mediaRect.size), mediaRect, mediaColor)
        else:
            draw_texture_rect_region(mediaReplace[element[0]], Rect2(Vector2(0, 0), mediaRect.size), Rect2(Vector2(0, 0), mediaRect.size), mediaColor)
        draw_set_transform_matrix(Transform2D.IDENTITY)
