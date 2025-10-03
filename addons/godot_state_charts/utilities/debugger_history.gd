const RingBuffer = preload("ring_buffer.gd")

var _buffer: RingBuffer = null

var _dirty: bool = false



var dirty: bool:
    get: return _dirty

func _init(maximum_lines: int = 500):
    _buffer = RingBuffer.new(maximum_lines)
    _dirty = false




func set_maximum_lines(maximum_lines: int) -> void :
    _buffer.set_maximum_lines(maximum_lines)



func add_history_entry(frame: int, text: String) -> void :
    _buffer.append("[%s]: %s \n" % [frame, text])
    _dirty = true



func add_transition(frame: int, name: String, from: String, to: String) -> void :
    add_history_entry(frame, "[»] Transition: %s from %s to %s" % [name, from, to])



func add_event(frame: int, event: StringName) -> void :
    add_history_entry(frame, "[!] Event received: %s" % event)



func add_state_entered(frame: int, name: StringName) -> void :
    add_history_entry(frame, "[>] Enter: %s" % name)



func add_state_exited(frame: int, name: StringName) -> void :
    add_history_entry(frame, "[<] Exit: %s" % name)



func clear() -> void :
    _buffer.clear()
    _dirty = true



func get_history_text() -> String:
    _dirty = false
    return _buffer.join()
