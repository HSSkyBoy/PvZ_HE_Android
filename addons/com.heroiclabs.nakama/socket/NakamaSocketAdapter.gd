@tool
extends Node


class_name NakamaSocketAdapter

var _ws: = WebSocketPeer.new()
var _ws_last_state: = WebSocketPeer.STATE_CLOSED
var _timeout: int = 30
var _start: int = 0
var logger = NakamaLogger.new()


signal connected()


signal closed()


signal received_error(p_exception)


signal received(p_bytes)


func is_connected_to_host():
    return _ws.get_ready_state() == WebSocketPeer.STATE_OPEN


func is_connecting_to_host():
    return _ws.get_ready_state() == WebSocketPeer.STATE_CONNECTING


func close():
    _ws.close()




func connect_to_host(p_uri: String, p_timeout: int):
    _timeout = p_timeout
    _start = Time.get_unix_time_from_system()
    var err = _ws.connect_to_url(p_uri)
    if err != OK:
        logger.debug("Error connecting to host %s" % p_uri)
        call_deferred("emit_signal", "received_error", err)
        return
    _ws_last_state = WebSocketPeer.STATE_CLOSED




func send(p_buffer: PackedByteArray, p_reliable: bool = true) -> int:
    return _ws.send(p_buffer, WebSocketPeer.WRITE_MODE_TEXT)

func _process(delta):
    if _ws.get_ready_state() != WebSocketPeer.STATE_CLOSED:
        _ws.poll()

    var state = _ws.get_ready_state()
    if _ws_last_state != state:
        _ws_last_state = state
        if state == WebSocketPeer.STATE_OPEN:
            connected.emit()
        elif state == WebSocketPeer.STATE_CLOSED:
            closed.emit()

    if state == WebSocketPeer.STATE_CONNECTING:
        if _start + _timeout < Time.get_unix_time_from_system():
            logger.debug("Timeout when connecting to socket")
            received_error.emit(ERR_TIMEOUT)
            _ws.close()

    while _ws.get_ready_state() == WebSocketPeer.STATE_OPEN and _ws.get_available_packet_count():
        received.emit(_ws.get_packet())
