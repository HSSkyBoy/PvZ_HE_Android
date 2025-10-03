extends RefCounted


class_name NakamaSocket

const ChannelType = NakamaRTMessage.ChannelJoin.ChannelType


signal closed()


signal connected()


signal connection_error(p_error)


signal received_channel_message(p_channel_message)


signal received_channel_presence(p_channel_presence)


signal received_error(p_error)


signal received_matchmaker_matched(p_matchmaker_matched)


signal received_match_state(p_match_state)


signal received_match_presence(p_match_presence_event)


signal received_notification(p_api_notification)


signal received_status_presence(p_status_presence_event)


signal received_stream_presence(p_stream_presence_event)


signal received_stream_state(p_stream_state)



signal received_party(p_party)


signal received_party_close(p_party_close)


signal received_party_data(p_party_data)


signal received_party_join_request(p_party_join_request)


signal received_party_leader(p_party_leader)


signal received_party_matchmaker_ticket(p_party_matchmaker_ticket)


signal received_party_presence(p_party_presence_event)

var _adapter: NakamaSocketAdapter
var _free_adapter: bool = false
var _weak_ref: WeakRef
var _base_uri: String
var _requests: Dictionary
var _last_id: int = 1
var _conn = null
var logger: NakamaLogger = null

class AsyncConnection:
    signal completed(result)

    func resume(result) -> void :
        emit_signal("completed", result)

class AsyncRequest:
    var id: String
    var type
    var ns
    var result_key: String

    signal completed(result)

    func _init(p_id: String, p_type, p_ns, p_result_key = null):
        id = p_id
        type = p_type
        ns = p_ns

        if type != NakamaAsyncResult:

            result_key = p_result_key if p_result_key != null else type.get_result_key()

    func resume(data, logger = null) -> void :
        var result = _parse_result(data, logger)
        emit_signal("completed", result)

    func _parse_result(data, logger):

        if data is NakamaException:
            return type.new(data as NakamaException)


        if data.has("error"):
            var err = data["error"]
            var code = -1
            var msg = str(err)
            if typeof(err) == TYPE_DICTIONARY:
                msg = err.get("message", "")
                code = err.get("code", -1)
            if logger:
                logger.warning("Error response from server: %s" % err)
            return type.new(NakamaException.new(msg, code))

        elif type == NakamaAsyncResult:
            return NakamaAsyncResult.new()

        elif not data.has(result_key):
            if logger:
                logger.warning("Missing expected result key: %s" % result_key)
            return type.new(NakamaException.new("Missing expected result key: %s" % result_key))

        else:
            return type.create(ns, data.get(result_key))

func _resume_conn(p_err: int):
    if _conn:
        if p_err:
            logger.warning("Connection error: %d" % p_err)
            _conn.resume(NakamaAsyncResult.new(NakamaException.new()))
        else:
            logger.info("Connected!")
            _conn.resume(NakamaAsyncResult.new())
        _conn = null

func _init(p_adapter: NakamaSocketAdapter, 
        p_host: String, 
        p_port: int, 
        p_scheme: String, 
        p_free_adapter: bool = false):
    logger = p_adapter.logger
    _adapter = p_adapter
    _weak_ref = weakref(_adapter)
    var port = ""
    if (p_scheme == "ws" and p_port != 80) or (p_scheme == "wss" and p_port != 443):
        port = ":%d" % p_port
    _base_uri = "%s://%s%s" % [p_scheme, p_host, port]
    _free_adapter = p_free_adapter
    _adapter.closed.connect(self._closed)
    _adapter.connected.connect(self._connected)
    _adapter.received_error.connect(self._connection_error)
    _adapter.received.connect(self._received)

func _notification(what):
    if what == NOTIFICATION_PREDELETE:



        var keys = _requests.keys()
        for k in keys:
            _requests[k].resume(NakamaException.new("Cancelled!"))
        if _conn != null:
            _conn.resume(ERR_FILE_EOF)
        _conn = null
        if _weak_ref.get_ref() == null:
            return
        _adapter.close()
        if _free_adapter:
            _adapter.queue_free()

func _closed(p_error = null):
    emit_signal("closed")
    _resume_conn(ERR_CANT_CONNECT)
    _clear_requests()

func _connection_error(p_error):
    emit_signal("connection_error", p_error)
    _resume_conn(p_error)
    _clear_requests()

func _connected():
    emit_signal("connected")
    _resume_conn(OK)

func _received(p_bytes: PackedByteArray):
    var json = JSON.new()
    var json_str = p_bytes.get_string_from_utf8()
    var json_error: = json.parse(json_str)
    if json_error != OK or typeof(json.get_data()) != TYPE_DICTIONARY:
        logger.error("Unable to parse response: %s" % json_str)
        return
    var dict: Dictionary = json.get_data()
    var cid = dict.get("cid")
    if cid:
        if _requests.has(cid):
            _resume_request(cid, dict)
        else:
            logger.error("Invalid call id received %s" % dict)
    else:
        if dict.has("error"):
            var res = NakamaRTAPI.Error.create(NakamaRTAPI, dict["error"])
            emit_signal("received_error", res)
        elif dict.has("channel_message"):
            var res = NakamaAPI.ApiChannelMessage.create(NakamaAPI, dict["channel_message"])
            emit_signal("received_channel_message", res)
        elif dict.has("channel_presence_event"):
            var res = NakamaRTAPI.ChannelPresenceEvent.create(NakamaRTAPI, dict["channel_presence_event"])
            emit_signal("received_channel_presence", res)
        elif dict.has("match_data"):
            var res = NakamaRTAPI.MatchData.create(NakamaRTAPI, dict["match_data"])
            emit_signal("received_match_state", res)
        elif dict.has("match_presence_event"):
            var res = NakamaRTAPI.MatchPresenceEvent.create(NakamaRTAPI, dict["match_presence_event"])
            emit_signal("received_match_presence", res)
        elif dict.has("matchmaker_matched"):
            var res = NakamaRTAPI.MatchmakerMatched.create(NakamaRTAPI, dict["matchmaker_matched"])
            emit_signal("received_matchmaker_matched", res)
        elif dict.has("notifications"):
            var res = NakamaAPI.ApiNotificationList.create(NakamaAPI, dict["notifications"])
            for n in res.notifications:
                emit_signal("received_notification", n)
        elif dict.has("status_presence_event"):
            var res = NakamaRTAPI.StatusPresenceEvent.create(NakamaRTAPI, dict["status_presence_event"])
            emit_signal("received_status_presence", res)
        elif dict.has("stream_presence_event"):
            var res = NakamaRTAPI.StreamPresenceEvent.create(NakamaRTAPI, dict["stream_presence_event"])
            emit_signal("received_stream_presence", res)
        elif dict.has("stream_data"):
            var res = NakamaRTAPI.StreamData.create(NakamaRTAPI, dict["stream_data"])
            emit_signal("received_stream_state", res)
        elif dict.has("party"):
            var res = NakamaRTAPI.Party.create(NakamaRTAPI, dict["party"])
            emit_signal("received_party", res)
        elif dict.has("party_close"):
            var res = NakamaRTAPI.PartyClose.create(NakamaRTAPI, dict["party_close"])
            emit_signal("received_party_close", res)
        elif dict.has("party_data"):
            var res = NakamaRTAPI.PartyData.create(NakamaRTAPI, dict["party_data"])
            emit_signal("received_party_data", res)
        elif dict.has("party_join_request"):
            var res = NakamaRTAPI.PartyJoinRequest.create(NakamaRTAPI, dict["party_join_request"])
            emit_signal("received_party_join_request", res)
        elif dict.has("party_leader"):
            var res = NakamaRTAPI.PartyLeader.create(NakamaRTAPI, dict["party_leader"])
            emit_signal("received_party_leader", res)
        elif dict.has("party_matchmaker_ticket"):
            var res = NakamaRTAPI.PartyMatchmakerTicket.create(NakamaRTAPI, dict["party_matchmaker_ticket"])
            emit_signal("received_party_matchmaker_ticket", res)
        elif dict.has("party_presence_event"):
            var res = NakamaRTAPI.PartyPresenceEvent.create(NakamaRTAPI, dict["party_presence_event"])
            emit_signal("received_party_presence", res)
        else:
            logger.warning("Unhandled response: %s" % dict)

func _resume_request(p_id: String, p_data):
    if _requests.has(p_id):
        logger.debug("Resuming request: %s: %s" % [p_id, p_data])
        _requests[p_id].resume(p_data, logger)
        _requests.erase(p_id)
    else:
        logger.warning("Trying to resume missing request: %s: %s" % [p_id, p_data])

func _cancel_request(p_id: String):
    logger.debug("Cancelling request: %s" % [p_id])
    _resume_request(p_id, NakamaException.new("Request cancelled."))

func _clear_requests():
    var ids = _requests.keys()
    for id in ids:
        _cancel_request(id)

func _send_async(p_message, p_parse_type = NakamaAsyncResult, p_ns = NakamaRTAPI, p_msg_key = null, p_result_key = null) -> AsyncRequest:
    logger.debug("Sending async request: %s" % p_message)

    var msg = p_msg_key

    if msg == null:
        msg = p_message.get_msg_key()
    var id = str(_last_id)
    _last_id += 1

    _requests[id] = AsyncRequest.new(id, p_parse_type, p_ns, p_result_key)

    var json: = JSON.stringify({
        "cid": id, 
        msg: p_message.serialize()
    })
    var err = _adapter.send(json.to_utf8_buffer())
    if err != OK:
        call_deferred("_cancel_request", id)
    return _requests[id]


func is_connected_to_host():
    return _adapter.is_connected_to_host()


func is_connecting_to_host():
    return _adapter.is_connecting_to_host()


func close():
    _adapter.close()






func connect_async(p_session: NakamaSession, p_appear_online: bool = false, p_connect_timeout: int = 3):
    var uri = "%s/ws?lang=en&status=%s&token=%s" % [_base_uri, str(p_appear_online).to_lower(), p_session.token]
    logger.debug("Connecting to host: %s" % uri)
    _conn = AsyncConnection.new()
    _adapter.connect_to_host(uri, p_connect_timeout)
    return await _conn.completed









func add_matchmaker_async(p_query: String = "*", p_min_count: int = 2, p_max_count: int = 8, 
        p_string_props: Dictionary = {}, p_numeric_props: Dictionary = {}, 
        p_count_multiple: int = 0) -> NakamaRTAPI.MatchmakerTicket:
    return await _send_async(
        NakamaRTMessage.MatchmakerAdd.new(p_query, p_min_count, p_max_count, p_string_props, p_numeric_props, p_count_multiple), 
        NakamaRTAPI.MatchmakerTicket
    ).completed




func create_match_async(p_name: String = ""):
    return await _send_async(NakamaRTMessage.MatchCreate.new(p_name), NakamaRTAPI.Match).completed





func follow_users_async(p_ids: PackedStringArray, p_usernames: PackedStringArray) -> NakamaRTAPI.Status:
    return await _send_async(NakamaRTMessage.StatusFollow.new(p_ids, p_usernames), NakamaRTAPI.Status).completed







func join_chat_async(p_target: String, p_type: int, p_persistence: bool = false, p_hidden: bool = false) -> NakamaRTAPI.Channel:
    return await _send_async(
        NakamaRTMessage.ChannelJoin.new(p_target, p_type, p_persistence, p_hidden), 
        NakamaRTAPI.Channel
    ).completed




func join_matched_async(p_matched):
    var msg: = NakamaRTMessage.MatchJoin.new()
    if p_matched.match_id:
        msg.match_id = p_matched.match_id
    else:
        msg.token = p_matched.token
    return await _send_async(msg, NakamaRTAPI.Match).completed





func join_match_async(p_match_id: String, p_metadata = null):
    var msg: = NakamaRTMessage.MatchJoin.new()
    msg.match_id = p_match_id
    msg.metadata = p_metadata
    return await _send_async(msg, NakamaRTAPI.Match).completed




func leave_chat_async(p_channel_id: String) -> NakamaAsyncResult:
    return await _send_async(NakamaRTMessage.ChannelLeave.new(p_channel_id)).completed




func leave_match_async(p_match_id: String) -> NakamaAsyncResult:
    return await _send_async(NakamaRTMessage.MatchLeave.new(p_match_id)).completed





func remove_chat_message_async(p_channel_id: String, p_message_id: String):
    return await _send_async(
        NakamaRTMessage.ChannelMessageRemove.new(p_channel_id, p_message_id), 
        NakamaRTAPI.ChannelMessageAck
    ).completed




func remove_matchmaker_async(p_ticket: String) -> NakamaAsyncResult:
    return await _send_async(NakamaRTMessage.MatchmakerRemove.new(p_ticket)).completed





func rpc_async(p_func_id: String, p_payload = null) -> NakamaAPI.ApiRpc:
    var payload = p_payload
    match typeof(p_payload):
        TYPE_NIL, TYPE_STRING:
            pass
        _:
            payload = JSON.stringify(p_payload)
    return await _send_async(NakamaAPI.ApiRpc.create(NakamaAPI, {
        "id": p_func_id, 
        "payload": payload
    }), NakamaAPI.ApiRpc, NakamaAPI, "rpc", "rpc").completed








func send_match_state_async(p_match_id, p_op_code: int, p_data: String, p_presences = null):
    var req = _send_async(NakamaRTMessage.MatchDataSend.new(
        p_match_id, 
        p_op_code, 
        Marshalls.utf8_to_base64(p_data), 
        p_presences
    ))

    req.call_deferred("resume", {})
    return req.completed








func send_match_state_raw_async(p_match_id, p_op_code: int, p_data: PackedByteArray, p_presences = null):
    var req = _send_async(NakamaRTMessage.MatchDataSend.new(
        p_match_id, 
        p_op_code, 
        Marshalls.raw_to_base64(p_data), 
        p_presences
    ))

    req.call_deferred("resume", {})
    return req.completed




func unfollow_users_async(p_ids: PackedStringArray):
    return await _send_async(NakamaRTMessage.StatusUnfollow.new(p_ids)).completed






func update_chat_message_async(p_channel_id: String, p_message_id: String, p_content: Dictionary):
    return await _send_async(
        NakamaRTMessage.ChannelMessageUpdate.new(p_channel_id, p_message_id, JSON.stringify(p_content)), 
        NakamaRTAPI.ChannelMessageAck
    ).completed




func update_status_async(p_status: String):
    return await _send_async(NakamaRTMessage.StatusUpdate.new(p_status)).completed





func write_chat_message_async(p_channel_id: String, p_content: Dictionary):
    return await _send_async(
        NakamaRTMessage.ChannelMessageSend.new(p_channel_id, JSON.stringify(p_content)), 
        NakamaRTAPI.ChannelMessageAck
    ).completed





func accept_party_member_async(p_party_id: String, p_presence: NakamaRTAPI.UserPresence):
    return await _send_async(NakamaRTMessage.PartyAccept.new(p_party_id, p_presence)).completed










func add_matchmaker_party_async(p_party_id: String, p_query: String = "*", p_min_count: int = 2, 
    p_max_count: int = 8, p_string_properties = {}, p_numeric_properties = {}, p_count_multiple: int = 0):
    return await _send_async(
        NakamaRTMessage.PartyMatchmakerAdd.new(p_party_id, p_min_count, 
            p_max_count, p_query, p_string_properties, p_numeric_properties, 
            p_count_multiple if p_count_multiple > 0 else null), 
        NakamaRTAPI.PartyMatchmakerTicket).completed




func close_party_async(p_party_id: String):
    var msg: = NakamaRTAPI.PartyClose.new()
    msg.party_id = p_party_id
    return await _send_async(msg).completed





func create_party_async(p_open: bool, p_max_size: int) -> NakamaRTAPI.Party:
    return await _send_async(
        NakamaRTMessage.PartyCreate.new(p_open, p_max_size), 
        NakamaRTAPI.Party
    ).completed




func join_party_async(p_party_id: String):
    return await _send_async(NakamaRTMessage.PartyJoin.new(p_party_id)).completed




func leave_party_async(p_party_id: String):
    return await _send_async(NakamaRTMessage.PartyLeave.new(p_party_id)).completed




func list_party_join_requests_async(p_party_id: String) -> NakamaRTAPI.PartyJoinRequest:
    return await _send_async(
        NakamaRTMessage.PartyJoinRequestList.new(p_party_id), 
        NakamaRTAPI.PartyJoinRequest).completed





func promote_party_member(p_party_id: String, p_party_member: NakamaRTAPI.UserPresence):
    return await _send_async(NakamaRTMessage.PartyPromote.new(p_party_id, p_party_member)).completed





func remove_matchmaker_party_async(p_party_id: String, p_ticket: String):
    return await _send_async(NakamaRTMessage.PartyMatchmakerRemove.new(p_party_id, p_ticket)).completed





func remove_party_member_async(p_party_id: String, p_presence: NakamaRTAPI.UserPresence):
    return await _send_async(NakamaRTMessage.PartyRemove.new(p_party_id, p_presence)).completed






func send_party_data_async(p_party_id: String, p_op_code: int, p_data: String = ""):
    var base64_data = null if p_data.is_empty() else Marshalls.utf8_to_base64(p_data)
    return await _send_async(NakamaRTMessage.PartyDataSend.new(p_party_id, p_op_code, base64_data)).completed






func send_party_data_raw_async(p_party_id: String, p_op_code: int, p_data: PackedByteArray):
    var base64_data = null if p_data.is_empty() else Marshalls.raw_to_base64(p_data)
    return await _send_async(NakamaRTMessage.PartyDataSend.new(p_party_id, p_op_code, base64_data)).completed
