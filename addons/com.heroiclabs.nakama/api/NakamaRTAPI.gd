extends NakamaAsyncResult

class_name NakamaRTAPI


class Channel extends NakamaAsyncResult:

    const _SCHEMA = {
        "id": {"name": "id", "type": TYPE_STRING, "required": true}, 
        "presences": {"name": "presences", "type": TYPE_ARRAY, "required": false, "content": "UserPresence"}, 
        "self": {"name": "self_presence", "type": "UserPresence", "required": true}, 
        "room_name": {"name": "room_name", "type": TYPE_STRING, "required": false}, 
        "group_id": {"name": "group_id", "type": TYPE_STRING, "required": false}, 
        "user_id_one": {"name": "user_id_one", "type": TYPE_STRING, "required": false}, 
        "user_id_two": {"name": "user_id_two", "type": TYPE_STRING, "required": false}
    }


    var id: String


    var presences: Array


    var self_presence: NakamaRTAPI.UserPresence


    var room_name: String


    var group_id: String


    var user_id_one: String


    var user_id_two: String

    func _init(p_ex = null):
        super (p_ex)

    func _to_string():
        if is_exception(): return get_exception()._to_string()
        return "Channel<id=%s, presences=%s, self=%s, room_name=%s, group_id=%s, user_id_one=%s, user_id_two=%s>" % [
            id, presences, self_presence, room_name, group_id, user_id_one, user_id_two
        ]

    static func create(p_ns: GDScript, p_dict: Dictionary) -> Channel:
        return _safe_ret(NakamaSerializer.deserialize(p_ns, "Channel", p_dict), Channel) as Channel

    static func get_result_key() -> String:
        return "channel"


class ChannelMessageAck extends NakamaAsyncResult:

    const _SCHEMA = {
        "channel_id": {"name": "channel_id", "type": TYPE_STRING, "required": true}, 
        "code": {"name": "code", "type": TYPE_INT, "required": true}, 
        "create_time": {"name": "create_time", "type": TYPE_STRING, "required": false}, 
        "message_id": {"name": "message_id", "type": TYPE_STRING, "required": true}, 
        "persistent": {"name": "persistent", "type": TYPE_BOOL, "required": false}, 
        "update_time": {"name": "update_time", "type": TYPE_STRING, "required": false}, 
        "username": {"name": "username", "type": TYPE_STRING, "required": false}, 
        "room_name": {"name": "room_name", "type": TYPE_STRING, "required": false}, 
        "group_id": {"name": "group_id", "type": TYPE_STRING, "required": false}, 
        "user_id_one": {"name": "user_id_one", "type": TYPE_STRING, "required": false}, 
        "user_id_two": {"name": "user_id_two", "type": TYPE_STRING, "required": false}
    }


    var channel_id: String


    var code: int


    var create_time: String


    var message_id: String


    var persistent: bool


    var update_time: String


    var username: String


    var room_name: String


    var group_id: String


    var user_id_one: String


    var user_id_two: String

    func _init(p_ex = null):
        super (p_ex)

    func _to_string():
        if is_exception(): return get_exception()._to_string()
        return "ChannelMessageAck<channel_id=%s, code=%d, create_time=%s, message_id=%s, persistent=%s, update_time=%s, username=%s room_name=%s, group_id=%s, user_id_one=%s, user_id_two=%s>" % [
            channel_id, code, create_time, message_id, persistent, update_time, username, room_name, group_id, user_id_one, user_id_two
        ]

    static func create(p_ns: GDScript, p_dict: Dictionary) -> ChannelMessageAck:
        return _safe_ret(NakamaSerializer.deserialize(p_ns, "ChannelMessageAck", p_dict), ChannelMessageAck) as ChannelMessageAck

    static func get_result_key() -> String:
        return "channel_message_ack"



class ChannelPresenceEvent extends NakamaAsyncResult:

    const _SCHEMA = {
        "channel_id": {"name": "channel_id", "type": TYPE_STRING, "required": true}, 
        "joins": {"name": "joins", "type": TYPE_ARRAY, "required": false, "content": "UserPresence"}, 
        "leaves": {"name": "leaves", "type": TYPE_ARRAY, "required": false, "content": "UserPresence"}, 
        "room_name": {"name": "room_name", "type": TYPE_STRING, "required": false}, 
        "group_id": {"name": "group_id", "type": TYPE_STRING, "required": false}, 
        "user_id_one": {"name": "user_id_one", "type": TYPE_STRING, "required": false}, 
        "user_id_two": {"name": "user_id_two", "type": TYPE_STRING, "required": false}
    }


    var channel_id: String


    var joins: Array


    var leaves: Array


    var room_name: String


    var group_id: String


    var user_id_one: String


    var user_id_two: String

    func _init(p_ex = null):
        super (p_ex)

    func _to_string():
        if is_exception(): return get_exception()._to_string()
        return "ChannelPresenceEvent<channel_id=%s, joins=%s, leaves=%s, room_name=%s, group_id=%s, user_id_one=%s, user_id_two=%s>" % [
            channel_id, joins, leaves, room_name, group_id, user_id_one, user_id_two
        ]

    static func create(p_ns: GDScript, p_dict: Dictionary) -> ChannelPresenceEvent:
        return _safe_ret(NakamaSerializer.deserialize(p_ns, "ChannelPresenceEvent", p_dict), ChannelPresenceEvent) as ChannelPresenceEvent

    static func get_result_key() -> String:
        return "channel_presence_event"



class Error extends NakamaAsyncResult:

    const _SCHEMA = {
        "code": {"name": "code", "type": TYPE_INT, "required": true}, 
        "message": {"name": "message", "type": TYPE_STRING, "required": true}, 
        "context": {"name": "context", "type": TYPE_DICTIONARY, "required": false, "content": TYPE_STRING}, 
    }


    enum Code{

        RUNTIME_EXCEPTION = 0, 

        UNRECOGNIZED_PAYLOAD = 1, 

        MISSING_PAYLOAD = 2, 

        BAD_INPUT = 3, 

        MATCH_NOT_FOUND = 4, 

        MATCH_JOIN_REJECTED = 5, 

        RUNTIME_FUNCTION_NOT_FOUND = 6, 

        RUNTIME_FUNCTION_EXCEPTION = 7, 
    }


    var code: int


    var message: String


    var context: Dictionary

    func _init(p_ex = null):
        super (p_ex)

    func _to_string():
        if is_exception(): return get_exception()._to_string()
        return "Error<code=%s, messages=%s, context=%s>" % [code, message, context]

    static func create(p_ns: GDScript, p_dict: Dictionary) -> Error:
        return _safe_ret(NakamaSerializer.deserialize(p_ns, "Error", p_dict), Error) as Error

    static func get_result_key() -> String:
        return "error"



class Match extends NakamaAsyncResult:

    const _SCHEMA = {
        "authoritative": {"name": "authoritative", "type": TYPE_BOOL, "required": false}, 
        "match_id": {"name": "match_id", "type": TYPE_STRING, "required": true}, 
        "label": {"name": "label", "type": TYPE_STRING, "required": false}, 
        "presences": {"name": "presences", "type": TYPE_ARRAY, "required": false, "content": "UserPresence"}, 
        "size": {"name": "size", "type": TYPE_INT, "required": false}, 
        "self": {"name": "self_user", "type": "UserPresence", "required": true}
    }


    var authoritative: bool


    var match_id: String


    var label: String


    var presences: Array


    var size: int


    var self_user: UserPresence

    func _init(p_ex = null):
        super (p_ex)

    static func create(p_ns: GDScript, p_dict: Dictionary):
        return _safe_ret(NakamaSerializer.deserialize(p_ns, "Match", p_dict), Match) as Match

    func _to_string():
        if is_exception(): return get_exception()._to_string()
        return "Match<authoritative=%s, match_id=%s, label=%s, presences=%s, size=%d, self=%s>" % [authoritative, match_id, label, presences, size, self_user]

    static func get_result_key() -> String:
        return "match"



class MatchData extends NakamaAsyncResult:
    const _SCHEMA = {
        "match_id": {"name": "match_id", "type": TYPE_STRING, "required": true}, 
        "presence": {"name": "presence", "type": "UserPresence", "required": false}, 
        "op_code": {"name": "op_code", "type": TYPE_INT, "required": false}, 
        "data": {"name": "data", "type": TYPE_STRING, "required": false}
    }


    var match_id: String



    var op_code: int = 0


    var presence: UserPresence


    var base64_data: String


    var _data
    var data: String:
        get:
            if _data == null and base64_data != "":
                _data = Marshalls.base64_to_utf8(base64_data)
            return _data if _data != null else ""
        set(v):
            _data = v


    var _binary_data
    var binary_data: PackedByteArray:
        get:
            if _binary_data == null and base64_data != "":
                _binary_data = Marshalls.base64_to_raw(base64_data)
            return _binary_data

    func _init(p_ex = null):
        super (p_ex)

    func _to_string():
        if is_exception(): return get_exception()._to_string()
        return "MatchData<match_id=%s, op_code=%s, presence=%s, data=%s>" % [match_id, op_code, presence, data]

    static func create(p_ns: GDScript, p_dict: Dictionary) -> MatchData:
        var out = _safe_ret(NakamaSerializer.deserialize(p_ns, "MatchData", p_dict), MatchData) as MatchData

        if out._data != null:
            out.base64_data = out._data
            out._data = null
        return out

    static func get_result_key() -> String:
        return "match_data"



class MatchPresenceEvent extends NakamaAsyncResult:
    const _SCHEMA = {
        "match_id": {"name": "match_id", "type": TYPE_STRING, "required": true}, 
        "joins": {"name": "joins", "type": TYPE_ARRAY, "required": false, "content": "UserPresence"}, 
        "leaves": {"name": "leaves", "type": TYPE_ARRAY, "required": false, "content": "UserPresence"}, 
    }


    var joins: Array


    var leaves: Array


    var match_id: String

    func _init(p_ex = null):
        super (p_ex)

    func _to_string():
        if is_exception(): return get_exception()._to_string()
        return "MatchPresenceEvent<match_id=%s, joins=%s, leaves=%s>" % [match_id, joins, leaves]

    static func create(p_ns: GDScript, p_dict: Dictionary) -> MatchPresenceEvent:
        return _safe_ret(NakamaSerializer.deserialize(p_ns, "MatchPresenceEvent", p_dict), MatchPresenceEvent) as MatchPresenceEvent

    static func get_result_key() -> String:
        return "match_presence_event"



class MatchmakerMatched extends NakamaAsyncResult:

    const _SCHEMA = {
        "match_id": {"name": "match_id", "type": TYPE_STRING, "required": false}, 
        "ticket": {"name": "ticket", "type": TYPE_STRING, "required": true}, 
        "token": {"name": "token", "type": TYPE_STRING, "required": false}, 
        "users": {"name": "users", "type": TYPE_ARRAY, "required": false, "content": "MatchmakerUser"}, 
        "self": {"name": "self_user", "type": "MatchmakerUser", "required": true}
    }



    var match_id: String


    var ticket: String


    var token: String


    var users: Array


    var self_user: MatchmakerUser

    func _init(p_ex = null):
        super (p_ex)

    func _to_string():
        if is_exception(): return get_exception()._to_string()
        return "<MatchmakerMatched match_id=%s, ticket=%s, token=%s, users=%s, self=%s>" % [
            match_id, ticket, token, users, self_user
        ]

    static func create(p_ns: GDScript, p_dict: Dictionary) -> MatchmakerMatched:
        return _safe_ret(NakamaSerializer.deserialize(p_ns, "MatchmakerMatched", p_dict), MatchmakerMatched) as MatchmakerMatched

    static func get_result_key() -> String:
        return "matchmaker_matched"



class MatchmakerTicket extends NakamaAsyncResult:

    const _SCHEMA = {
        "ticket": {"name": "ticket", "type": TYPE_STRING, "required": true}
    }


    var ticket: String

    func _init(p_ex = null):
        super (p_ex)

    static func create(p_ns: GDScript, p_dict: Dictionary) -> MatchmakerTicket:
        return _safe_ret(NakamaSerializer.deserialize(p_ns, "MatchmakerTicket", p_dict), MatchmakerTicket) as MatchmakerTicket

    func _to_string():
        if is_exception(): return get_exception()._to_string()
        return "<MatchmakerTicket ticket=%s>" % ticket

    static func get_result_key() -> String:
        return "matchmaker_ticket"



class MatchmakerUser extends NakamaAsyncResult:

    const _SCHEMA = {
        "presence": {"name": "presence", "type": "UserPresence", "required": true}, 
        "party_id": {"name": "party_id", "type": TYPE_STRING, "required": false}, 
        "string_properties": {"name": "string_properties", "type": TYPE_DICTIONARY, "required": false, "content": TYPE_STRING}, 
        "numeric_properties": {"name": "numeric_properties", "type": TYPE_DICTIONARY, "required": false, "content": TYPE_FLOAT}, 
    }


    var presence: UserPresence


    var party_id: String


    var numeric_properties: Dictionary


    var string_properties: Dictionary

    func _init(p_ex = null):
        super (p_ex)

    func _to_string():
        if is_exception(): return get_exception()._to_string()
        return "<MatchmakerUser presence=%s, numeric_properties=%s, string_properties=%s>" % [
            presence, numeric_properties, string_properties]

    static func create(p_ns: GDScript, p_dict: Dictionary) -> MatchmakerUser:
        return _safe_ret(NakamaSerializer.deserialize(p_ns, "MatchmakerUser", p_dict), MatchmakerUser) as MatchmakerUser

    static func get_result_key() -> String:
        return "matchmaker_user"



class Status extends NakamaAsyncResult:

    const _SCHEMA = {
        "presences": {"name": "presences", "type": TYPE_ARRAY, "required": true, "content": "UserPresence"}, 
    }


    var presences: = Array()

    func _init(p_ex = null):
        super (p_ex)

    static func create(p_ns: GDScript, p_dict: Dictionary) -> Status:
        return _safe_ret(NakamaSerializer.deserialize(p_ns, "Status", p_dict), Status) as Status

    func _to_string():
        if is_exception(): return get_exception()._to_string()
        return "<Status presences=%s>" % [presences]

    static func get_result_key() -> String:
        return "status"



class StatusPresenceEvent extends NakamaAsyncResult:
    const _SCHEMA = {
        "joins": {"name": "joins", "type": TYPE_ARRAY, "required": false, "content": "UserPresence"}, 
        "leaves": {"name": "leaves", "type": TYPE_ARRAY, "required": false, "content": "UserPresence"}, 
    }



    var joins: Array



    var leaves: Array

    func _init(p_ex = null):
        super (p_ex)

    func _to_string():
        if is_exception(): return get_exception()._to_string()
        return "StatusPresenceEvent<joins=%s, leaves=%s>" % [joins, leaves]

    static func create(p_ns: GDScript, p_dict: Dictionary) -> StatusPresenceEvent:
        return _safe_ret(NakamaSerializer.deserialize(p_ns, "StatusPresenceEvent", p_dict), StatusPresenceEvent) as StatusPresenceEvent

    static func get_result_key() -> String:
        return "status_presence_event"



class Stream extends NakamaAsyncResult:

    const _SCHEMA = {
        "mode": {"name": "mode", "type": TYPE_INT, "required": true}, 
        "subject": {"name": "subject", "type": TYPE_STRING, "required": false}, 
        "subcontext": {"name": "subcontext", "type": TYPE_STRING, "required": false}, 
        "label": {"name": "label", "type": TYPE_STRING, "required": false}, 
    }


    var mode: int


    var subject: String


    var subcontext: String


    var label: String

    func _init(p_ex = null):
        super (p_ex)

    func _to_string():
        if is_exception(): return get_exception()._to_string()
        return "Stream<mode=%s, subject=%s, subcontext=%s, label=%s>" % [mode, subject, subcontext, label]

    static func create(p_ns: GDScript, p_dict: Dictionary) -> Stream:
        return _safe_ret(NakamaSerializer.deserialize(p_ns, "Stream", p_dict), Stream) as Stream

    static func get_result_key() -> String:
        return "stream"





class StreamPresenceEvent extends NakamaAsyncResult:
    const _SCHEMA = {
        "stream": {"name": "stream", "type": "Stream", "required": true}, 
        "joins": {"name": "joins", "type": TYPE_ARRAY, "required": false, "content": "UserPresence"}, 
        "leaves": {"name": "leaves", "type": TYPE_ARRAY, "required": false, "content": "UserPresence"}, 
    }


    var joins: Array


    var leaves: Array


    var stream: Stream = null

    func _to_string():
        if is_exception(): return get_exception()._to_string()
        return "StreamPresenceEvent<stream=%s, joins=%s, leaves=%s>" % [stream, joins, leaves]

    static func create(p_ns: GDScript, p_dict: Dictionary) -> StreamPresenceEvent:
        return _safe_ret(NakamaSerializer.deserialize(p_ns, "StreamPresenceEvent", p_dict), StreamPresenceEvent) as StreamPresenceEvent

    static func get_result_key() -> String:
        return "stream_presence_event"



class StreamData extends NakamaAsyncResult:

    const _SCHEMA = {
        "stream": {"name": "stream", "type": "Stream", "required": true}, 
        "sender": {"name": "sender", "type": "UserPresence", "required": false}, 
        "data": {"name": "state", "type": TYPE_STRING, "required": false}, 
        "reliable": {"name": "reliable", "type": TYPE_BOOL, "required": false}, 
    }


    var sender: UserPresence = null


    var state: String


    var stream: Stream


    var reliable: bool

    func _to_string():
        if is_exception(): return get_exception()._to_string()
        return "StreamData<sender=%s, state=%s, stream=%s>" % [sender, state, stream]

    static func create(p_ns: GDScript, p_dict: Dictionary) -> StreamData:
        return _safe_ret(NakamaSerializer.deserialize(p_ns, "StreamData", p_dict), StreamData) as StreamData

    static func get_result_key() -> String:
        return "stream_data"





class UserPresence extends NakamaAsyncResult:

    const _SCHEMA = {
        "persistence": {"name": "persistence", "type": TYPE_BOOL, "required": false}, 
        "session_id": {"name": "session_id", "type": TYPE_STRING, "required": true}, 
        "status": {"name": "status", "type": TYPE_STRING, "required": false}, 
        "username": {"name": "username", "type": TYPE_STRING, "required": false}, 
        "user_id": {"name": "user_id", "type": TYPE_STRING, "required": true}, 
    }


    var persistence: bool


    var session_id: String


    var status: String


    var username: String


    var user_id: String

    func _init(p_ex = null):
        super (p_ex)

    func serialize() -> Dictionary:
        return NakamaSerializer.serialize(self)

    func _to_string():
        if is_exception(): return get_exception()._to_string()
        return "UserPresence<persistence=%s, session_id=%s, status=%s, username=%s, user_id=%s>" % [
            persistence, session_id, status, username, user_id]

    static func create(p_ns: GDScript, p_dict: Dictionary) -> UserPresence:
        return _safe_ret(NakamaSerializer.deserialize(p_ns, "UserPresence", p_dict), UserPresence) as UserPresence

    static func get_result_key() -> String:
        return "user_presence"


class Party extends NakamaAsyncResult:

    const _SCHEMA = {
        "party_id": {"name": "party_id", "type": TYPE_STRING, "required": true}, 
        "open": {"name": "open", "type": TYPE_BOOL, "required": false}, 
        "max_size": {"name": "max_size", "type": TYPE_INT, "required": true}, 
        "self": {"name": "self_presence", "type": "UserPresence", "required": true}, 
        "leader": {"name": "leader", "type": "UserPresence", "required": true}, 
        "presences": {"name": "presences", "type": TYPE_ARRAY, "required": false, "content": "UserPresence"}, 
    }


    var party_id: String


    var open: bool = false


    var max_size: int


    var self_presence: NakamaRTAPI.UserPresence


    var leader: NakamaRTAPI.UserPresence


    var presences: Array

    func _init(p_ex = null):
        super (p_ex)

    func serialize() -> Dictionary:
        return NakamaSerializer.serialize(self)

    func _to_string():
        if is_exception(): return get_exception()._to_string()
        return "Party<party_id=%s, open=%s, max_size=%d, self=%s, leader=%s, presences=%s>" % [
            party_id, open, max_size, self_presence, leader, presences]

    static func create(p_ns: GDScript, p_dict: Dictionary) -> Party:
        return _safe_ret(NakamaSerializer.deserialize(p_ns, "Party", p_dict), Party) as Party

    static func get_result_key() -> String:
        return "party"



class PartyPresenceEvent extends NakamaAsyncResult:
    const _SCHEMA = {
        "party_id": {"name": "party_id", "type": TYPE_STRING, "required": true}, 
        "joins": {"name": "joins", "type": TYPE_ARRAY, "required": false, "content": "UserPresence"}, 
        "leaves": {"name": "leaves", "type": TYPE_ARRAY, "required": false, "content": "UserPresence"}, 
    }

    var party_id: String

    var joins: Array

    var leaves: Array

    func _init(p_ex = null):
        super (p_ex)

    func serialize() -> Dictionary:
        return NakamaSerializer.serialize(self)

    func _to_string():
        if is_exception(): return get_exception()._to_string()
        return "PartyPresenceEvent<party_id=%s, joins=%s, leaves=%s>" % [party_id, joins, leaves]

    static func create(p_ns: GDScript, p_dict: Dictionary) -> PartyPresenceEvent:
        return _safe_ret(NakamaSerializer.deserialize(p_ns, "PartyPresenceEvent", p_dict), PartyPresenceEvent) as PartyPresenceEvent

    static func get_result_key() -> String:
        return "party_presence_event"



class PartyLeader extends NakamaAsyncResult:
    const _SCHEMA = {
        "party_id": {"name": "party_id", "type": TYPE_STRING, "required": true}, 
        "presence": {"name": "presence", "type": "UserPresence", "required": true}, 
    }

    var party_id: String

    var presence: NakamaRTAPI.UserPresence

    func _init(p_ex = null):
        super (p_ex)

    func serialize() -> Dictionary:
        return NakamaSerializer.serialize(self)

    func _to_string():
        if is_exception(): return get_exception()._to_string()
        return "PartyLeader<party_id=%s, presence=%s>" % [party_id, presence]

    static func create(p_ns: GDScript, p_dict: Dictionary) -> PartyLeader:
        return _safe_ret(NakamaSerializer.deserialize(p_ns, "PartyLeader", p_dict), PartyLeader) as PartyLeader

    static func get_result_key() -> String:
        return "party_leader"



class PartyJoinRequest extends NakamaAsyncResult:
    const _SCHEMA = {
        "party_id": {"name": "party_id", "type": TYPE_STRING, "required": true}, 
        "presences": {"name": "presences", "type": TYPE_ARRAY, "required": false, "content": "UserPresence"}, 
    }

    var party_id: String

    var presences: Array

    func _init(p_ex = null):
        super (p_ex)

    func serialize() -> Dictionary:
        return NakamaSerializer.serialize(self)

    func _to_string():
        if is_exception(): return get_exception()._to_string()
        return "PartyJoinRequest<party_id=%s, presences=%s>" % [party_id, presences]

    static func create(p_ns: GDScript, p_dict: Dictionary) -> PartyJoinRequest:
        return _safe_ret(NakamaSerializer.deserialize(p_ns, "PartyJoinRequest", p_dict), PartyJoinRequest) as PartyJoinRequest

    static func get_result_key() -> String:
        return "party_join_request"



class PartyMatchmakerTicket extends NakamaAsyncResult:
    const _SCHEMA = {
        "party_id": {"name": "party_id", "type": TYPE_STRING, "required": true}, 
        "ticket": {"name": "ticket", "type": TYPE_STRING, "required": true}, 
    }

    var party_id: String

    var ticket: String

    func _init(p_ex = null):
        super (p_ex)

    func serialize() -> Dictionary:
        return NakamaSerializer.serialize(self)

    func _to_string():
        if is_exception(): return get_exception()._to_string()
        return "PartyMatchmakerTicket<party_id=%s, ticket=%s>" % [party_id, ticket]

    static func create(p_ns: GDScript, p_dict: Dictionary) -> PartyMatchmakerTicket:
        return _safe_ret(NakamaSerializer.deserialize(p_ns, "PartyMatchmakerTicket", p_dict), PartyMatchmakerTicket) as PartyMatchmakerTicket

    static func get_result_key() -> String:
        return "party_matchmaker_ticket"



class PartyData extends NakamaAsyncResult:
    const _SCHEMA = {
        "party_id": {"name": "party_id", "type": TYPE_STRING, "required": true}, 
        "presence": {"name": "presence", "type": "UserPresence", "required": false}, 
        "op_code": {"name": "op_code", "type": TYPE_INT, "required": true}, 
        "data": {"name": "data", "type": TYPE_STRING, "required": false}
    }

    var party_id: String

    var presence: NakamaRTAPI.UserPresence

    var op_code: int


    var base64_data: String


    var _data
    var data: String:
        get:
            if _data == null and base64_data != "":
                _data = Marshalls.base64_to_utf8(base64_data)
            return _data if _data != null else ""
        set(v):
            _data = v


    var _binary_data
    var binary_data: PackedByteArray:
        get:
            if _binary_data == null and base64_data != "":
                _binary_data = Marshalls.base64_to_raw(base64_data)
            return _binary_data

    func _init(p_ex = null):
        super (p_ex)

    func serialize() -> Dictionary:
        return NakamaSerializer.serialize(self)

    func _to_string():
        if is_exception(): return get_exception()._to_string()
        return "PartyData<party_id=%s, presence=%s, op_code=%d, data%s>" % [party_id, presence, op_code, data]

    static func create(p_ns: GDScript, p_dict: Dictionary) -> PartyData:
        var out: = _safe_ret(NakamaSerializer.deserialize(p_ns, "PartyData", p_dict), PartyData) as PartyData

        if out._data != null:
            out.base64_data = out._data
            out._data = null
        return out

    static func get_result_key() -> String:
        return "party_data"


class PartyClose extends NakamaAsyncResult:
    const _SCHEMA = {
        "party_id": {"name": "party_id", "type": TYPE_STRING, "required": true}, 
    }

    var party_id: String

    func _init(p_ex = null):
        super (p_ex)

    func serialize():
        return NakamaSerializer.serialize(self)

    func get_msg_key() -> String:
        return "party_close"

    func _to_string():
        if is_exception(): return get_exception()._to_string()
        return "PartyClose<party_id=%s>" % [party_id]

    static func create(p_ns: GDScript, p_dict: Dictionary) -> PartyClose:
        return _safe_ret(NakamaSerializer.deserialize(p_ns, "PartyClose", p_dict), PartyClose) as PartyClose

    static func get_result_key() -> String:
        return "party_close"
