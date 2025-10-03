


var _content: Array[String] = []


var _index = 0


var _size = 0


var _filled = false


func _init(size: int = 300):
    _size = size
    _content.resize(size)



func set_maximum_lines(lines: int):
    _size = lines
    _content.resize(lines)
    clear()


func append(value: String):
    _content[_index] = value
    if _index + 1 < _size:
        _index += 1
    else:
        _index = 0
        _filled = true



func join():
    var result = ""
    if _filled:

        for i in range(_index, _size):
            result += _content[i]


    for i in _index:
        result += _content[i]

    return result


func clear():
    _index = 0
    _filled = false
