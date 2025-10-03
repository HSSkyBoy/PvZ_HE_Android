

extends RefCounted
class_name NakamaAPI


class GroupUserListGroupUser extends NakamaAsyncResult:

    const _SCHEMA = {
        "state": {"name": "_state", "type": TYPE_INT, "required": false}, 
        "user": {"name": "_user", "type": "ApiUser", "required": false}, 
    }


    var _state
    var state: int:
        get:
            return 0 if not _state is int else int(_state)


    var _user
    var user: ApiUser:
        get:
            return _user as ApiUser

    func _init(p_exception = null):
        super (p_exception)

    static func create(p_ns: GDScript, p_dict: Dictionary) -> GroupUserListGroupUser:
        return _safe_ret(NakamaSerializer.deserialize(p_ns, "GroupUserListGroupUser", p_dict), GroupUserListGroupUser) as GroupUserListGroupUser

    func serialize() -> Dictionary:
        return NakamaSerializer.serialize(self)

    func _to_string() -> String:
        if is_exception():
            return get_exception()._to_string()
        var output: String = ""
        output += "state: %s, " % _state
        output += "user: %s, " % _user
        return output


class UserGroupListUserGroup extends NakamaAsyncResult:

    const _SCHEMA = {
        "group": {"name": "_group", "type": "ApiGroup", "required": false}, 
        "state": {"name": "_state", "type": TYPE_INT, "required": false}, 
    }


    var _group
    var group: ApiGroup:
        get:
            return _group as ApiGroup


    var _state
    var state: int:
        get:
            return 0 if not _state is int else int(_state)

    func _init(p_exception = null):
        super (p_exception)

    static func create(p_ns: GDScript, p_dict: Dictionary) -> UserGroupListUserGroup:
        return _safe_ret(NakamaSerializer.deserialize(p_ns, "UserGroupListUserGroup", p_dict), UserGroupListUserGroup) as UserGroupListUserGroup

    func serialize() -> Dictionary:
        return NakamaSerializer.serialize(self)

    func _to_string() -> String:
        if is_exception():
            return get_exception()._to_string()
        var output: String = ""
        output += "group: %s, " % _group
        output += "state: %s, " % _state
        return output


class WriteLeaderboardRecordRequestLeaderboardRecordWrite extends NakamaAsyncResult:

    const _SCHEMA = {
        "metadata": {"name": "_metadata", "type": TYPE_STRING, "required": false}, 
        "operator": {"name": "_operator", "type": TYPE_INT, "required": false}, 
        "score": {"name": "_score", "type": TYPE_STRING, "required": false}, 
        "subscore": {"name": "_subscore", "type": TYPE_STRING, "required": false}, 
    }


    var _metadata
    var metadata: String:
        get:
            return "" if not _metadata is String else String(_metadata)


    var _operator
    var operator: int:
        get:
            return ApiOperator.values()[0] if not ApiOperator.values().has(_operator) else _operator


    var _score
    var score: String:
        get:
            return "" if not _score is String else String(_score)


    var _subscore
    var subscore: String:
        get:
            return "" if not _subscore is String else String(_subscore)

    func _init(p_exception = null):
        super (p_exception)

    static func create(p_ns: GDScript, p_dict: Dictionary) -> WriteLeaderboardRecordRequestLeaderboardRecordWrite:
        return _safe_ret(NakamaSerializer.deserialize(p_ns, "WriteLeaderboardRecordRequestLeaderboardRecordWrite", p_dict), WriteLeaderboardRecordRequestLeaderboardRecordWrite) as WriteLeaderboardRecordRequestLeaderboardRecordWrite

    func serialize() -> Dictionary:
        return NakamaSerializer.serialize(self)

    func _to_string() -> String:
        if is_exception():
            return get_exception()._to_string()
        var output: String = ""
        output += "metadata: %s, " % _metadata
        output += "operator: %s, " % _operator
        output += "score: %s, " % _score
        output += "subscore: %s, " % _subscore
        return output


class WriteTournamentRecordRequestTournamentRecordWrite extends NakamaAsyncResult:

    const _SCHEMA = {
        "metadata": {"name": "_metadata", "type": TYPE_STRING, "required": false}, 
        "operator": {"name": "_operator", "type": TYPE_INT, "required": false}, 
        "score": {"name": "_score", "type": TYPE_STRING, "required": false}, 
        "subscore": {"name": "_subscore", "type": TYPE_STRING, "required": false}, 
    }


    var _metadata
    var metadata: String:
        get:
            return "" if not _metadata is String else String(_metadata)


    var _operator
    var operator: int:
        get:
            return ApiOperator.values()[0] if not ApiOperator.values().has(_operator) else _operator


    var _score
    var score: String:
        get:
            return "" if not _score is String else String(_score)


    var _subscore
    var subscore: String:
        get:
            return "" if not _subscore is String else String(_subscore)

    func _init(p_exception = null):
        super (p_exception)

    static func create(p_ns: GDScript, p_dict: Dictionary) -> WriteTournamentRecordRequestTournamentRecordWrite:
        return _safe_ret(NakamaSerializer.deserialize(p_ns, "WriteTournamentRecordRequestTournamentRecordWrite", p_dict), WriteTournamentRecordRequestTournamentRecordWrite) as WriteTournamentRecordRequestTournamentRecordWrite

    func serialize() -> Dictionary:
        return NakamaSerializer.serialize(self)

    func _to_string() -> String:
        if is_exception():
            return get_exception()._to_string()
        var output: String = ""
        output += "metadata: %s, " % _metadata
        output += "operator: %s, " % _operator
        output += "score: %s, " % _score
        output += "subscore: %s, " % _subscore
        return output


class ApiAccount extends NakamaAsyncResult:

    const _SCHEMA = {
        "custom_id": {"name": "_custom_id", "type": TYPE_STRING, "required": false}, 
        "devices": {"name": "_devices", "type": TYPE_ARRAY, "required": false, "content": "ApiAccountDevice"}, 
        "disable_time": {"name": "_disable_time", "type": TYPE_STRING, "required": false}, 
        "email": {"name": "_email", "type": TYPE_STRING, "required": false}, 
        "user": {"name": "_user", "type": "ApiUser", "required": false}, 
        "verify_time": {"name": "_verify_time", "type": TYPE_STRING, "required": false}, 
        "wallet": {"name": "_wallet", "type": TYPE_STRING, "required": false}, 
    }


    var _custom_id
    var custom_id: String:
        get:
            return "" if not _custom_id is String else String(_custom_id)


    var _devices
    var devices: Array:
        get:
            return Array() if not _devices is Array else Array(_devices)


    var _disable_time
    var disable_time: String:
        get:
            return "" if not _disable_time is String else String(_disable_time)


    var _email
    var email: String:
        get:
            return "" if not _email is String else String(_email)


    var _user
    var user: ApiUser:
        get:
            return _user as ApiUser


    var _verify_time
    var verify_time: String:
        get:
            return "" if not _verify_time is String else String(_verify_time)


    var _wallet
    var wallet: String:
        get:
            return "" if not _wallet is String else String(_wallet)

    var _wallet_dict = null
    var wallet_dict: Dictionary:
        get:
            if _wallet_dict == null:
                if _wallet == null:
                    return {}
                var json = JSON.new()
                if json.parse(_wallet) != OK:
                    return {}
                _wallet_dict = json.get_data()
            return _wallet_dict as Dictionary


    func _init(p_exception = null):
        super (p_exception)

    static func create(p_ns: GDScript, p_dict: Dictionary) -> ApiAccount:
        return _safe_ret(NakamaSerializer.deserialize(p_ns, "ApiAccount", p_dict), ApiAccount) as ApiAccount

    func serialize() -> Dictionary:
        return NakamaSerializer.serialize(self)

    func _to_string() -> String:
        if is_exception():
            return get_exception()._to_string()
        var output: String = ""
        output += "custom_id: %s, " % _custom_id
        output += "devices: %s, " % [_devices]
        output += "disable_time: %s, " % _disable_time
        output += "email: %s, " % _email
        output += "user: %s, " % _user
        output += "verify_time: %s, " % _verify_time
        output += "wallet: %s, " % _wallet
        return output


class ApiAccountApple extends NakamaAsyncResult:

    const _SCHEMA = {
        "token": {"name": "_token", "type": TYPE_STRING, "required": false}, 
        "vars": {"name": "_vars", "type": TYPE_DICTIONARY, "required": false, "content": TYPE_STRING}, 
    }


    var _token
    var token: String:
        get:
            return "" if not _token is String else String(_token)


    var _vars
    var vars: Dictionary:
        get:
            return Dictionary() if not _vars is Dictionary else _vars.duplicate()

    func _init(p_exception = null):
        super (p_exception)

    static func create(p_ns: GDScript, p_dict: Dictionary) -> ApiAccountApple:
        return _safe_ret(NakamaSerializer.deserialize(p_ns, "ApiAccountApple", p_dict), ApiAccountApple) as ApiAccountApple

    func serialize() -> Dictionary:
        return NakamaSerializer.serialize(self)

    func _to_string() -> String:
        if is_exception():
            return get_exception()._to_string()
        var output: String = ""
        output += "token: %s, " % _token
        var map_string: String = ""
        if typeof(_vars) == TYPE_DICTIONARY:
            for k in _vars:
                map_string += "{%s=%s}, " % [k, _vars[k]]
        output += "vars: [%s], " % map_string
        return output


class ApiAccountCustom extends NakamaAsyncResult:

    const _SCHEMA = {
        "id": {"name": "_id", "type": TYPE_STRING, "required": false}, 
        "vars": {"name": "_vars", "type": TYPE_DICTIONARY, "required": false, "content": TYPE_STRING}, 
    }


    var _id
    var id: String:
        get:
            return "" if not _id is String else String(_id)


    var _vars
    var vars: Dictionary:
        get:
            return Dictionary() if not _vars is Dictionary else _vars.duplicate()

    func _init(p_exception = null):
        super (p_exception)

    static func create(p_ns: GDScript, p_dict: Dictionary) -> ApiAccountCustom:
        return _safe_ret(NakamaSerializer.deserialize(p_ns, "ApiAccountCustom", p_dict), ApiAccountCustom) as ApiAccountCustom

    func serialize() -> Dictionary:
        return NakamaSerializer.serialize(self)

    func _to_string() -> String:
        if is_exception():
            return get_exception()._to_string()
        var output: String = ""
        output += "id: %s, " % _id
        var map_string: String = ""
        if typeof(_vars) == TYPE_DICTIONARY:
            for k in _vars:
                map_string += "{%s=%s}, " % [k, _vars[k]]
        output += "vars: [%s], " % map_string
        return output


class ApiAccountDevice extends NakamaAsyncResult:

    const _SCHEMA = {
        "id": {"name": "_id", "type": TYPE_STRING, "required": false}, 
        "vars": {"name": "_vars", "type": TYPE_DICTIONARY, "required": false, "content": TYPE_STRING}, 
    }


    var _id
    var id: String:
        get:
            return "" if not _id is String else String(_id)


    var _vars
    var vars: Dictionary:
        get:
            return Dictionary() if not _vars is Dictionary else _vars.duplicate()

    func _init(p_exception = null):
        super (p_exception)

    static func create(p_ns: GDScript, p_dict: Dictionary) -> ApiAccountDevice:
        return _safe_ret(NakamaSerializer.deserialize(p_ns, "ApiAccountDevice", p_dict), ApiAccountDevice) as ApiAccountDevice

    func serialize() -> Dictionary:
        return NakamaSerializer.serialize(self)

    func _to_string() -> String:
        if is_exception():
            return get_exception()._to_string()
        var output: String = ""
        output += "id: %s, " % _id
        var map_string: String = ""
        if typeof(_vars) == TYPE_DICTIONARY:
            for k in _vars:
                map_string += "{%s=%s}, " % [k, _vars[k]]
        output += "vars: [%s], " % map_string
        return output


class ApiAccountEmail extends NakamaAsyncResult:

    const _SCHEMA = {
        "email": {"name": "_email", "type": TYPE_STRING, "required": false}, 
        "password": {"name": "_password", "type": TYPE_STRING, "required": false}, 
        "vars": {"name": "_vars", "type": TYPE_DICTIONARY, "required": false, "content": TYPE_STRING}, 
    }


    var _email
    var email: String:
        get:
            return "" if not _email is String else String(_email)


    var _password
    var password: String:
        get:
            return "" if not _password is String else String(_password)


    var _vars
    var vars: Dictionary:
        get:
            return Dictionary() if not _vars is Dictionary else _vars.duplicate()

    func _init(p_exception = null):
        super (p_exception)

    static func create(p_ns: GDScript, p_dict: Dictionary) -> ApiAccountEmail:
        return _safe_ret(NakamaSerializer.deserialize(p_ns, "ApiAccountEmail", p_dict), ApiAccountEmail) as ApiAccountEmail

    func serialize() -> Dictionary:
        return NakamaSerializer.serialize(self)

    func _to_string() -> String:
        if is_exception():
            return get_exception()._to_string()
        var output: String = ""
        output += "email: %s, " % _email
        output += "password: %s, " % _password
        var map_string: String = ""
        if typeof(_vars) == TYPE_DICTIONARY:
            for k in _vars:
                map_string += "{%s=%s}, " % [k, _vars[k]]
        output += "vars: [%s], " % map_string
        return output


class ApiAccountFacebook extends NakamaAsyncResult:

    const _SCHEMA = {
        "token": {"name": "_token", "type": TYPE_STRING, "required": false}, 
        "vars": {"name": "_vars", "type": TYPE_DICTIONARY, "required": false, "content": TYPE_STRING}, 
    }


    var _token
    var token: String:
        get:
            return "" if not _token is String else String(_token)


    var _vars
    var vars: Dictionary:
        get:
            return Dictionary() if not _vars is Dictionary else _vars.duplicate()

    func _init(p_exception = null):
        super (p_exception)

    static func create(p_ns: GDScript, p_dict: Dictionary) -> ApiAccountFacebook:
        return _safe_ret(NakamaSerializer.deserialize(p_ns, "ApiAccountFacebook", p_dict), ApiAccountFacebook) as ApiAccountFacebook

    func serialize() -> Dictionary:
        return NakamaSerializer.serialize(self)

    func _to_string() -> String:
        if is_exception():
            return get_exception()._to_string()
        var output: String = ""
        output += "token: %s, " % _token
        var map_string: String = ""
        if typeof(_vars) == TYPE_DICTIONARY:
            for k in _vars:
                map_string += "{%s=%s}, " % [k, _vars[k]]
        output += "vars: [%s], " % map_string
        return output


class ApiAccountFacebookInstantGame extends NakamaAsyncResult:

    const _SCHEMA = {
        "signed_player_info": {"name": "_signed_player_info", "type": TYPE_STRING, "required": false}, 
        "vars": {"name": "_vars", "type": TYPE_DICTIONARY, "required": false, "content": TYPE_STRING}, 
    }


    var _signed_player_info
    var signed_player_info: String:
        get:
            return "" if not _signed_player_info is String else String(_signed_player_info)


    var _vars
    var vars: Dictionary:
        get:
            return Dictionary() if not _vars is Dictionary else _vars.duplicate()

    func _init(p_exception = null):
        super (p_exception)

    static func create(p_ns: GDScript, p_dict: Dictionary) -> ApiAccountFacebookInstantGame:
        return _safe_ret(NakamaSerializer.deserialize(p_ns, "ApiAccountFacebookInstantGame", p_dict), ApiAccountFacebookInstantGame) as ApiAccountFacebookInstantGame

    func serialize() -> Dictionary:
        return NakamaSerializer.serialize(self)

    func _to_string() -> String:
        if is_exception():
            return get_exception()._to_string()
        var output: String = ""
        output += "signed_player_info: %s, " % _signed_player_info
        var map_string: String = ""
        if typeof(_vars) == TYPE_DICTIONARY:
            for k in _vars:
                map_string += "{%s=%s}, " % [k, _vars[k]]
        output += "vars: [%s], " % map_string
        return output


class ApiAccountGameCenter extends NakamaAsyncResult:

    const _SCHEMA = {
        "bundle_id": {"name": "_bundle_id", "type": TYPE_STRING, "required": false}, 
        "player_id": {"name": "_player_id", "type": TYPE_STRING, "required": false}, 
        "public_key_url": {"name": "_public_key_url", "type": TYPE_STRING, "required": false}, 
        "salt": {"name": "_salt", "type": TYPE_STRING, "required": false}, 
        "signature": {"name": "_signature", "type": TYPE_STRING, "required": false}, 
        "timestamp_seconds": {"name": "_timestamp_seconds", "type": TYPE_STRING, "required": false}, 
        "vars": {"name": "_vars", "type": TYPE_DICTIONARY, "required": false, "content": TYPE_STRING}, 
    }


    var _bundle_id
    var bundle_id: String:
        get:
            return "" if not _bundle_id is String else String(_bundle_id)


    var _player_id
    var player_id: String:
        get:
            return "" if not _player_id is String else String(_player_id)


    var _public_key_url
    var public_key_url: String:
        get:
            return "" if not _public_key_url is String else String(_public_key_url)


    var _salt
    var salt: String:
        get:
            return "" if not _salt is String else String(_salt)


    var _signature
    var signature: String:
        get:
            return "" if not _signature is String else String(_signature)


    var _timestamp_seconds
    var timestamp_seconds: String:
        get:
            return "" if not _timestamp_seconds is String else String(_timestamp_seconds)


    var _vars
    var vars: Dictionary:
        get:
            return Dictionary() if not _vars is Dictionary else _vars.duplicate()

    func _init(p_exception = null):
        super (p_exception)

    static func create(p_ns: GDScript, p_dict: Dictionary) -> ApiAccountGameCenter:
        return _safe_ret(NakamaSerializer.deserialize(p_ns, "ApiAccountGameCenter", p_dict), ApiAccountGameCenter) as ApiAccountGameCenter

    func serialize() -> Dictionary:
        return NakamaSerializer.serialize(self)

    func _to_string() -> String:
        if is_exception():
            return get_exception()._to_string()
        var output: String = ""
        output += "bundle_id: %s, " % _bundle_id
        output += "player_id: %s, " % _player_id
        output += "public_key_url: %s, " % _public_key_url
        output += "salt: %s, " % _salt
        output += "signature: %s, " % _signature
        output += "timestamp_seconds: %s, " % _timestamp_seconds
        var map_string: String = ""
        if typeof(_vars) == TYPE_DICTIONARY:
            for k in _vars:
                map_string += "{%s=%s}, " % [k, _vars[k]]
        output += "vars: [%s], " % map_string
        return output


class ApiAccountGoogle extends NakamaAsyncResult:

    const _SCHEMA = {
        "token": {"name": "_token", "type": TYPE_STRING, "required": false}, 
        "vars": {"name": "_vars", "type": TYPE_DICTIONARY, "required": false, "content": TYPE_STRING}, 
    }


    var _token
    var token: String:
        get:
            return "" if not _token is String else String(_token)


    var _vars
    var vars: Dictionary:
        get:
            return Dictionary() if not _vars is Dictionary else _vars.duplicate()

    func _init(p_exception = null):
        super (p_exception)

    static func create(p_ns: GDScript, p_dict: Dictionary) -> ApiAccountGoogle:
        return _safe_ret(NakamaSerializer.deserialize(p_ns, "ApiAccountGoogle", p_dict), ApiAccountGoogle) as ApiAccountGoogle

    func serialize() -> Dictionary:
        return NakamaSerializer.serialize(self)

    func _to_string() -> String:
        if is_exception():
            return get_exception()._to_string()
        var output: String = ""
        output += "token: %s, " % _token
        var map_string: String = ""
        if typeof(_vars) == TYPE_DICTIONARY:
            for k in _vars:
                map_string += "{%s=%s}, " % [k, _vars[k]]
        output += "vars: [%s], " % map_string
        return output


class ApiAccountSteam extends NakamaAsyncResult:

    const _SCHEMA = {
        "token": {"name": "_token", "type": TYPE_STRING, "required": false}, 
        "vars": {"name": "_vars", "type": TYPE_DICTIONARY, "required": false, "content": TYPE_STRING}, 
    }


    var _token
    var token: String:
        get:
            return "" if not _token is String else String(_token)


    var _vars
    var vars: Dictionary:
        get:
            return Dictionary() if not _vars is Dictionary else _vars.duplicate()

    func _init(p_exception = null):
        super (p_exception)

    static func create(p_ns: GDScript, p_dict: Dictionary) -> ApiAccountSteam:
        return _safe_ret(NakamaSerializer.deserialize(p_ns, "ApiAccountSteam", p_dict), ApiAccountSteam) as ApiAccountSteam

    func serialize() -> Dictionary:
        return NakamaSerializer.serialize(self)

    func _to_string() -> String:
        if is_exception():
            return get_exception()._to_string()
        var output: String = ""
        output += "token: %s, " % _token
        var map_string: String = ""
        if typeof(_vars) == TYPE_DICTIONARY:
            for k in _vars:
                map_string += "{%s=%s}, " % [k, _vars[k]]
        output += "vars: [%s], " % map_string
        return output


class ApiChannelMessage extends NakamaAsyncResult:

    const _SCHEMA = {
        "channel_id": {"name": "_channel_id", "type": TYPE_STRING, "required": false}, 
        "code": {"name": "_code", "type": TYPE_INT, "required": false}, 
        "content": {"name": "_content", "type": TYPE_STRING, "required": false}, 
        "create_time": {"name": "_create_time", "type": TYPE_STRING, "required": false}, 
        "group_id": {"name": "_group_id", "type": TYPE_STRING, "required": false}, 
        "message_id": {"name": "_message_id", "type": TYPE_STRING, "required": false}, 
        "persistent": {"name": "_persistent", "type": TYPE_BOOL, "required": false}, 
        "room_name": {"name": "_room_name", "type": TYPE_STRING, "required": false}, 
        "sender_id": {"name": "_sender_id", "type": TYPE_STRING, "required": false}, 
        "update_time": {"name": "_update_time", "type": TYPE_STRING, "required": false}, 
        "user_id_one": {"name": "_user_id_one", "type": TYPE_STRING, "required": false}, 
        "user_id_two": {"name": "_user_id_two", "type": TYPE_STRING, "required": false}, 
        "username": {"name": "_username", "type": TYPE_STRING, "required": false}, 
    }


    var _channel_id
    var channel_id: String:
        get:
            return "" if not _channel_id is String else String(_channel_id)


    var _code
    var code: int:
        get:
            return 0 if not _code is int else int(_code)


    var _content
    var content: String:
        get:
            return "" if not _content is String else String(_content)


    var _create_time
    var create_time: String:
        get:
            return "" if not _create_time is String else String(_create_time)


    var _group_id
    var group_id: String:
        get:
            return "" if not _group_id is String else String(_group_id)


    var _message_id
    var message_id: String:
        get:
            return "" if not _message_id is String else String(_message_id)


    var _persistent
    var persistent: bool:
        get:
            return false if not _persistent is bool else bool(_persistent)


    var _room_name
    var room_name: String:
        get:
            return "" if not _room_name is String else String(_room_name)


    var _sender_id
    var sender_id: String:
        get:
            return "" if not _sender_id is String else String(_sender_id)


    var _update_time
    var update_time: String:
        get:
            return "" if not _update_time is String else String(_update_time)


    var _user_id_one
    var user_id_one: String:
        get:
            return "" if not _user_id_one is String else String(_user_id_one)


    var _user_id_two
    var user_id_two: String:
        get:
            return "" if not _user_id_two is String else String(_user_id_two)


    var _username
    var username: String:
        get:
            return "" if not _username is String else String(_username)

    func _init(p_exception = null):
        super (p_exception)

    static func create(p_ns: GDScript, p_dict: Dictionary) -> ApiChannelMessage:
        return _safe_ret(NakamaSerializer.deserialize(p_ns, "ApiChannelMessage", p_dict), ApiChannelMessage) as ApiChannelMessage

    func serialize() -> Dictionary:
        return NakamaSerializer.serialize(self)

    func _to_string() -> String:
        if is_exception():
            return get_exception()._to_string()
        var output: String = ""
        output += "channel_id: %s, " % _channel_id
        output += "code: %s, " % _code
        output += "content: %s, " % _content
        output += "create_time: %s, " % _create_time
        output += "group_id: %s, " % _group_id
        output += "message_id: %s, " % _message_id
        output += "persistent: %s, " % _persistent
        output += "room_name: %s, " % _room_name
        output += "sender_id: %s, " % _sender_id
        output += "update_time: %s, " % _update_time
        output += "user_id_one: %s, " % _user_id_one
        output += "user_id_two: %s, " % _user_id_two
        output += "username: %s, " % _username
        return output


class ApiChannelMessageList extends NakamaAsyncResult:

    const _SCHEMA = {
        "cacheable_cursor": {"name": "_cacheable_cursor", "type": TYPE_STRING, "required": false}, 
        "messages": {"name": "_messages", "type": TYPE_ARRAY, "required": false, "content": "ApiChannelMessage"}, 
        "next_cursor": {"name": "_next_cursor", "type": TYPE_STRING, "required": false}, 
        "prev_cursor": {"name": "_prev_cursor", "type": TYPE_STRING, "required": false}, 
    }


    var _cacheable_cursor
    var cacheable_cursor: String:
        get:
            return "" if not _cacheable_cursor is String else String(_cacheable_cursor)


    var _messages
    var messages: Array:
        get:
            return Array() if not _messages is Array else Array(_messages)


    var _next_cursor
    var next_cursor: String:
        get:
            return "" if not _next_cursor is String else String(_next_cursor)


    var _prev_cursor
    var prev_cursor: String:
        get:
            return "" if not _prev_cursor is String else String(_prev_cursor)

    func _init(p_exception = null):
        super (p_exception)

    static func create(p_ns: GDScript, p_dict: Dictionary) -> ApiChannelMessageList:
        return _safe_ret(NakamaSerializer.deserialize(p_ns, "ApiChannelMessageList", p_dict), ApiChannelMessageList) as ApiChannelMessageList

    func serialize() -> Dictionary:
        return NakamaSerializer.serialize(self)

    func _to_string() -> String:
        if is_exception():
            return get_exception()._to_string()
        var output: String = ""
        output += "cacheable_cursor: %s, " % _cacheable_cursor
        output += "messages: %s, " % [_messages]
        output += "next_cursor: %s, " % _next_cursor
        output += "prev_cursor: %s, " % _prev_cursor
        return output


class ApiCreateGroupRequest extends NakamaAsyncResult:

    const _SCHEMA = {
        "avatar_url": {"name": "_avatar_url", "type": TYPE_STRING, "required": false}, 
        "description": {"name": "_description", "type": TYPE_STRING, "required": false}, 
        "lang_tag": {"name": "_lang_tag", "type": TYPE_STRING, "required": false}, 
        "max_count": {"name": "_max_count", "type": TYPE_INT, "required": false}, 
        "name": {"name": "_name", "type": TYPE_STRING, "required": false}, 
        "open": {"name": "_open", "type": TYPE_BOOL, "required": false}, 
    }


    var _avatar_url
    var avatar_url: String:
        get:
            return "" if not _avatar_url is String else String(_avatar_url)


    var _description
    var description: String:
        get:
            return "" if not _description is String else String(_description)


    var _lang_tag
    var lang_tag: String:
        get:
            return "" if not _lang_tag is String else String(_lang_tag)


    var _max_count
    var max_count: int:
        get:
            return 0 if not _max_count is int else int(_max_count)


    var _name
    var name: String:
        get:
            return "" if not _name is String else String(_name)


    var _open
    var open: bool:
        get:
            return false if not _open is bool else bool(_open)

    func _init(p_exception = null):
        super (p_exception)

    static func create(p_ns: GDScript, p_dict: Dictionary) -> ApiCreateGroupRequest:
        return _safe_ret(NakamaSerializer.deserialize(p_ns, "ApiCreateGroupRequest", p_dict), ApiCreateGroupRequest) as ApiCreateGroupRequest

    func serialize() -> Dictionary:
        return NakamaSerializer.serialize(self)

    func _to_string() -> String:
        if is_exception():
            return get_exception()._to_string()
        var output: String = ""
        output += "avatar_url: %s, " % _avatar_url
        output += "description: %s, " % _description
        output += "lang_tag: %s, " % _lang_tag
        output += "max_count: %s, " % _max_count
        output += "name: %s, " % _name
        output += "open: %s, " % _open
        return output


class ApiDeleteStorageObjectId extends NakamaAsyncResult:

    const _SCHEMA = {
        "collection": {"name": "_collection", "type": TYPE_STRING, "required": false}, 
        "key": {"name": "_key", "type": TYPE_STRING, "required": false}, 
        "version": {"name": "_version", "type": TYPE_STRING, "required": false}, 
    }


    var _collection
    var collection: String:
        get:
            return "" if not _collection is String else String(_collection)


    var _key
    var key: String:
        get:
            return "" if not _key is String else String(_key)


    var _version
    var version: String:
        get:
            return "" if not _version is String else String(_version)

    func _init(p_exception = null):
        super (p_exception)

    static func create(p_ns: GDScript, p_dict: Dictionary) -> ApiDeleteStorageObjectId:
        return _safe_ret(NakamaSerializer.deserialize(p_ns, "ApiDeleteStorageObjectId", p_dict), ApiDeleteStorageObjectId) as ApiDeleteStorageObjectId

    func serialize() -> Dictionary:
        return NakamaSerializer.serialize(self)

    func _to_string() -> String:
        if is_exception():
            return get_exception()._to_string()
        var output: String = ""
        output += "collection: %s, " % _collection
        output += "key: %s, " % _key
        output += "version: %s, " % _version
        return output


class ApiDeleteStorageObjectsRequest extends NakamaAsyncResult:

    const _SCHEMA = {
        "object_ids": {"name": "_object_ids", "type": TYPE_ARRAY, "required": false, "content": "ApiDeleteStorageObjectId"}, 
    }


    var _object_ids
    var object_ids: Array:
        get:
            return Array() if not _object_ids is Array else Array(_object_ids)

    func _init(p_exception = null):
        super (p_exception)

    static func create(p_ns: GDScript, p_dict: Dictionary) -> ApiDeleteStorageObjectsRequest:
        return _safe_ret(NakamaSerializer.deserialize(p_ns, "ApiDeleteStorageObjectsRequest", p_dict), ApiDeleteStorageObjectsRequest) as ApiDeleteStorageObjectsRequest

    func serialize() -> Dictionary:
        return NakamaSerializer.serialize(self)

    func _to_string() -> String:
        if is_exception():
            return get_exception()._to_string()
        var output: String = ""
        output += "object_ids: %s, " % [_object_ids]
        return output


class ApiEvent extends NakamaAsyncResult:

    const _SCHEMA = {
        "external": {"name": "_external", "type": TYPE_BOOL, "required": false}, 
        "name": {"name": "_name", "type": TYPE_STRING, "required": false}, 
        "properties": {"name": "_properties", "type": TYPE_DICTIONARY, "required": false, "content": TYPE_STRING}, 
        "timestamp": {"name": "_timestamp", "type": TYPE_STRING, "required": false}, 
    }


    var _external
    var external: bool:
        get:
            return false if not _external is bool else bool(_external)


    var _name
    var name: String:
        get:
            return "" if not _name is String else String(_name)


    var _properties
    var properties: Dictionary:
        get:
            return Dictionary() if not _properties is Dictionary else _properties.duplicate()


    var _timestamp
    var timestamp: String:
        get:
            return "" if not _timestamp is String else String(_timestamp)

    func _init(p_exception = null):
        super (p_exception)

    static func create(p_ns: GDScript, p_dict: Dictionary) -> ApiEvent:
        return _safe_ret(NakamaSerializer.deserialize(p_ns, "ApiEvent", p_dict), ApiEvent) as ApiEvent

    func serialize() -> Dictionary:
        return NakamaSerializer.serialize(self)

    func _to_string() -> String:
        if is_exception():
            return get_exception()._to_string()
        var output: String = ""
        output += "external: %s, " % _external
        output += "name: %s, " % _name
        var map_string: String = ""
        if typeof(_properties) == TYPE_DICTIONARY:
            for k in _properties:
                map_string += "{%s=%s}, " % [k, _properties[k]]
        output += "properties: [%s], " % map_string
        output += "timestamp: %s, " % _timestamp
        return output


class ApiFriend extends NakamaAsyncResult:

    const _SCHEMA = {
        "state": {"name": "_state", "type": TYPE_INT, "required": false}, 
        "update_time": {"name": "_update_time", "type": TYPE_STRING, "required": false}, 
        "user": {"name": "_user", "type": "ApiUser", "required": false}, 
    }


    var _state
    var state: int:
        get:
            return 0 if not _state is int else int(_state)


    var _update_time
    var update_time: String:
        get:
            return "" if not _update_time is String else String(_update_time)


    var _user
    var user: ApiUser:
        get:
            return _user as ApiUser

    func _init(p_exception = null):
        super (p_exception)

    static func create(p_ns: GDScript, p_dict: Dictionary) -> ApiFriend:
        return _safe_ret(NakamaSerializer.deserialize(p_ns, "ApiFriend", p_dict), ApiFriend) as ApiFriend

    func serialize() -> Dictionary:
        return NakamaSerializer.serialize(self)

    func _to_string() -> String:
        if is_exception():
            return get_exception()._to_string()
        var output: String = ""
        output += "state: %s, " % _state
        output += "update_time: %s, " % _update_time
        output += "user: %s, " % _user
        return output


class ApiFriendList extends NakamaAsyncResult:

    const _SCHEMA = {
        "cursor": {"name": "_cursor", "type": TYPE_STRING, "required": false}, 
        "friends": {"name": "_friends", "type": TYPE_ARRAY, "required": false, "content": "ApiFriend"}, 
    }


    var _cursor
    var cursor: String:
        get:
            return "" if not _cursor is String else String(_cursor)


    var _friends
    var friends: Array:
        get:
            return Array() if not _friends is Array else Array(_friends)

    func _init(p_exception = null):
        super (p_exception)

    static func create(p_ns: GDScript, p_dict: Dictionary) -> ApiFriendList:
        return _safe_ret(NakamaSerializer.deserialize(p_ns, "ApiFriendList", p_dict), ApiFriendList) as ApiFriendList

    func serialize() -> Dictionary:
        return NakamaSerializer.serialize(self)

    func _to_string() -> String:
        if is_exception():
            return get_exception()._to_string()
        var output: String = ""
        output += "cursor: %s, " % _cursor
        output += "friends: %s, " % [_friends]
        return output


class ApiGroup extends NakamaAsyncResult:

    const _SCHEMA = {
        "avatar_url": {"name": "_avatar_url", "type": TYPE_STRING, "required": false}, 
        "create_time": {"name": "_create_time", "type": TYPE_STRING, "required": false}, 
        "creator_id": {"name": "_creator_id", "type": TYPE_STRING, "required": false}, 
        "description": {"name": "_description", "type": TYPE_STRING, "required": false}, 
        "edge_count": {"name": "_edge_count", "type": TYPE_INT, "required": false}, 
        "id": {"name": "_id", "type": TYPE_STRING, "required": false}, 
        "lang_tag": {"name": "_lang_tag", "type": TYPE_STRING, "required": false}, 
        "max_count": {"name": "_max_count", "type": TYPE_INT, "required": false}, 
        "metadata": {"name": "_metadata", "type": TYPE_STRING, "required": false}, 
        "name": {"name": "_name", "type": TYPE_STRING, "required": false}, 
        "open": {"name": "_open", "type": TYPE_BOOL, "required": false}, 
        "update_time": {"name": "_update_time", "type": TYPE_STRING, "required": false}, 
    }


    var _avatar_url
    var avatar_url: String:
        get:
            return "" if not _avatar_url is String else String(_avatar_url)


    var _create_time
    var create_time: String:
        get:
            return "" if not _create_time is String else String(_create_time)


    var _creator_id
    var creator_id: String:
        get:
            return "" if not _creator_id is String else String(_creator_id)


    var _description
    var description: String:
        get:
            return "" if not _description is String else String(_description)


    var _edge_count
    var edge_count: int:
        get:
            return 0 if not _edge_count is int else int(_edge_count)


    var _id
    var id: String:
        get:
            return "" if not _id is String else String(_id)


    var _lang_tag
    var lang_tag: String:
        get:
            return "" if not _lang_tag is String else String(_lang_tag)


    var _max_count
    var max_count: int:
        get:
            return 0 if not _max_count is int else int(_max_count)


    var _metadata
    var metadata: String:
        get:
            return "" if not _metadata is String else String(_metadata)


    var _name
    var name: String:
        get:
            return "" if not _name is String else String(_name)


    var _open
    var open: bool:
        get:
            return false if not _open is bool else bool(_open)


    var _update_time
    var update_time: String:
        get:
            return "" if not _update_time is String else String(_update_time)

    func _init(p_exception = null):
        super (p_exception)

    static func create(p_ns: GDScript, p_dict: Dictionary) -> ApiGroup:
        return _safe_ret(NakamaSerializer.deserialize(p_ns, "ApiGroup", p_dict), ApiGroup) as ApiGroup

    func serialize() -> Dictionary:
        return NakamaSerializer.serialize(self)

    func _to_string() -> String:
        if is_exception():
            return get_exception()._to_string()
        var output: String = ""
        output += "avatar_url: %s, " % _avatar_url
        output += "create_time: %s, " % _create_time
        output += "creator_id: %s, " % _creator_id
        output += "description: %s, " % _description
        output += "edge_count: %s, " % _edge_count
        output += "id: %s, " % _id
        output += "lang_tag: %s, " % _lang_tag
        output += "max_count: %s, " % _max_count
        output += "metadata: %s, " % _metadata
        output += "name: %s, " % _name
        output += "open: %s, " % _open
        output += "update_time: %s, " % _update_time
        return output


class ApiGroupList extends NakamaAsyncResult:

    const _SCHEMA = {
        "cursor": {"name": "_cursor", "type": TYPE_STRING, "required": false}, 
        "groups": {"name": "_groups", "type": TYPE_ARRAY, "required": false, "content": "ApiGroup"}, 
    }


    var _cursor
    var cursor: String:
        get:
            return "" if not _cursor is String else String(_cursor)


    var _groups
    var groups: Array:
        get:
            return Array() if not _groups is Array else Array(_groups)

    func _init(p_exception = null):
        super (p_exception)

    static func create(p_ns: GDScript, p_dict: Dictionary) -> ApiGroupList:
        return _safe_ret(NakamaSerializer.deserialize(p_ns, "ApiGroupList", p_dict), ApiGroupList) as ApiGroupList

    func serialize() -> Dictionary:
        return NakamaSerializer.serialize(self)

    func _to_string() -> String:
        if is_exception():
            return get_exception()._to_string()
        var output: String = ""
        output += "cursor: %s, " % _cursor
        output += "groups: %s, " % [_groups]
        return output


class ApiGroupUserList extends NakamaAsyncResult:

    const _SCHEMA = {
        "cursor": {"name": "_cursor", "type": TYPE_STRING, "required": false}, 
        "group_users": {"name": "_group_users", "type": TYPE_ARRAY, "required": false, "content": "GroupUserListGroupUser"}, 
    }


    var _cursor
    var cursor: String:
        get:
            return "" if not _cursor is String else String(_cursor)


    var _group_users
    var group_users: Array:
        get:
            return Array() if not _group_users is Array else Array(_group_users)

    func _init(p_exception = null):
        super (p_exception)

    static func create(p_ns: GDScript, p_dict: Dictionary) -> ApiGroupUserList:
        return _safe_ret(NakamaSerializer.deserialize(p_ns, "ApiGroupUserList", p_dict), ApiGroupUserList) as ApiGroupUserList

    func serialize() -> Dictionary:
        return NakamaSerializer.serialize(self)

    func _to_string() -> String:
        if is_exception():
            return get_exception()._to_string()
        var output: String = ""
        output += "cursor: %s, " % _cursor
        output += "group_users: %s, " % [_group_users]
        return output


class ApiLeaderboardRecord extends NakamaAsyncResult:

    const _SCHEMA = {
        "create_time": {"name": "_create_time", "type": TYPE_STRING, "required": false}, 
        "expiry_time": {"name": "_expiry_time", "type": TYPE_STRING, "required": false}, 
        "leaderboard_id": {"name": "_leaderboard_id", "type": TYPE_STRING, "required": false}, 
        "max_num_score": {"name": "_max_num_score", "type": TYPE_INT, "required": false}, 
        "metadata": {"name": "_metadata", "type": TYPE_STRING, "required": false}, 
        "num_score": {"name": "_num_score", "type": TYPE_INT, "required": false}, 
        "owner_id": {"name": "_owner_id", "type": TYPE_STRING, "required": false}, 
        "rank": {"name": "_rank", "type": TYPE_STRING, "required": false}, 
        "score": {"name": "_score", "type": TYPE_STRING, "required": false}, 
        "subscore": {"name": "_subscore", "type": TYPE_STRING, "required": false}, 
        "update_time": {"name": "_update_time", "type": TYPE_STRING, "required": false}, 
        "username": {"name": "_username", "type": TYPE_STRING, "required": false}, 
    }


    var _create_time
    var create_time: String:
        get:
            return "" if not _create_time is String else String(_create_time)


    var _expiry_time
    var expiry_time: String:
        get:
            return "" if not _expiry_time is String else String(_expiry_time)


    var _leaderboard_id
    var leaderboard_id: String:
        get:
            return "" if not _leaderboard_id is String else String(_leaderboard_id)


    var _max_num_score
    var max_num_score: int:
        get:
            return 0 if not _max_num_score is int else int(_max_num_score)


    var _metadata
    var metadata: String:
        get:
            return "" if not _metadata is String else String(_metadata)


    var _num_score
    var num_score: int:
        get:
            return 0 if not _num_score is int else int(_num_score)


    var _owner_id
    var owner_id: String:
        get:
            return "" if not _owner_id is String else String(_owner_id)


    var _rank
    var rank: String:
        get:
            return "" if not _rank is String else String(_rank)


    var _score
    var score: String:
        get:
            return "" if not _score is String else String(_score)


    var _subscore
    var subscore: String:
        get:
            return "" if not _subscore is String else String(_subscore)


    var _update_time
    var update_time: String:
        get:
            return "" if not _update_time is String else String(_update_time)


    var _username
    var username: String:
        get:
            return "" if not _username is String else String(_username)

    func _init(p_exception = null):
        super (p_exception)

    static func create(p_ns: GDScript, p_dict: Dictionary) -> ApiLeaderboardRecord:
        return _safe_ret(NakamaSerializer.deserialize(p_ns, "ApiLeaderboardRecord", p_dict), ApiLeaderboardRecord) as ApiLeaderboardRecord

    func serialize() -> Dictionary:
        return NakamaSerializer.serialize(self)

    func _to_string() -> String:
        if is_exception():
            return get_exception()._to_string()
        var output: String = ""
        output += "create_time: %s, " % _create_time
        output += "expiry_time: %s, " % _expiry_time
        output += "leaderboard_id: %s, " % _leaderboard_id
        output += "max_num_score: %s, " % _max_num_score
        output += "metadata: %s, " % _metadata
        output += "num_score: %s, " % _num_score
        output += "owner_id: %s, " % _owner_id
        output += "rank: %s, " % _rank
        output += "score: %s, " % _score
        output += "subscore: %s, " % _subscore
        output += "update_time: %s, " % _update_time
        output += "username: %s, " % _username
        return output


class ApiLeaderboardRecordList extends NakamaAsyncResult:

    const _SCHEMA = {
        "next_cursor": {"name": "_next_cursor", "type": TYPE_STRING, "required": false}, 
        "owner_records": {"name": "_owner_records", "type": TYPE_ARRAY, "required": false, "content": "ApiLeaderboardRecord"}, 
        "prev_cursor": {"name": "_prev_cursor", "type": TYPE_STRING, "required": false}, 
        "records": {"name": "_records", "type": TYPE_ARRAY, "required": false, "content": "ApiLeaderboardRecord"}, 
    }


    var _next_cursor
    var next_cursor: String:
        get:
            return "" if not _next_cursor is String else String(_next_cursor)


    var _owner_records
    var owner_records: Array:
        get:
            return Array() if not _owner_records is Array else Array(_owner_records)


    var _prev_cursor
    var prev_cursor: String:
        get:
            return "" if not _prev_cursor is String else String(_prev_cursor)


    var _records
    var records: Array:
        get:
            return Array() if not _records is Array else Array(_records)

    func _init(p_exception = null):
        super (p_exception)

    static func create(p_ns: GDScript, p_dict: Dictionary) -> ApiLeaderboardRecordList:
        return _safe_ret(NakamaSerializer.deserialize(p_ns, "ApiLeaderboardRecordList", p_dict), ApiLeaderboardRecordList) as ApiLeaderboardRecordList

    func serialize() -> Dictionary:
        return NakamaSerializer.serialize(self)

    func _to_string() -> String:
        if is_exception():
            return get_exception()._to_string()
        var output: String = ""
        output += "next_cursor: %s, " % _next_cursor
        output += "owner_records: %s, " % [_owner_records]
        output += "prev_cursor: %s, " % _prev_cursor
        output += "records: %s, " % [_records]
        return output


class ApiLinkSteamRequest extends NakamaAsyncResult:

    const _SCHEMA = {
        "account": {"name": "_account", "type": "ApiAccountSteam", "required": false}, 
        "sync": {"name": "_sync", "type": TYPE_BOOL, "required": false}, 
    }


    var _account
    var account: ApiAccountSteam:
        get:
            return _account as ApiAccountSteam


    var _sync
    var sync: bool:
        get:
            return false if not _sync is bool else bool(_sync)

    func _init(p_exception = null):
        super (p_exception)

    static func create(p_ns: GDScript, p_dict: Dictionary) -> ApiLinkSteamRequest:
        return _safe_ret(NakamaSerializer.deserialize(p_ns, "ApiLinkSteamRequest", p_dict), ApiLinkSteamRequest) as ApiLinkSteamRequest

    func serialize() -> Dictionary:
        return NakamaSerializer.serialize(self)

    func _to_string() -> String:
        if is_exception():
            return get_exception()._to_string()
        var output: String = ""
        output += "account: %s, " % _account
        output += "sync: %s, " % _sync
        return output


class ApiListSubscriptionsRequest extends NakamaAsyncResult:

    const _SCHEMA = {
        "cursor": {"name": "_cursor", "type": TYPE_STRING, "required": false}, 
        "limit": {"name": "_limit", "type": TYPE_INT, "required": false}, 
    }


    var _cursor
    var cursor: String:
        get:
            return "" if not _cursor is String else String(_cursor)


    var _limit
    var limit: int:
        get:
            return 0 if not _limit is int else int(_limit)

    func _init(p_exception = null):
        super (p_exception)

    static func create(p_ns: GDScript, p_dict: Dictionary) -> ApiListSubscriptionsRequest:
        return _safe_ret(NakamaSerializer.deserialize(p_ns, "ApiListSubscriptionsRequest", p_dict), ApiListSubscriptionsRequest) as ApiListSubscriptionsRequest

    func serialize() -> Dictionary:
        return NakamaSerializer.serialize(self)

    func _to_string() -> String:
        if is_exception():
            return get_exception()._to_string()
        var output: String = ""
        output += "cursor: %s, " % _cursor
        output += "limit: %s, " % _limit
        return output


class ApiMatch extends NakamaAsyncResult:

    const _SCHEMA = {
        "authoritative": {"name": "_authoritative", "type": TYPE_BOOL, "required": false}, 
        "handler_name": {"name": "_handler_name", "type": TYPE_STRING, "required": false}, 
        "label": {"name": "_label", "type": TYPE_STRING, "required": false}, 
        "match_id": {"name": "_match_id", "type": TYPE_STRING, "required": false}, 
        "size": {"name": "_size", "type": TYPE_INT, "required": false}, 
        "tick_rate": {"name": "_tick_rate", "type": TYPE_INT, "required": false}, 
    }


    var _authoritative
    var authoritative: bool:
        get:
            return false if not _authoritative is bool else bool(_authoritative)


    var _handler_name
    var handler_name: String:
        get:
            return "" if not _handler_name is String else String(_handler_name)


    var _label
    var label: String:
        get:
            return "" if not _label is String else String(_label)


    var _match_id
    var match_id: String:
        get:
            return "" if not _match_id is String else String(_match_id)


    var _size
    var size: int:
        get:
            return 0 if not _size is int else int(_size)


    var _tick_rate
    var tick_rate: int:
        get:
            return 0 if not _tick_rate is int else int(_tick_rate)

    func _init(p_exception = null):
        super (p_exception)

    static func create(p_ns: GDScript, p_dict: Dictionary) -> ApiMatch:
        return _safe_ret(NakamaSerializer.deserialize(p_ns, "ApiMatch", p_dict), ApiMatch) as ApiMatch

    func serialize() -> Dictionary:
        return NakamaSerializer.serialize(self)

    func _to_string() -> String:
        if is_exception():
            return get_exception()._to_string()
        var output: String = ""
        output += "authoritative: %s, " % _authoritative
        output += "handler_name: %s, " % _handler_name
        output += "label: %s, " % _label
        output += "match_id: %s, " % _match_id
        output += "size: %s, " % _size
        output += "tick_rate: %s, " % _tick_rate
        return output


class ApiMatchList extends NakamaAsyncResult:

    const _SCHEMA = {
        "matches": {"name": "_matches", "type": TYPE_ARRAY, "required": false, "content": "ApiMatch"}, 
    }


    var _matches
    var matches: Array:
        get:
            return Array() if not _matches is Array else Array(_matches)

    func _init(p_exception = null):
        super (p_exception)

    static func create(p_ns: GDScript, p_dict: Dictionary) -> ApiMatchList:
        return _safe_ret(NakamaSerializer.deserialize(p_ns, "ApiMatchList", p_dict), ApiMatchList) as ApiMatchList

    func serialize() -> Dictionary:
        return NakamaSerializer.serialize(self)

    func _to_string() -> String:
        if is_exception():
            return get_exception()._to_string()
        var output: String = ""
        output += "matches: %s, " % [_matches]
        return output


class ApiNotification extends NakamaAsyncResult:

    const _SCHEMA = {
        "code": {"name": "_code", "type": TYPE_INT, "required": false}, 
        "content": {"name": "_content", "type": TYPE_STRING, "required": false}, 
        "create_time": {"name": "_create_time", "type": TYPE_STRING, "required": false}, 
        "id": {"name": "_id", "type": TYPE_STRING, "required": false}, 
        "persistent": {"name": "_persistent", "type": TYPE_BOOL, "required": false}, 
        "sender_id": {"name": "_sender_id", "type": TYPE_STRING, "required": false}, 
        "subject": {"name": "_subject", "type": TYPE_STRING, "required": false}, 
    }


    var _code
    var code: int:
        get:
            return 0 if not _code is int else int(_code)


    var _content
    var content: String:
        get:
            return "" if not _content is String else String(_content)


    var _create_time
    var create_time: String:
        get:
            return "" if not _create_time is String else String(_create_time)


    var _id
    var id: String:
        get:
            return "" if not _id is String else String(_id)


    var _persistent
    var persistent: bool:
        get:
            return false if not _persistent is bool else bool(_persistent)


    var _sender_id
    var sender_id: String:
        get:
            return "" if not _sender_id is String else String(_sender_id)


    var _subject
    var subject: String:
        get:
            return "" if not _subject is String else String(_subject)

    func _init(p_exception = null):
        super (p_exception)

    static func create(p_ns: GDScript, p_dict: Dictionary) -> ApiNotification:
        return _safe_ret(NakamaSerializer.deserialize(p_ns, "ApiNotification", p_dict), ApiNotification) as ApiNotification

    func serialize() -> Dictionary:
        return NakamaSerializer.serialize(self)

    func _to_string() -> String:
        if is_exception():
            return get_exception()._to_string()
        var output: String = ""
        output += "code: %s, " % _code
        output += "content: %s, " % _content
        output += "create_time: %s, " % _create_time
        output += "id: %s, " % _id
        output += "persistent: %s, " % _persistent
        output += "sender_id: %s, " % _sender_id
        output += "subject: %s, " % _subject
        return output


class ApiNotificationList extends NakamaAsyncResult:

    const _SCHEMA = {
        "cacheable_cursor": {"name": "_cacheable_cursor", "type": TYPE_STRING, "required": false}, 
        "notifications": {"name": "_notifications", "type": TYPE_ARRAY, "required": false, "content": "ApiNotification"}, 
    }


    var _cacheable_cursor
    var cacheable_cursor: String:
        get:
            return "" if not _cacheable_cursor is String else String(_cacheable_cursor)


    var _notifications
    var notifications: Array:
        get:
            return Array() if not _notifications is Array else Array(_notifications)

    func _init(p_exception = null):
        super (p_exception)

    static func create(p_ns: GDScript, p_dict: Dictionary) -> ApiNotificationList:
        return _safe_ret(NakamaSerializer.deserialize(p_ns, "ApiNotificationList", p_dict), ApiNotificationList) as ApiNotificationList

    func serialize() -> Dictionary:
        return NakamaSerializer.serialize(self)

    func _to_string() -> String:
        if is_exception():
            return get_exception()._to_string()
        var output: String = ""
        output += "cacheable_cursor: %s, " % _cacheable_cursor
        output += "notifications: %s, " % [_notifications]
        return output







enum ApiOperator{NO_OVERRIDE = 0, BEST = 1, SET = 2, INCREMENT = 3, DECREMENT = 4, }


class ApiReadStorageObjectId extends NakamaAsyncResult:

    const _SCHEMA = {
        "collection": {"name": "_collection", "type": TYPE_STRING, "required": false}, 
        "key": {"name": "_key", "type": TYPE_STRING, "required": false}, 
        "user_id": {"name": "_user_id", "type": TYPE_STRING, "required": false}, 
    }


    var _collection
    var collection: String:
        get:
            return "" if not _collection is String else String(_collection)


    var _key
    var key: String:
        get:
            return "" if not _key is String else String(_key)


    var _user_id
    var user_id: String:
        get:
            return "" if not _user_id is String else String(_user_id)

    func _init(p_exception = null):
        super (p_exception)

    static func create(p_ns: GDScript, p_dict: Dictionary) -> ApiReadStorageObjectId:
        return _safe_ret(NakamaSerializer.deserialize(p_ns, "ApiReadStorageObjectId", p_dict), ApiReadStorageObjectId) as ApiReadStorageObjectId

    func serialize() -> Dictionary:
        return NakamaSerializer.serialize(self)

    func _to_string() -> String:
        if is_exception():
            return get_exception()._to_string()
        var output: String = ""
        output += "collection: %s, " % _collection
        output += "key: %s, " % _key
        output += "user_id: %s, " % _user_id
        return output


class ApiReadStorageObjectsRequest extends NakamaAsyncResult:

    const _SCHEMA = {
        "object_ids": {"name": "_object_ids", "type": TYPE_ARRAY, "required": false, "content": "ApiReadStorageObjectId"}, 
    }


    var _object_ids
    var object_ids: Array:
        get:
            return Array() if not _object_ids is Array else Array(_object_ids)

    func _init(p_exception = null):
        super (p_exception)

    static func create(p_ns: GDScript, p_dict: Dictionary) -> ApiReadStorageObjectsRequest:
        return _safe_ret(NakamaSerializer.deserialize(p_ns, "ApiReadStorageObjectsRequest", p_dict), ApiReadStorageObjectsRequest) as ApiReadStorageObjectsRequest

    func serialize() -> Dictionary:
        return NakamaSerializer.serialize(self)

    func _to_string() -> String:
        if is_exception():
            return get_exception()._to_string()
        var output: String = ""
        output += "object_ids: %s, " % [_object_ids]
        return output


class ApiRpc extends NakamaAsyncResult:

    const _SCHEMA = {
        "http_key": {"name": "_http_key", "type": TYPE_STRING, "required": false}, 
        "id": {"name": "_id", "type": TYPE_STRING, "required": false}, 
        "payload": {"name": "_payload", "type": TYPE_STRING, "required": false}, 
    }


    var _http_key
    var http_key: String:
        get:
            return "" if not _http_key is String else String(_http_key)


    var _id
    var id: String:
        get:
            return "" if not _id is String else String(_id)


    var _payload
    var payload: String:
        get:
            return "" if not _payload is String else String(_payload)

    func _init(p_exception = null):
        super (p_exception)

    static func create(p_ns: GDScript, p_dict: Dictionary) -> ApiRpc:
        return _safe_ret(NakamaSerializer.deserialize(p_ns, "ApiRpc", p_dict), ApiRpc) as ApiRpc

    func serialize() -> Dictionary:
        return NakamaSerializer.serialize(self)

    func _to_string() -> String:
        if is_exception():
            return get_exception()._to_string()
        var output: String = ""
        output += "http_key: %s, " % _http_key
        output += "id: %s, " % _id
        output += "payload: %s, " % _payload
        return output


class ApiSession extends NakamaAsyncResult:

    const _SCHEMA = {
        "created": {"name": "_created", "type": TYPE_BOOL, "required": false}, 
        "refresh_token": {"name": "_refresh_token", "type": TYPE_STRING, "required": false}, 
        "token": {"name": "_token", "type": TYPE_STRING, "required": false}, 
    }


    var _created
    var created: bool:
        get:
            return false if not _created is bool else bool(_created)


    var _refresh_token
    var refresh_token: String:
        get:
            return "" if not _refresh_token is String else String(_refresh_token)


    var _token
    var token: String:
        get:
            return "" if not _token is String else String(_token)

    func _init(p_exception = null):
        super (p_exception)

    static func create(p_ns: GDScript, p_dict: Dictionary) -> ApiSession:
        return _safe_ret(NakamaSerializer.deserialize(p_ns, "ApiSession", p_dict), ApiSession) as ApiSession

    func serialize() -> Dictionary:
        return NakamaSerializer.serialize(self)

    func _to_string() -> String:
        if is_exception():
            return get_exception()._to_string()
        var output: String = ""
        output += "created: %s, " % _created
        output += "refresh_token: %s, " % _refresh_token
        output += "token: %s, " % _token
        return output


class ApiSessionLogoutRequest extends NakamaAsyncResult:

    const _SCHEMA = {
        "refresh_token": {"name": "_refresh_token", "type": TYPE_STRING, "required": false}, 
        "token": {"name": "_token", "type": TYPE_STRING, "required": false}, 
    }


    var _refresh_token
    var refresh_token: String:
        get:
            return "" if not _refresh_token is String else String(_refresh_token)


    var _token
    var token: String:
        get:
            return "" if not _token is String else String(_token)

    func _init(p_exception = null):
        super (p_exception)

    static func create(p_ns: GDScript, p_dict: Dictionary) -> ApiSessionLogoutRequest:
        return _safe_ret(NakamaSerializer.deserialize(p_ns, "ApiSessionLogoutRequest", p_dict), ApiSessionLogoutRequest) as ApiSessionLogoutRequest

    func serialize() -> Dictionary:
        return NakamaSerializer.serialize(self)

    func _to_string() -> String:
        if is_exception():
            return get_exception()._to_string()
        var output: String = ""
        output += "refresh_token: %s, " % _refresh_token
        output += "token: %s, " % _token
        return output


class ApiSessionRefreshRequest extends NakamaAsyncResult:

    const _SCHEMA = {
        "token": {"name": "_token", "type": TYPE_STRING, "required": false}, 
        "vars": {"name": "_vars", "type": TYPE_DICTIONARY, "required": false, "content": TYPE_STRING}, 
    }


    var _token
    var token: String:
        get:
            return "" if not _token is String else String(_token)


    var _vars
    var vars: Dictionary:
        get:
            return Dictionary() if not _vars is Dictionary else _vars.duplicate()

    func _init(p_exception = null):
        super (p_exception)

    static func create(p_ns: GDScript, p_dict: Dictionary) -> ApiSessionRefreshRequest:
        return _safe_ret(NakamaSerializer.deserialize(p_ns, "ApiSessionRefreshRequest", p_dict), ApiSessionRefreshRequest) as ApiSessionRefreshRequest

    func serialize() -> Dictionary:
        return NakamaSerializer.serialize(self)

    func _to_string() -> String:
        if is_exception():
            return get_exception()._to_string()
        var output: String = ""
        output += "token: %s, " % _token
        var map_string: String = ""
        if typeof(_vars) == TYPE_DICTIONARY:
            for k in _vars:
                map_string += "{%s=%s}, " % [k, _vars[k]]
        output += "vars: [%s], " % map_string
        return output


class ApiStorageObject extends NakamaAsyncResult:

    const _SCHEMA = {
        "collection": {"name": "_collection", "type": TYPE_STRING, "required": false}, 
        "create_time": {"name": "_create_time", "type": TYPE_STRING, "required": false}, 
        "key": {"name": "_key", "type": TYPE_STRING, "required": false}, 
        "permission_read": {"name": "_permission_read", "type": TYPE_INT, "required": false}, 
        "permission_write": {"name": "_permission_write", "type": TYPE_INT, "required": false}, 
        "update_time": {"name": "_update_time", "type": TYPE_STRING, "required": false}, 
        "user_id": {"name": "_user_id", "type": TYPE_STRING, "required": false}, 
        "value": {"name": "_value", "type": TYPE_STRING, "required": false}, 
        "version": {"name": "_version", "type": TYPE_STRING, "required": false}, 
    }


    var _collection
    var collection: String:
        get:
            return "" if not _collection is String else String(_collection)


    var _create_time
    var create_time: String:
        get:
            return "" if not _create_time is String else String(_create_time)


    var _key
    var key: String:
        get:
            return "" if not _key is String else String(_key)


    var _permission_read
    var permission_read: int:
        get:
            return 0 if not _permission_read is int else int(_permission_read)


    var _permission_write
    var permission_write: int:
        get:
            return 0 if not _permission_write is int else int(_permission_write)


    var _update_time
    var update_time: String:
        get:
            return "" if not _update_time is String else String(_update_time)


    var _user_id
    var user_id: String:
        get:
            return "" if not _user_id is String else String(_user_id)


    var _value
    var value: String:
        get:
            return "" if not _value is String else String(_value)


    var _version
    var version: String:
        get:
            return "" if not _version is String else String(_version)

    func _init(p_exception = null):
        super (p_exception)

    static func create(p_ns: GDScript, p_dict: Dictionary) -> ApiStorageObject:
        return _safe_ret(NakamaSerializer.deserialize(p_ns, "ApiStorageObject", p_dict), ApiStorageObject) as ApiStorageObject

    func serialize() -> Dictionary:
        return NakamaSerializer.serialize(self)

    func _to_string() -> String:
        if is_exception():
            return get_exception()._to_string()
        var output: String = ""
        output += "collection: %s, " % _collection
        output += "create_time: %s, " % _create_time
        output += "key: %s, " % _key
        output += "permission_read: %s, " % _permission_read
        output += "permission_write: %s, " % _permission_write
        output += "update_time: %s, " % _update_time
        output += "user_id: %s, " % _user_id
        output += "value: %s, " % _value
        output += "version: %s, " % _version
        return output


class ApiStorageObjectAck extends NakamaAsyncResult:

    const _SCHEMA = {
        "collection": {"name": "_collection", "type": TYPE_STRING, "required": false}, 
        "key": {"name": "_key", "type": TYPE_STRING, "required": false}, 
        "user_id": {"name": "_user_id", "type": TYPE_STRING, "required": false}, 
        "version": {"name": "_version", "type": TYPE_STRING, "required": false}, 
    }


    var _collection
    var collection: String:
        get:
            return "" if not _collection is String else String(_collection)


    var _key
    var key: String:
        get:
            return "" if not _key is String else String(_key)


    var _user_id
    var user_id: String:
        get:
            return "" if not _user_id is String else String(_user_id)


    var _version
    var version: String:
        get:
            return "" if not _version is String else String(_version)

    func _init(p_exception = null):
        super (p_exception)

    static func create(p_ns: GDScript, p_dict: Dictionary) -> ApiStorageObjectAck:
        return _safe_ret(NakamaSerializer.deserialize(p_ns, "ApiStorageObjectAck", p_dict), ApiStorageObjectAck) as ApiStorageObjectAck

    func serialize() -> Dictionary:
        return NakamaSerializer.serialize(self)

    func _to_string() -> String:
        if is_exception():
            return get_exception()._to_string()
        var output: String = ""
        output += "collection: %s, " % _collection
        output += "key: %s, " % _key
        output += "user_id: %s, " % _user_id
        output += "version: %s, " % _version
        return output


class ApiStorageObjectAcks extends NakamaAsyncResult:

    const _SCHEMA = {
        "acks": {"name": "_acks", "type": TYPE_ARRAY, "required": false, "content": "ApiStorageObjectAck"}, 
    }


    var _acks
    var acks: Array:
        get:
            return Array() if not _acks is Array else Array(_acks)

    func _init(p_exception = null):
        super (p_exception)

    static func create(p_ns: GDScript, p_dict: Dictionary) -> ApiStorageObjectAcks:
        return _safe_ret(NakamaSerializer.deserialize(p_ns, "ApiStorageObjectAcks", p_dict), ApiStorageObjectAcks) as ApiStorageObjectAcks

    func serialize() -> Dictionary:
        return NakamaSerializer.serialize(self)

    func _to_string() -> String:
        if is_exception():
            return get_exception()._to_string()
        var output: String = ""
        output += "acks: %s, " % [_acks]
        return output


class ApiStorageObjectList extends NakamaAsyncResult:

    const _SCHEMA = {
        "cursor": {"name": "_cursor", "type": TYPE_STRING, "required": false}, 
        "objects": {"name": "_objects", "type": TYPE_ARRAY, "required": false, "content": "ApiStorageObject"}, 
    }


    var _cursor
    var cursor: String:
        get:
            return "" if not _cursor is String else String(_cursor)


    var _objects
    var objects: Array:
        get:
            return Array() if not _objects is Array else Array(_objects)

    func _init(p_exception = null):
        super (p_exception)

    static func create(p_ns: GDScript, p_dict: Dictionary) -> ApiStorageObjectList:
        return _safe_ret(NakamaSerializer.deserialize(p_ns, "ApiStorageObjectList", p_dict), ApiStorageObjectList) as ApiStorageObjectList

    func serialize() -> Dictionary:
        return NakamaSerializer.serialize(self)

    func _to_string() -> String:
        if is_exception():
            return get_exception()._to_string()
        var output: String = ""
        output += "cursor: %s, " % _cursor
        output += "objects: %s, " % [_objects]
        return output


class ApiStorageObjects extends NakamaAsyncResult:

    const _SCHEMA = {
        "objects": {"name": "_objects", "type": TYPE_ARRAY, "required": false, "content": "ApiStorageObject"}, 
    }


    var _objects
    var objects: Array:
        get:
            return Array() if not _objects is Array else Array(_objects)

    func _init(p_exception = null):
        super (p_exception)

    static func create(p_ns: GDScript, p_dict: Dictionary) -> ApiStorageObjects:
        return _safe_ret(NakamaSerializer.deserialize(p_ns, "ApiStorageObjects", p_dict), ApiStorageObjects) as ApiStorageObjects

    func serialize() -> Dictionary:
        return NakamaSerializer.serialize(self)

    func _to_string() -> String:
        if is_exception():
            return get_exception()._to_string()
        var output: String = ""
        output += "objects: %s, " % [_objects]
        return output





enum ApiStoreEnvironment{UNKNOWN = 0, SANDBOX = 1, PRODUCTION = 2, }





enum ApiStoreProvider{APPLE_APP_STORE = 0, GOOGLE_PLAY_STORE = 1, HUAWEI_APP_GALLERY = 2, }


class ApiSubscriptionList extends NakamaAsyncResult:

    const _SCHEMA = {
        "cursor": {"name": "_cursor", "type": TYPE_STRING, "required": false}, 
        "prev_cursor": {"name": "_prev_cursor", "type": TYPE_STRING, "required": false}, 
        "validated_subscriptions": {"name": "_validated_subscriptions", "type": TYPE_ARRAY, "required": false, "content": "ApiValidatedSubscription"}, 
    }


    var _cursor
    var cursor: String:
        get:
            return "" if not _cursor is String else String(_cursor)


    var _prev_cursor
    var prev_cursor: String:
        get:
            return "" if not _prev_cursor is String else String(_prev_cursor)


    var _validated_subscriptions
    var validated_subscriptions: Array:
        get:
            return Array() if not _validated_subscriptions is Array else Array(_validated_subscriptions)

    func _init(p_exception = null):
        super (p_exception)

    static func create(p_ns: GDScript, p_dict: Dictionary) -> ApiSubscriptionList:
        return _safe_ret(NakamaSerializer.deserialize(p_ns, "ApiSubscriptionList", p_dict), ApiSubscriptionList) as ApiSubscriptionList

    func serialize() -> Dictionary:
        return NakamaSerializer.serialize(self)

    func _to_string() -> String:
        if is_exception():
            return get_exception()._to_string()
        var output: String = ""
        output += "cursor: %s, " % _cursor
        output += "prev_cursor: %s, " % _prev_cursor
        output += "validated_subscriptions: %s, " % [_validated_subscriptions]
        return output


class ApiTournament extends NakamaAsyncResult:

    const _SCHEMA = {
        "authoritative": {"name": "_authoritative", "type": TYPE_BOOL, "required": false}, 
        "can_enter": {"name": "_can_enter", "type": TYPE_BOOL, "required": false}, 
        "category": {"name": "_category", "type": TYPE_INT, "required": false}, 
        "create_time": {"name": "_create_time", "type": TYPE_STRING, "required": false}, 
        "description": {"name": "_description", "type": TYPE_STRING, "required": false}, 
        "duration": {"name": "_duration", "type": TYPE_INT, "required": false}, 
        "end_active": {"name": "_end_active", "type": TYPE_INT, "required": false}, 
        "end_time": {"name": "_end_time", "type": TYPE_STRING, "required": false}, 
        "id": {"name": "_id", "type": TYPE_STRING, "required": false}, 
        "max_num_score": {"name": "_max_num_score", "type": TYPE_INT, "required": false}, 
        "max_size": {"name": "_max_size", "type": TYPE_INT, "required": false}, 
        "metadata": {"name": "_metadata", "type": TYPE_STRING, "required": false}, 
        "next_reset": {"name": "_next_reset", "type": TYPE_INT, "required": false}, 
        "operator": {"name": "_operator", "type": TYPE_INT, "required": false}, 
        "prev_reset": {"name": "_prev_reset", "type": TYPE_INT, "required": false}, 
        "size": {"name": "_size", "type": TYPE_INT, "required": false}, 
        "sort_order": {"name": "_sort_order", "type": TYPE_INT, "required": false}, 
        "start_active": {"name": "_start_active", "type": TYPE_INT, "required": false}, 
        "start_time": {"name": "_start_time", "type": TYPE_STRING, "required": false}, 
        "title": {"name": "_title", "type": TYPE_STRING, "required": false}, 
    }


    var _authoritative
    var authoritative: bool:
        get:
            return false if not _authoritative is bool else bool(_authoritative)


    var _can_enter
    var can_enter: bool:
        get:
            return false if not _can_enter is bool else bool(_can_enter)


    var _category
    var category: int:
        get:
            return 0 if not _category is int else int(_category)


    var _create_time
    var create_time: String:
        get:
            return "" if not _create_time is String else String(_create_time)


    var _description
    var description: String:
        get:
            return "" if not _description is String else String(_description)


    var _duration
    var duration: int:
        get:
            return 0 if not _duration is int else int(_duration)


    var _end_active
    var end_active: int:
        get:
            return 0 if not _end_active is int else int(_end_active)


    var _end_time
    var end_time: String:
        get:
            return "" if not _end_time is String else String(_end_time)


    var _id
    var id: String:
        get:
            return "" if not _id is String else String(_id)


    var _max_num_score
    var max_num_score: int:
        get:
            return 0 if not _max_num_score is int else int(_max_num_score)


    var _max_size
    var max_size: int:
        get:
            return 0 if not _max_size is int else int(_max_size)


    var _metadata
    var metadata: String:
        get:
            return "" if not _metadata is String else String(_metadata)


    var _next_reset
    var next_reset: int:
        get:
            return 0 if not _next_reset is int else int(_next_reset)


    var _operator
    var operator: int:
        get:
            return ApiOperator.values()[0] if not ApiOperator.values().has(_operator) else _operator


    var _prev_reset
    var prev_reset: int:
        get:
            return 0 if not _prev_reset is int else int(_prev_reset)


    var _size
    var size: int:
        get:
            return 0 if not _size is int else int(_size)


    var _sort_order
    var sort_order: int:
        get:
            return 0 if not _sort_order is int else int(_sort_order)


    var _start_active
    var start_active: int:
        get:
            return 0 if not _start_active is int else int(_start_active)


    var _start_time
    var start_time: String:
        get:
            return "" if not _start_time is String else String(_start_time)


    var _title
    var title: String:
        get:
            return "" if not _title is String else String(_title)

    func _init(p_exception = null):
        super (p_exception)

    static func create(p_ns: GDScript, p_dict: Dictionary) -> ApiTournament:
        return _safe_ret(NakamaSerializer.deserialize(p_ns, "ApiTournament", p_dict), ApiTournament) as ApiTournament

    func serialize() -> Dictionary:
        return NakamaSerializer.serialize(self)

    func _to_string() -> String:
        if is_exception():
            return get_exception()._to_string()
        var output: String = ""
        output += "authoritative: %s, " % _authoritative
        output += "can_enter: %s, " % _can_enter
        output += "category: %s, " % _category
        output += "create_time: %s, " % _create_time
        output += "description: %s, " % _description
        output += "duration: %s, " % _duration
        output += "end_active: %s, " % _end_active
        output += "end_time: %s, " % _end_time
        output += "id: %s, " % _id
        output += "max_num_score: %s, " % _max_num_score
        output += "max_size: %s, " % _max_size
        output += "metadata: %s, " % _metadata
        output += "next_reset: %s, " % _next_reset
        output += "operator: %s, " % _operator
        output += "prev_reset: %s, " % _prev_reset
        output += "size: %s, " % _size
        output += "sort_order: %s, " % _sort_order
        output += "start_active: %s, " % _start_active
        output += "start_time: %s, " % _start_time
        output += "title: %s, " % _title
        return output


class ApiTournamentList extends NakamaAsyncResult:

    const _SCHEMA = {
        "cursor": {"name": "_cursor", "type": TYPE_STRING, "required": false}, 
        "tournaments": {"name": "_tournaments", "type": TYPE_ARRAY, "required": false, "content": "ApiTournament"}, 
    }


    var _cursor
    var cursor: String:
        get:
            return "" if not _cursor is String else String(_cursor)


    var _tournaments
    var tournaments: Array:
        get:
            return Array() if not _tournaments is Array else Array(_tournaments)

    func _init(p_exception = null):
        super (p_exception)

    static func create(p_ns: GDScript, p_dict: Dictionary) -> ApiTournamentList:
        return _safe_ret(NakamaSerializer.deserialize(p_ns, "ApiTournamentList", p_dict), ApiTournamentList) as ApiTournamentList

    func serialize() -> Dictionary:
        return NakamaSerializer.serialize(self)

    func _to_string() -> String:
        if is_exception():
            return get_exception()._to_string()
        var output: String = ""
        output += "cursor: %s, " % _cursor
        output += "tournaments: %s, " % [_tournaments]
        return output


class ApiTournamentRecordList extends NakamaAsyncResult:

    const _SCHEMA = {
        "next_cursor": {"name": "_next_cursor", "type": TYPE_STRING, "required": false}, 
        "owner_records": {"name": "_owner_records", "type": TYPE_ARRAY, "required": false, "content": "ApiLeaderboardRecord"}, 
        "prev_cursor": {"name": "_prev_cursor", "type": TYPE_STRING, "required": false}, 
        "records": {"name": "_records", "type": TYPE_ARRAY, "required": false, "content": "ApiLeaderboardRecord"}, 
    }


    var _next_cursor
    var next_cursor: String:
        get:
            return "" if not _next_cursor is String else String(_next_cursor)


    var _owner_records
    var owner_records: Array:
        get:
            return Array() if not _owner_records is Array else Array(_owner_records)


    var _prev_cursor
    var prev_cursor: String:
        get:
            return "" if not _prev_cursor is String else String(_prev_cursor)


    var _records
    var records: Array:
        get:
            return Array() if not _records is Array else Array(_records)

    func _init(p_exception = null):
        super (p_exception)

    static func create(p_ns: GDScript, p_dict: Dictionary) -> ApiTournamentRecordList:
        return _safe_ret(NakamaSerializer.deserialize(p_ns, "ApiTournamentRecordList", p_dict), ApiTournamentRecordList) as ApiTournamentRecordList

    func serialize() -> Dictionary:
        return NakamaSerializer.serialize(self)

    func _to_string() -> String:
        if is_exception():
            return get_exception()._to_string()
        var output: String = ""
        output += "next_cursor: %s, " % _next_cursor
        output += "owner_records: %s, " % [_owner_records]
        output += "prev_cursor: %s, " % _prev_cursor
        output += "records: %s, " % [_records]
        return output


class ApiUpdateAccountRequest extends NakamaAsyncResult:

    const _SCHEMA = {
        "avatar_url": {"name": "_avatar_url", "type": TYPE_STRING, "required": false}, 
        "display_name": {"name": "_display_name", "type": TYPE_STRING, "required": false}, 
        "lang_tag": {"name": "_lang_tag", "type": TYPE_STRING, "required": false}, 
        "location": {"name": "_location", "type": TYPE_STRING, "required": false}, 
        "timezone": {"name": "_timezone", "type": TYPE_STRING, "required": false}, 
        "username": {"name": "_username", "type": TYPE_STRING, "required": false}, 
    }


    var _avatar_url
    var avatar_url: String:
        get:
            return "" if not _avatar_url is String else String(_avatar_url)


    var _display_name
    var display_name: String:
        get:
            return "" if not _display_name is String else String(_display_name)


    var _lang_tag
    var lang_tag: String:
        get:
            return "" if not _lang_tag is String else String(_lang_tag)


    var _location
    var location: String:
        get:
            return "" if not _location is String else String(_location)


    var _timezone
    var timezone: String:
        get:
            return "" if not _timezone is String else String(_timezone)


    var _username
    var username: String:
        get:
            return "" if not _username is String else String(_username)

    func _init(p_exception = null):
        super (p_exception)

    static func create(p_ns: GDScript, p_dict: Dictionary) -> ApiUpdateAccountRequest:
        return _safe_ret(NakamaSerializer.deserialize(p_ns, "ApiUpdateAccountRequest", p_dict), ApiUpdateAccountRequest) as ApiUpdateAccountRequest

    func serialize() -> Dictionary:
        return NakamaSerializer.serialize(self)

    func _to_string() -> String:
        if is_exception():
            return get_exception()._to_string()
        var output: String = ""
        output += "avatar_url: %s, " % _avatar_url
        output += "display_name: %s, " % _display_name
        output += "lang_tag: %s, " % _lang_tag
        output += "location: %s, " % _location
        output += "timezone: %s, " % _timezone
        output += "username: %s, " % _username
        return output


class ApiUpdateGroupRequest extends NakamaAsyncResult:

    const _SCHEMA = {
        "avatar_url": {"name": "_avatar_url", "type": TYPE_STRING, "required": false}, 
        "description": {"name": "_description", "type": TYPE_STRING, "required": false}, 
        "group_id": {"name": "_group_id", "type": TYPE_STRING, "required": false}, 
        "lang_tag": {"name": "_lang_tag", "type": TYPE_STRING, "required": false}, 
        "name": {"name": "_name", "type": TYPE_STRING, "required": false}, 
        "open": {"name": "_open", "type": TYPE_BOOL, "required": false}, 
    }


    var _avatar_url
    var avatar_url: String:
        get:
            return "" if not _avatar_url is String else String(_avatar_url)


    var _description
    var description: String:
        get:
            return "" if not _description is String else String(_description)


    var _group_id
    var group_id: String:
        get:
            return "" if not _group_id is String else String(_group_id)


    var _lang_tag
    var lang_tag: String:
        get:
            return "" if not _lang_tag is String else String(_lang_tag)


    var _name
    var name: String:
        get:
            return "" if not _name is String else String(_name)


    var _open
    var open: bool:
        get:
            return false if not _open is bool else bool(_open)

    func _init(p_exception = null):
        super (p_exception)

    static func create(p_ns: GDScript, p_dict: Dictionary) -> ApiUpdateGroupRequest:
        return _safe_ret(NakamaSerializer.deserialize(p_ns, "ApiUpdateGroupRequest", p_dict), ApiUpdateGroupRequest) as ApiUpdateGroupRequest

    func serialize() -> Dictionary:
        return NakamaSerializer.serialize(self)

    func _to_string() -> String:
        if is_exception():
            return get_exception()._to_string()
        var output: String = ""
        output += "avatar_url: %s, " % _avatar_url
        output += "description: %s, " % _description
        output += "group_id: %s, " % _group_id
        output += "lang_tag: %s, " % _lang_tag
        output += "name: %s, " % _name
        output += "open: %s, " % _open
        return output


class ApiUser extends NakamaAsyncResult:

    const _SCHEMA = {
        "apple_id": {"name": "_apple_id", "type": TYPE_STRING, "required": false}, 
        "avatar_url": {"name": "_avatar_url", "type": TYPE_STRING, "required": false}, 
        "create_time": {"name": "_create_time", "type": TYPE_STRING, "required": false}, 
        "display_name": {"name": "_display_name", "type": TYPE_STRING, "required": false}, 
        "edge_count": {"name": "_edge_count", "type": TYPE_INT, "required": false}, 
        "facebook_id": {"name": "_facebook_id", "type": TYPE_STRING, "required": false}, 
        "facebook_instant_game_id": {"name": "_facebook_instant_game_id", "type": TYPE_STRING, "required": false}, 
        "gamecenter_id": {"name": "_gamecenter_id", "type": TYPE_STRING, "required": false}, 
        "google_id": {"name": "_google_id", "type": TYPE_STRING, "required": false}, 
        "id": {"name": "_id", "type": TYPE_STRING, "required": false}, 
        "lang_tag": {"name": "_lang_tag", "type": TYPE_STRING, "required": false}, 
        "location": {"name": "_location", "type": TYPE_STRING, "required": false}, 
        "metadata": {"name": "_metadata", "type": TYPE_STRING, "required": false}, 
        "online": {"name": "_online", "type": TYPE_BOOL, "required": false}, 
        "steam_id": {"name": "_steam_id", "type": TYPE_STRING, "required": false}, 
        "timezone": {"name": "_timezone", "type": TYPE_STRING, "required": false}, 
        "update_time": {"name": "_update_time", "type": TYPE_STRING, "required": false}, 
        "username": {"name": "_username", "type": TYPE_STRING, "required": false}, 
    }


    var _apple_id
    var apple_id: String:
        get:
            return "" if not _apple_id is String else String(_apple_id)


    var _avatar_url
    var avatar_url: String:
        get:
            return "" if not _avatar_url is String else String(_avatar_url)


    var _create_time
    var create_time: String:
        get:
            return "" if not _create_time is String else String(_create_time)


    var _display_name
    var display_name: String:
        get:
            return "" if not _display_name is String else String(_display_name)


    var _edge_count
    var edge_count: int:
        get:
            return 0 if not _edge_count is int else int(_edge_count)


    var _facebook_id
    var facebook_id: String:
        get:
            return "" if not _facebook_id is String else String(_facebook_id)


    var _facebook_instant_game_id
    var facebook_instant_game_id: String:
        get:
            return "" if not _facebook_instant_game_id is String else String(_facebook_instant_game_id)


    var _gamecenter_id
    var gamecenter_id: String:
        get:
            return "" if not _gamecenter_id is String else String(_gamecenter_id)


    var _google_id
    var google_id: String:
        get:
            return "" if not _google_id is String else String(_google_id)


    var _id
    var id: String:
        get:
            return "" if not _id is String else String(_id)


    var _lang_tag
    var lang_tag: String:
        get:
            return "" if not _lang_tag is String else String(_lang_tag)


    var _location
    var location: String:
        get:
            return "" if not _location is String else String(_location)


    var _metadata
    var metadata: String:
        get:
            return "" if not _metadata is String else String(_metadata)


    var _online
    var online: bool:
        get:
            return false if not _online is bool else bool(_online)


    var _steam_id
    var steam_id: String:
        get:
            return "" if not _steam_id is String else String(_steam_id)


    var _timezone
    var timezone: String:
        get:
            return "" if not _timezone is String else String(_timezone)


    var _update_time
    var update_time: String:
        get:
            return "" if not _update_time is String else String(_update_time)


    var _username
    var username: String:
        get:
            return "" if not _username is String else String(_username)

    func _init(p_exception = null):
        super (p_exception)

    static func create(p_ns: GDScript, p_dict: Dictionary) -> ApiUser:
        return _safe_ret(NakamaSerializer.deserialize(p_ns, "ApiUser", p_dict), ApiUser) as ApiUser

    func serialize() -> Dictionary:
        return NakamaSerializer.serialize(self)

    func _to_string() -> String:
        if is_exception():
            return get_exception()._to_string()
        var output: String = ""
        output += "apple_id: %s, " % _apple_id
        output += "avatar_url: %s, " % _avatar_url
        output += "create_time: %s, " % _create_time
        output += "display_name: %s, " % _display_name
        output += "edge_count: %s, " % _edge_count
        output += "facebook_id: %s, " % _facebook_id
        output += "facebook_instant_game_id: %s, " % _facebook_instant_game_id
        output += "gamecenter_id: %s, " % _gamecenter_id
        output += "google_id: %s, " % _google_id
        output += "id: %s, " % _id
        output += "lang_tag: %s, " % _lang_tag
        output += "location: %s, " % _location
        output += "metadata: %s, " % _metadata
        output += "online: %s, " % _online
        output += "steam_id: %s, " % _steam_id
        output += "timezone: %s, " % _timezone
        output += "update_time: %s, " % _update_time
        output += "username: %s, " % _username
        return output


class ApiUserGroupList extends NakamaAsyncResult:

    const _SCHEMA = {
        "cursor": {"name": "_cursor", "type": TYPE_STRING, "required": false}, 
        "user_groups": {"name": "_user_groups", "type": TYPE_ARRAY, "required": false, "content": "UserGroupListUserGroup"}, 
    }


    var _cursor
    var cursor: String:
        get:
            return "" if not _cursor is String else String(_cursor)


    var _user_groups
    var user_groups: Array:
        get:
            return Array() if not _user_groups is Array else Array(_user_groups)

    func _init(p_exception = null):
        super (p_exception)

    static func create(p_ns: GDScript, p_dict: Dictionary) -> ApiUserGroupList:
        return _safe_ret(NakamaSerializer.deserialize(p_ns, "ApiUserGroupList", p_dict), ApiUserGroupList) as ApiUserGroupList

    func serialize() -> Dictionary:
        return NakamaSerializer.serialize(self)

    func _to_string() -> String:
        if is_exception():
            return get_exception()._to_string()
        var output: String = ""
        output += "cursor: %s, " % _cursor
        output += "user_groups: %s, " % [_user_groups]
        return output


class ApiUsers extends NakamaAsyncResult:

    const _SCHEMA = {
        "users": {"name": "_users", "type": TYPE_ARRAY, "required": false, "content": "ApiUser"}, 
    }


    var _users
    var users: Array:
        get:
            return Array() if not _users is Array else Array(_users)

    func _init(p_exception = null):
        super (p_exception)

    static func create(p_ns: GDScript, p_dict: Dictionary) -> ApiUsers:
        return _safe_ret(NakamaSerializer.deserialize(p_ns, "ApiUsers", p_dict), ApiUsers) as ApiUsers

    func serialize() -> Dictionary:
        return NakamaSerializer.serialize(self)

    func _to_string() -> String:
        if is_exception():
            return get_exception()._to_string()
        var output: String = ""
        output += "users: %s, " % [_users]
        return output


class ApiValidatePurchaseAppleRequest extends NakamaAsyncResult:

    const _SCHEMA = {
        "persist": {"name": "_persist", "type": TYPE_BOOL, "required": false}, 
        "receipt": {"name": "_receipt", "type": TYPE_STRING, "required": false}, 
    }


    var _persist
    var persist: bool:
        get:
            return false if not _persist is bool else bool(_persist)


    var _receipt
    var receipt: String:
        get:
            return "" if not _receipt is String else String(_receipt)

    func _init(p_exception = null):
        super (p_exception)

    static func create(p_ns: GDScript, p_dict: Dictionary) -> ApiValidatePurchaseAppleRequest:
        return _safe_ret(NakamaSerializer.deserialize(p_ns, "ApiValidatePurchaseAppleRequest", p_dict), ApiValidatePurchaseAppleRequest) as ApiValidatePurchaseAppleRequest

    func serialize() -> Dictionary:
        return NakamaSerializer.serialize(self)

    func _to_string() -> String:
        if is_exception():
            return get_exception()._to_string()
        var output: String = ""
        output += "persist: %s, " % _persist
        output += "receipt: %s, " % _receipt
        return output


class ApiValidatePurchaseGoogleRequest extends NakamaAsyncResult:

    const _SCHEMA = {
        "persist": {"name": "_persist", "type": TYPE_BOOL, "required": false}, 
        "purchase": {"name": "_purchase", "type": TYPE_STRING, "required": false}, 
    }


    var _persist
    var persist: bool:
        get:
            return false if not _persist is bool else bool(_persist)


    var _purchase
    var purchase: String:
        get:
            return "" if not _purchase is String else String(_purchase)

    func _init(p_exception = null):
        super (p_exception)

    static func create(p_ns: GDScript, p_dict: Dictionary) -> ApiValidatePurchaseGoogleRequest:
        return _safe_ret(NakamaSerializer.deserialize(p_ns, "ApiValidatePurchaseGoogleRequest", p_dict), ApiValidatePurchaseGoogleRequest) as ApiValidatePurchaseGoogleRequest

    func serialize() -> Dictionary:
        return NakamaSerializer.serialize(self)

    func _to_string() -> String:
        if is_exception():
            return get_exception()._to_string()
        var output: String = ""
        output += "persist: %s, " % _persist
        output += "purchase: %s, " % _purchase
        return output


class ApiValidatePurchaseHuaweiRequest extends NakamaAsyncResult:

    const _SCHEMA = {
        "persist": {"name": "_persist", "type": TYPE_BOOL, "required": false}, 
        "purchase": {"name": "_purchase", "type": TYPE_STRING, "required": false}, 
        "signature": {"name": "_signature", "type": TYPE_STRING, "required": false}, 
    }


    var _persist
    var persist: bool:
        get:
            return false if not _persist is bool else bool(_persist)


    var _purchase
    var purchase: String:
        get:
            return "" if not _purchase is String else String(_purchase)


    var _signature
    var signature: String:
        get:
            return "" if not _signature is String else String(_signature)

    func _init(p_exception = null):
        super (p_exception)

    static func create(p_ns: GDScript, p_dict: Dictionary) -> ApiValidatePurchaseHuaweiRequest:
        return _safe_ret(NakamaSerializer.deserialize(p_ns, "ApiValidatePurchaseHuaweiRequest", p_dict), ApiValidatePurchaseHuaweiRequest) as ApiValidatePurchaseHuaweiRequest

    func serialize() -> Dictionary:
        return NakamaSerializer.serialize(self)

    func _to_string() -> String:
        if is_exception():
            return get_exception()._to_string()
        var output: String = ""
        output += "persist: %s, " % _persist
        output += "purchase: %s, " % _purchase
        output += "signature: %s, " % _signature
        return output


class ApiValidatePurchaseResponse extends NakamaAsyncResult:

    const _SCHEMA = {
        "validated_purchases": {"name": "_validated_purchases", "type": TYPE_ARRAY, "required": false, "content": "ApiValidatedPurchase"}, 
    }


    var _validated_purchases
    var validated_purchases: Array:
        get:
            return Array() if not _validated_purchases is Array else Array(_validated_purchases)

    func _init(p_exception = null):
        super (p_exception)

    static func create(p_ns: GDScript, p_dict: Dictionary) -> ApiValidatePurchaseResponse:
        return _safe_ret(NakamaSerializer.deserialize(p_ns, "ApiValidatePurchaseResponse", p_dict), ApiValidatePurchaseResponse) as ApiValidatePurchaseResponse

    func serialize() -> Dictionary:
        return NakamaSerializer.serialize(self)

    func _to_string() -> String:
        if is_exception():
            return get_exception()._to_string()
        var output: String = ""
        output += "validated_purchases: %s, " % [_validated_purchases]
        return output


class ApiValidateSubscriptionAppleRequest extends NakamaAsyncResult:

    const _SCHEMA = {
        "persist": {"name": "_persist", "type": TYPE_BOOL, "required": false}, 
        "receipt": {"name": "_receipt", "type": TYPE_STRING, "required": false}, 
    }


    var _persist
    var persist: bool:
        get:
            return false if not _persist is bool else bool(_persist)


    var _receipt
    var receipt: String:
        get:
            return "" if not _receipt is String else String(_receipt)

    func _init(p_exception = null):
        super (p_exception)

    static func create(p_ns: GDScript, p_dict: Dictionary) -> ApiValidateSubscriptionAppleRequest:
        return _safe_ret(NakamaSerializer.deserialize(p_ns, "ApiValidateSubscriptionAppleRequest", p_dict), ApiValidateSubscriptionAppleRequest) as ApiValidateSubscriptionAppleRequest

    func serialize() -> Dictionary:
        return NakamaSerializer.serialize(self)

    func _to_string() -> String:
        if is_exception():
            return get_exception()._to_string()
        var output: String = ""
        output += "persist: %s, " % _persist
        output += "receipt: %s, " % _receipt
        return output


class ApiValidateSubscriptionGoogleRequest extends NakamaAsyncResult:

    const _SCHEMA = {
        "persist": {"name": "_persist", "type": TYPE_BOOL, "required": false}, 
        "receipt": {"name": "_receipt", "type": TYPE_STRING, "required": false}, 
    }


    var _persist
    var persist: bool:
        get:
            return false if not _persist is bool else bool(_persist)


    var _receipt
    var receipt: String:
        get:
            return "" if not _receipt is String else String(_receipt)

    func _init(p_exception = null):
        super (p_exception)

    static func create(p_ns: GDScript, p_dict: Dictionary) -> ApiValidateSubscriptionGoogleRequest:
        return _safe_ret(NakamaSerializer.deserialize(p_ns, "ApiValidateSubscriptionGoogleRequest", p_dict), ApiValidateSubscriptionGoogleRequest) as ApiValidateSubscriptionGoogleRequest

    func serialize() -> Dictionary:
        return NakamaSerializer.serialize(self)

    func _to_string() -> String:
        if is_exception():
            return get_exception()._to_string()
        var output: String = ""
        output += "persist: %s, " % _persist
        output += "receipt: %s, " % _receipt
        return output


class ApiValidateSubscriptionResponse extends NakamaAsyncResult:

    const _SCHEMA = {
        "validated_subscription": {"name": "_validated_subscription", "type": "ApiValidatedSubscription", "required": false}, 
    }


    var _validated_subscription
    var validated_subscription: ApiValidatedSubscription:
        get:
            return _validated_subscription as ApiValidatedSubscription

    func _init(p_exception = null):
        super (p_exception)

    static func create(p_ns: GDScript, p_dict: Dictionary) -> ApiValidateSubscriptionResponse:
        return _safe_ret(NakamaSerializer.deserialize(p_ns, "ApiValidateSubscriptionResponse", p_dict), ApiValidateSubscriptionResponse) as ApiValidateSubscriptionResponse

    func serialize() -> Dictionary:
        return NakamaSerializer.serialize(self)

    func _to_string() -> String:
        if is_exception():
            return get_exception()._to_string()
        var output: String = ""
        output += "validated_subscription: %s, " % _validated_subscription
        return output


class ApiValidatedPurchase extends NakamaAsyncResult:

    const _SCHEMA = {
        "create_time": {"name": "_create_time", "type": TYPE_STRING, "required": false}, 
        "environment": {"name": "_environment", "type": TYPE_INT, "required": false}, 
        "product_id": {"name": "_product_id", "type": TYPE_STRING, "required": false}, 
        "provider_response": {"name": "_provider_response", "type": TYPE_STRING, "required": false}, 
        "purchase_time": {"name": "_purchase_time", "type": TYPE_STRING, "required": false}, 
        "refund_time": {"name": "_refund_time", "type": TYPE_STRING, "required": false}, 
        "seen_before": {"name": "_seen_before", "type": TYPE_BOOL, "required": false}, 
        "store": {"name": "_store", "type": TYPE_INT, "required": false}, 
        "transaction_id": {"name": "_transaction_id", "type": TYPE_STRING, "required": false}, 
        "update_time": {"name": "_update_time", "type": TYPE_STRING, "required": false}, 
        "user_id": {"name": "_user_id", "type": TYPE_STRING, "required": false}, 
    }


    var _create_time
    var create_time: String:
        get:
            return "" if not _create_time is String else String(_create_time)


    var _environment
    var environment: int:
        get:
            return ApiStoreEnvironment.values()[0] if not ApiStoreEnvironment.values().has(_environment) else _environment


    var _product_id
    var product_id: String:
        get:
            return "" if not _product_id is String else String(_product_id)


    var _provider_response
    var provider_response: String:
        get:
            return "" if not _provider_response is String else String(_provider_response)


    var _purchase_time
    var purchase_time: String:
        get:
            return "" if not _purchase_time is String else String(_purchase_time)


    var _refund_time
    var refund_time: String:
        get:
            return "" if not _refund_time is String else String(_refund_time)


    var _seen_before
    var seen_before: bool:
        get:
            return false if not _seen_before is bool else bool(_seen_before)


    var _store
    var store: int:
        get:
            return ApiStoreProvider.values()[0] if not ApiStoreProvider.values().has(_store) else _store


    var _transaction_id
    var transaction_id: String:
        get:
            return "" if not _transaction_id is String else String(_transaction_id)


    var _update_time
    var update_time: String:
        get:
            return "" if not _update_time is String else String(_update_time)


    var _user_id
    var user_id: String:
        get:
            return "" if not _user_id is String else String(_user_id)

    func _init(p_exception = null):
        super (p_exception)

    static func create(p_ns: GDScript, p_dict: Dictionary) -> ApiValidatedPurchase:
        return _safe_ret(NakamaSerializer.deserialize(p_ns, "ApiValidatedPurchase", p_dict), ApiValidatedPurchase) as ApiValidatedPurchase

    func serialize() -> Dictionary:
        return NakamaSerializer.serialize(self)

    func _to_string() -> String:
        if is_exception():
            return get_exception()._to_string()
        var output: String = ""
        output += "create_time: %s, " % _create_time
        output += "environment: %s, " % _environment
        output += "product_id: %s, " % _product_id
        output += "provider_response: %s, " % _provider_response
        output += "purchase_time: %s, " % _purchase_time
        output += "refund_time: %s, " % _refund_time
        output += "seen_before: %s, " % _seen_before
        output += "store: %s, " % _store
        output += "transaction_id: %s, " % _transaction_id
        output += "update_time: %s, " % _update_time
        output += "user_id: %s, " % _user_id
        return output


class ApiValidatedSubscription extends NakamaAsyncResult:

    const _SCHEMA = {
        "active": {"name": "_active", "type": TYPE_BOOL, "required": false}, 
        "create_time": {"name": "_create_time", "type": TYPE_STRING, "required": false}, 
        "environment": {"name": "_environment", "type": TYPE_INT, "required": false}, 
        "expiry_time": {"name": "_expiry_time", "type": TYPE_STRING, "required": false}, 
        "original_transaction_id": {"name": "_original_transaction_id", "type": TYPE_STRING, "required": false}, 
        "product_id": {"name": "_product_id", "type": TYPE_STRING, "required": false}, 
        "provider_notification": {"name": "_provider_notification", "type": TYPE_STRING, "required": false}, 
        "provider_response": {"name": "_provider_response", "type": TYPE_STRING, "required": false}, 
        "purchase_time": {"name": "_purchase_time", "type": TYPE_STRING, "required": false}, 
        "refund_time": {"name": "_refund_time", "type": TYPE_STRING, "required": false}, 
        "store": {"name": "_store", "type": TYPE_INT, "required": false}, 
        "update_time": {"name": "_update_time", "type": TYPE_STRING, "required": false}, 
        "user_id": {"name": "_user_id", "type": TYPE_STRING, "required": false}, 
    }


    var _active
    var active: bool:
        get:
            return false if not _active is bool else bool(_active)


    var _create_time
    var create_time: String:
        get:
            return "" if not _create_time is String else String(_create_time)


    var _environment
    var environment: int:
        get:
            return ApiStoreEnvironment.values()[0] if not ApiStoreEnvironment.values().has(_environment) else _environment


    var _expiry_time
    var expiry_time: String:
        get:
            return "" if not _expiry_time is String else String(_expiry_time)


    var _original_transaction_id
    var original_transaction_id: String:
        get:
            return "" if not _original_transaction_id is String else String(_original_transaction_id)


    var _product_id
    var product_id: String:
        get:
            return "" if not _product_id is String else String(_product_id)


    var _provider_notification
    var provider_notification: String:
        get:
            return "" if not _provider_notification is String else String(_provider_notification)


    var _provider_response
    var provider_response: String:
        get:
            return "" if not _provider_response is String else String(_provider_response)


    var _purchase_time
    var purchase_time: String:
        get:
            return "" if not _purchase_time is String else String(_purchase_time)


    var _refund_time
    var refund_time: String:
        get:
            return "" if not _refund_time is String else String(_refund_time)


    var _store
    var store: int:
        get:
            return ApiStoreProvider.values()[0] if not ApiStoreProvider.values().has(_store) else _store


    var _update_time
    var update_time: String:
        get:
            return "" if not _update_time is String else String(_update_time)


    var _user_id
    var user_id: String:
        get:
            return "" if not _user_id is String else String(_user_id)

    func _init(p_exception = null):
        super (p_exception)

    static func create(p_ns: GDScript, p_dict: Dictionary) -> ApiValidatedSubscription:
        return _safe_ret(NakamaSerializer.deserialize(p_ns, "ApiValidatedSubscription", p_dict), ApiValidatedSubscription) as ApiValidatedSubscription

    func serialize() -> Dictionary:
        return NakamaSerializer.serialize(self)

    func _to_string() -> String:
        if is_exception():
            return get_exception()._to_string()
        var output: String = ""
        output += "active: %s, " % _active
        output += "create_time: %s, " % _create_time
        output += "environment: %s, " % _environment
        output += "expiry_time: %s, " % _expiry_time
        output += "original_transaction_id: %s, " % _original_transaction_id
        output += "product_id: %s, " % _product_id
        output += "provider_notification: %s, " % _provider_notification
        output += "provider_response: %s, " % _provider_response
        output += "purchase_time: %s, " % _purchase_time
        output += "refund_time: %s, " % _refund_time
        output += "store: %s, " % _store
        output += "update_time: %s, " % _update_time
        output += "user_id: %s, " % _user_id
        return output


class ApiWriteStorageObject extends NakamaAsyncResult:

    const _SCHEMA = {
        "collection": {"name": "_collection", "type": TYPE_STRING, "required": false}, 
        "key": {"name": "_key", "type": TYPE_STRING, "required": false}, 
        "permission_read": {"name": "_permission_read", "type": TYPE_INT, "required": false}, 
        "permission_write": {"name": "_permission_write", "type": TYPE_INT, "required": false}, 
        "value": {"name": "_value", "type": TYPE_STRING, "required": false}, 
        "version": {"name": "_version", "type": TYPE_STRING, "required": false}, 
    }


    var _collection
    var collection: String:
        get:
            return "" if not _collection is String else String(_collection)


    var _key
    var key: String:
        get:
            return "" if not _key is String else String(_key)


    var _permission_read
    var permission_read: int:
        get:
            return 0 if not _permission_read is int else int(_permission_read)


    var _permission_write
    var permission_write: int:
        get:
            return 0 if not _permission_write is int else int(_permission_write)


    var _value
    var value: String:
        get:
            return "" if not _value is String else String(_value)


    var _version
    var version: String:
        get:
            return "" if not _version is String else String(_version)

    func _init(p_exception = null):
        super (p_exception)

    static func create(p_ns: GDScript, p_dict: Dictionary) -> ApiWriteStorageObject:
        return _safe_ret(NakamaSerializer.deserialize(p_ns, "ApiWriteStorageObject", p_dict), ApiWriteStorageObject) as ApiWriteStorageObject

    func serialize() -> Dictionary:
        return NakamaSerializer.serialize(self)

    func _to_string() -> String:
        if is_exception():
            return get_exception()._to_string()
        var output: String = ""
        output += "collection: %s, " % _collection
        output += "key: %s, " % _key
        output += "permission_read: %s, " % _permission_read
        output += "permission_write: %s, " % _permission_write
        output += "value: %s, " % _value
        output += "version: %s, " % _version
        return output


class ApiWriteStorageObjectsRequest extends NakamaAsyncResult:

    const _SCHEMA = {
        "objects": {"name": "_objects", "type": TYPE_ARRAY, "required": false, "content": "ApiWriteStorageObject"}, 
    }


    var _objects
    var objects: Array:
        get:
            return Array() if not _objects is Array else Array(_objects)

    func _init(p_exception = null):
        super (p_exception)

    static func create(p_ns: GDScript, p_dict: Dictionary) -> ApiWriteStorageObjectsRequest:
        return _safe_ret(NakamaSerializer.deserialize(p_ns, "ApiWriteStorageObjectsRequest", p_dict), ApiWriteStorageObjectsRequest) as ApiWriteStorageObjectsRequest

    func serialize() -> Dictionary:
        return NakamaSerializer.serialize(self)

    func _to_string() -> String:
        if is_exception():
            return get_exception()._to_string()
        var output: String = ""
        output += "objects: %s, " % [_objects]
        return output


class ProtobufAny extends NakamaAsyncResult:

    const _SCHEMA = {
        "type_url": {"name": "_type_url", "type": TYPE_STRING, "required": false}, 
        "value": {"name": "_value", "type": TYPE_STRING, "required": false}, 
    }


    var _type_url
    var type_url: String:
        get:
            return "" if not _type_url is String else String(_type_url)


    var _value
    var value: String:
        get:
            return "" if not _value is String else String(_value)

    func _init(p_exception = null):
        super (p_exception)

    static func create(p_ns: GDScript, p_dict: Dictionary) -> ProtobufAny:
        return _safe_ret(NakamaSerializer.deserialize(p_ns, "ProtobufAny", p_dict), ProtobufAny) as ProtobufAny

    func serialize() -> Dictionary:
        return NakamaSerializer.serialize(self)

    func _to_string() -> String:
        if is_exception():
            return get_exception()._to_string()
        var output: String = ""
        output += "type_url: %s, " % _type_url
        output += "value: %s, " % _value
        return output


class RpcStatus extends NakamaAsyncResult:

    const _SCHEMA = {
        "code": {"name": "_code", "type": TYPE_INT, "required": false}, 
        "details": {"name": "_details", "type": TYPE_ARRAY, "required": false, "content": "ProtobufAny"}, 
        "message": {"name": "_message", "type": TYPE_STRING, "required": false}, 
    }


    var _code
    var code: int:
        get:
            return 0 if not _code is int else int(_code)


    var _details
    var details: Array:
        get:
            return Array() if not _details is Array else Array(_details)


    var _message
    var message: String:
        get:
            return "" if not _message is String else String(_message)

    func _init(p_exception = null):
        super (p_exception)

    static func create(p_ns: GDScript, p_dict: Dictionary) -> RpcStatus:
        return _safe_ret(NakamaSerializer.deserialize(p_ns, "RpcStatus", p_dict), RpcStatus) as RpcStatus

    func serialize() -> Dictionary:
        return NakamaSerializer.serialize(self)

    func _to_string() -> String:
        if is_exception():
            return get_exception()._to_string()
        var output: String = ""
        output += "code: %s, " % _code
        output += "details: %s, " % [_details]
        output += "message: %s, " % _message
        return output


class ApiClient extends RefCounted:

    var _base_uri: String

    var _http_adapter
    var _namespace: GDScript
    var _server_key: String
    var auto_refresh: = true
    var auto_refresh_time: = 300

    var auto_retry: bool:
        set(p_value):
            _http_adapter.auto_retry = p_value
        get:
            return _http_adapter.auto_retry

    var auto_retry_count: int:
        set(p_value):
            _http_adapter.auto_retry_count = p_value
        get:
            return _http_adapter.auto_retry_count

    var auto_retry_backoff_base: int:
        set(p_value):
            _http_adapter.auto_retry_backoff_base = p_value
        get:
            return _http_adapter.auto_retry_backoff_base

    var last_cancel_token:
        get:
            return _http_adapter.get_last_token()

    func _init(p_base_uri: String, p_http_adapter, p_namespace: GDScript, p_server_key: String, p_timeout: int = 10):
        _base_uri = p_base_uri
        _http_adapter = p_http_adapter
        _http_adapter.timeout = p_timeout
        _namespace = p_namespace
        _server_key = p_server_key

    func _refresh_session(p_session: NakamaSession):
        if auto_refresh and p_session.is_valid() and p_session.refresh_token and not p_session.is_refresh_expired() and p_session.would_expire_in(auto_refresh_time):
            var request = ApiSessionRefreshRequest.new()
            request._token = p_session.refresh_token
            return await session_refresh_async(_server_key, "", request)
        return null

    func cancel_request(p_token):
        if p_token:
            _http_adapter.cancel_request(p_token)


    func healthcheck_async(
        p_session: NakamaSession
    ) -> NakamaAsyncResult:
        var try_refresh = await _refresh_session(p_session)
        if try_refresh != null:
            if try_refresh.is_exception():
                return NakamaAsyncResult.new(try_refresh.get_exception())
            await p_session.refresh(try_refresh)
        var urlpath: String = "/healthcheck"
        var query_params = ""
        var uri = "%s%s%s" % [_base_uri, urlpath, "?" + query_params if query_params else ""]
        var method = "GET"
        var headers = {}
        var header = "Bearer %s" % p_session.token
        headers["Authorization"] = header

        var content: PackedByteArray

        var result = await _http_adapter.send_async(method, uri, headers, content)
        if result is NakamaException:
            return NakamaAsyncResult.new(result)
        return NakamaAsyncResult.new()


    func delete_account_async(
        p_session: NakamaSession
    ) -> NakamaAsyncResult:
        var try_refresh = await _refresh_session(p_session)
        if try_refresh != null:
            if try_refresh.is_exception():
                return NakamaAsyncResult.new(try_refresh.get_exception())
            await p_session.refresh(try_refresh)
        var urlpath: String = "/v2/account"
        var query_params = ""
        var uri = "%s%s%s" % [_base_uri, urlpath, "?" + query_params if query_params else ""]
        var method = "DELETE"
        var headers = {}
        var header = "Bearer %s" % p_session.token
        headers["Authorization"] = header

        var content: PackedByteArray

        var result = await _http_adapter.send_async(method, uri, headers, content)
        if result is NakamaException:
            return NakamaAsyncResult.new(result)
        return NakamaAsyncResult.new()


    func get_account_async(
        p_session: NakamaSession
    ) -> ApiAccount:
        var try_refresh = await _refresh_session(p_session)
        if try_refresh != null:
            if try_refresh.is_exception():
                return ApiAccount.new(try_refresh.get_exception())
            await p_session.refresh(try_refresh)
        var urlpath: String = "/v2/account"
        var query_params = ""
        var uri = "%s%s%s" % [_base_uri, urlpath, "?" + query_params if query_params else ""]
        var method = "GET"
        var headers = {}
        var header = "Bearer %s" % p_session.token
        headers["Authorization"] = header

        var content: PackedByteArray

        var result = await _http_adapter.send_async(method, uri, headers, content)
        if result is NakamaException:
            return ApiAccount.new(result)
        var out: ApiAccount = NakamaSerializer.deserialize(_namespace, "ApiAccount", result)
        return out


    func update_account_async(
        p_session: NakamaSession
        , p_body: ApiUpdateAccountRequest
    ) -> NakamaAsyncResult:
        var try_refresh = await _refresh_session(p_session)
        if try_refresh != null:
            if try_refresh.is_exception():
                return NakamaAsyncResult.new(try_refresh.get_exception())
            await p_session.refresh(try_refresh)
        var urlpath: String = "/v2/account"
        var query_params = ""
        var uri = "%s%s%s" % [_base_uri, urlpath, "?" + query_params if query_params else ""]
        var method = "PUT"
        var headers = {}
        var header = "Bearer %s" % p_session.token
        headers["Authorization"] = header

        var content: PackedByteArray
        content = JSON.stringify(p_body.serialize()).to_utf8_buffer()

        var result = await _http_adapter.send_async(method, uri, headers, content)
        if result is NakamaException:
            return NakamaAsyncResult.new(result)
        return NakamaAsyncResult.new()


    func authenticate_apple_async(
        p_basic_auth_username: String
        , p_basic_auth_password: String
        , p_account: ApiAccountApple
        , p_create = null
        , p_username = null
    ) -> ApiSession:
        var urlpath: String = "/v2/account/authenticate/apple"
        var query_params = ""
        if p_create != null:
            query_params += "create=%s&" % str(bool(p_create)).to_lower()
        if p_username != null:
            query_params += "username=%s&" % NakamaSerializer.escape_http(p_username)
        var uri = "%s%s%s" % [_base_uri, urlpath, "?" + query_params if query_params else ""]
        var method = "POST"
        var headers = {}
        var credentials = Marshalls.utf8_to_base64(p_basic_auth_username + ":" + p_basic_auth_password)
        var header = "Basic %s" % credentials
        headers["Authorization"] = header

        var content: PackedByteArray
        content = JSON.stringify(p_account.serialize()).to_utf8_buffer()

        var result = await _http_adapter.send_async(method, uri, headers, content)
        if result is NakamaException:
            return ApiSession.new(result)
        var out: ApiSession = NakamaSerializer.deserialize(_namespace, "ApiSession", result)
        return out


    func authenticate_custom_async(
        p_basic_auth_username: String
        , p_basic_auth_password: String
        , p_account: ApiAccountCustom
        , p_create = null
        , p_username = null
    ) -> ApiSession:
        var urlpath: String = "/v2/account/authenticate/custom"
        var query_params = ""
        if p_create != null:
            query_params += "create=%s&" % str(bool(p_create)).to_lower()
        if p_username != null:
            query_params += "username=%s&" % NakamaSerializer.escape_http(p_username)
        var uri = "%s%s%s" % [_base_uri, urlpath, "?" + query_params if query_params else ""]
        var method = "POST"
        var headers = {}
        var credentials = Marshalls.utf8_to_base64(p_basic_auth_username + ":" + p_basic_auth_password)
        var header = "Basic %s" % credentials
        headers["Authorization"] = header

        var content: PackedByteArray
        content = JSON.stringify(p_account.serialize()).to_utf8_buffer()

        var result = await _http_adapter.send_async(method, uri, headers, content)
        if result is NakamaException:
            return ApiSession.new(result)
        var out: ApiSession = NakamaSerializer.deserialize(_namespace, "ApiSession", result)
        return out


    func authenticate_device_async(
        p_basic_auth_username: String
        , p_basic_auth_password: String
        , p_account: ApiAccountDevice
        , p_create = null
        , p_username = null
    ) -> ApiSession:
        var urlpath: String = "/v2/account/authenticate/device"
        var query_params = ""
        if p_create != null:
            query_params += "create=%s&" % str(bool(p_create)).to_lower()
        if p_username != null:
            query_params += "username=%s&" % NakamaSerializer.escape_http(p_username)
        var uri = "%s%s%s" % [_base_uri, urlpath, "?" + query_params if query_params else ""]
        var method = "POST"
        var headers = {}
        var credentials = Marshalls.utf8_to_base64(p_basic_auth_username + ":" + p_basic_auth_password)
        var header = "Basic %s" % credentials
        headers["Authorization"] = header

        var content: PackedByteArray
        content = JSON.stringify(p_account.serialize()).to_utf8_buffer()

        var result = await _http_adapter.send_async(method, uri, headers, content)
        if result is NakamaException:
            return ApiSession.new(result)
        var out: ApiSession = NakamaSerializer.deserialize(_namespace, "ApiSession", result)
        return out


    func authenticate_email_async(
        p_basic_auth_username: String
        , p_basic_auth_password: String
        , p_account: ApiAccountEmail
        , p_create = null
        , p_username = null
    ) -> ApiSession:
        var urlpath: String = "/v2/account/authenticate/email"
        var query_params = ""
        if p_create != null:
            query_params += "create=%s&" % str(bool(p_create)).to_lower()
        if p_username != null:
            query_params += "username=%s&" % NakamaSerializer.escape_http(p_username)
        var uri = "%s%s%s" % [_base_uri, urlpath, "?" + query_params if query_params else ""]
        var method = "POST"
        var headers = {}
        var credentials = Marshalls.utf8_to_base64(p_basic_auth_username + ":" + p_basic_auth_password)
        var header = "Basic %s" % credentials
        headers["Authorization"] = header

        var content: PackedByteArray
        content = JSON.stringify(p_account.serialize()).to_utf8_buffer()

        var result = await _http_adapter.send_async(method, uri, headers, content)
        if result is NakamaException:
            return ApiSession.new(result)
        var out: ApiSession = NakamaSerializer.deserialize(_namespace, "ApiSession", result)
        return out


    func authenticate_facebook_async(
        p_basic_auth_username: String
        , p_basic_auth_password: String
        , p_account: ApiAccountFacebook
        , p_create = null
        , p_username = null
        , p_sync = null
    ) -> ApiSession:
        var urlpath: String = "/v2/account/authenticate/facebook"
        var query_params = ""
        if p_create != null:
            query_params += "create=%s&" % str(bool(p_create)).to_lower()
        if p_username != null:
            query_params += "username=%s&" % NakamaSerializer.escape_http(p_username)
        if p_sync != null:
            query_params += "sync=%s&" % str(bool(p_sync)).to_lower()
        var uri = "%s%s%s" % [_base_uri, urlpath, "?" + query_params if query_params else ""]
        var method = "POST"
        var headers = {}
        var credentials = Marshalls.utf8_to_base64(p_basic_auth_username + ":" + p_basic_auth_password)
        var header = "Basic %s" % credentials
        headers["Authorization"] = header

        var content: PackedByteArray
        content = JSON.stringify(p_account.serialize()).to_utf8_buffer()

        var result = await _http_adapter.send_async(method, uri, headers, content)
        if result is NakamaException:
            return ApiSession.new(result)
        var out: ApiSession = NakamaSerializer.deserialize(_namespace, "ApiSession", result)
        return out


    func authenticate_facebook_instant_game_async(
        p_basic_auth_username: String
        , p_basic_auth_password: String
        , p_account: ApiAccountFacebookInstantGame
        , p_create = null
        , p_username = null
    ) -> ApiSession:
        var urlpath: String = "/v2/account/authenticate/facebookinstantgame"
        var query_params = ""
        if p_create != null:
            query_params += "create=%s&" % str(bool(p_create)).to_lower()
        if p_username != null:
            query_params += "username=%s&" % NakamaSerializer.escape_http(p_username)
        var uri = "%s%s%s" % [_base_uri, urlpath, "?" + query_params if query_params else ""]
        var method = "POST"
        var headers = {}
        var credentials = Marshalls.utf8_to_base64(p_basic_auth_username + ":" + p_basic_auth_password)
        var header = "Basic %s" % credentials
        headers["Authorization"] = header

        var content: PackedByteArray
        content = JSON.stringify(p_account.serialize()).to_utf8_buffer()

        var result = await _http_adapter.send_async(method, uri, headers, content)
        if result is NakamaException:
            return ApiSession.new(result)
        var out: ApiSession = NakamaSerializer.deserialize(_namespace, "ApiSession", result)
        return out


    func authenticate_game_center_async(
        p_basic_auth_username: String
        , p_basic_auth_password: String
        , p_account: ApiAccountGameCenter
        , p_create = null
        , p_username = null
    ) -> ApiSession:
        var urlpath: String = "/v2/account/authenticate/gamecenter"
        var query_params = ""
        if p_create != null:
            query_params += "create=%s&" % str(bool(p_create)).to_lower()
        if p_username != null:
            query_params += "username=%s&" % NakamaSerializer.escape_http(p_username)
        var uri = "%s%s%s" % [_base_uri, urlpath, "?" + query_params if query_params else ""]
        var method = "POST"
        var headers = {}
        var credentials = Marshalls.utf8_to_base64(p_basic_auth_username + ":" + p_basic_auth_password)
        var header = "Basic %s" % credentials
        headers["Authorization"] = header

        var content: PackedByteArray
        content = JSON.stringify(p_account.serialize()).to_utf8_buffer()

        var result = await _http_adapter.send_async(method, uri, headers, content)
        if result is NakamaException:
            return ApiSession.new(result)
        var out: ApiSession = NakamaSerializer.deserialize(_namespace, "ApiSession", result)
        return out


    func authenticate_google_async(
        p_basic_auth_username: String
        , p_basic_auth_password: String
        , p_account: ApiAccountGoogle
        , p_create = null
        , p_username = null
    ) -> ApiSession:
        var urlpath: String = "/v2/account/authenticate/google"
        var query_params = ""
        if p_create != null:
            query_params += "create=%s&" % str(bool(p_create)).to_lower()
        if p_username != null:
            query_params += "username=%s&" % NakamaSerializer.escape_http(p_username)
        var uri = "%s%s%s" % [_base_uri, urlpath, "?" + query_params if query_params else ""]
        var method = "POST"
        var headers = {}
        var credentials = Marshalls.utf8_to_base64(p_basic_auth_username + ":" + p_basic_auth_password)
        var header = "Basic %s" % credentials
        headers["Authorization"] = header

        var content: PackedByteArray
        content = JSON.stringify(p_account.serialize()).to_utf8_buffer()

        var result = await _http_adapter.send_async(method, uri, headers, content)
        if result is NakamaException:
            return ApiSession.new(result)
        var out: ApiSession = NakamaSerializer.deserialize(_namespace, "ApiSession", result)
        return out


    func authenticate_steam_async(
        p_basic_auth_username: String
        , p_basic_auth_password: String
        , p_account: ApiAccountSteam
        , p_create = null
        , p_username = null
        , p_sync = null
    ) -> ApiSession:
        var urlpath: String = "/v2/account/authenticate/steam"
        var query_params = ""
        if p_create != null:
            query_params += "create=%s&" % str(bool(p_create)).to_lower()
        if p_username != null:
            query_params += "username=%s&" % NakamaSerializer.escape_http(p_username)
        if p_sync != null:
            query_params += "sync=%s&" % str(bool(p_sync)).to_lower()
        var uri = "%s%s%s" % [_base_uri, urlpath, "?" + query_params if query_params else ""]
        var method = "POST"
        var headers = {}
        var credentials = Marshalls.utf8_to_base64(p_basic_auth_username + ":" + p_basic_auth_password)
        var header = "Basic %s" % credentials
        headers["Authorization"] = header

        var content: PackedByteArray
        content = JSON.stringify(p_account.serialize()).to_utf8_buffer()

        var result = await _http_adapter.send_async(method, uri, headers, content)
        if result is NakamaException:
            return ApiSession.new(result)
        var out: ApiSession = NakamaSerializer.deserialize(_namespace, "ApiSession", result)
        return out


    func link_apple_async(
        p_session: NakamaSession
        , p_body: ApiAccountApple
    ) -> NakamaAsyncResult:
        var try_refresh = await _refresh_session(p_session)
        if try_refresh != null:
            if try_refresh.is_exception():
                return NakamaAsyncResult.new(try_refresh.get_exception())
            await p_session.refresh(try_refresh)
        var urlpath: String = "/v2/account/link/apple"
        var query_params = ""
        var uri = "%s%s%s" % [_base_uri, urlpath, "?" + query_params if query_params else ""]
        var method = "POST"
        var headers = {}
        var header = "Bearer %s" % p_session.token
        headers["Authorization"] = header

        var content: PackedByteArray
        content = JSON.stringify(p_body.serialize()).to_utf8_buffer()

        var result = await _http_adapter.send_async(method, uri, headers, content)
        if result is NakamaException:
            return NakamaAsyncResult.new(result)
        return NakamaAsyncResult.new()


    func link_custom_async(
        p_session: NakamaSession
        , p_body: ApiAccountCustom
    ) -> NakamaAsyncResult:
        var try_refresh = await _refresh_session(p_session)
        if try_refresh != null:
            if try_refresh.is_exception():
                return NakamaAsyncResult.new(try_refresh.get_exception())
            await p_session.refresh(try_refresh)
        var urlpath: String = "/v2/account/link/custom"
        var query_params = ""
        var uri = "%s%s%s" % [_base_uri, urlpath, "?" + query_params if query_params else ""]
        var method = "POST"
        var headers = {}
        var header = "Bearer %s" % p_session.token
        headers["Authorization"] = header

        var content: PackedByteArray
        content = JSON.stringify(p_body.serialize()).to_utf8_buffer()

        var result = await _http_adapter.send_async(method, uri, headers, content)
        if result is NakamaException:
            return NakamaAsyncResult.new(result)
        return NakamaAsyncResult.new()


    func link_device_async(
        p_session: NakamaSession
        , p_body: ApiAccountDevice
    ) -> NakamaAsyncResult:
        var try_refresh = await _refresh_session(p_session)
        if try_refresh != null:
            if try_refresh.is_exception():
                return NakamaAsyncResult.new(try_refresh.get_exception())
            await p_session.refresh(try_refresh)
        var urlpath: String = "/v2/account/link/device"
        var query_params = ""
        var uri = "%s%s%s" % [_base_uri, urlpath, "?" + query_params if query_params else ""]
        var method = "POST"
        var headers = {}
        var header = "Bearer %s" % p_session.token
        headers["Authorization"] = header

        var content: PackedByteArray
        content = JSON.stringify(p_body.serialize()).to_utf8_buffer()

        var result = await _http_adapter.send_async(method, uri, headers, content)
        if result is NakamaException:
            return NakamaAsyncResult.new(result)
        return NakamaAsyncResult.new()


    func link_email_async(
        p_session: NakamaSession
        , p_body: ApiAccountEmail
    ) -> NakamaAsyncResult:
        var try_refresh = await _refresh_session(p_session)
        if try_refresh != null:
            if try_refresh.is_exception():
                return NakamaAsyncResult.new(try_refresh.get_exception())
            await p_session.refresh(try_refresh)
        var urlpath: String = "/v2/account/link/email"
        var query_params = ""
        var uri = "%s%s%s" % [_base_uri, urlpath, "?" + query_params if query_params else ""]
        var method = "POST"
        var headers = {}
        var header = "Bearer %s" % p_session.token
        headers["Authorization"] = header

        var content: PackedByteArray
        content = JSON.stringify(p_body.serialize()).to_utf8_buffer()

        var result = await _http_adapter.send_async(method, uri, headers, content)
        if result is NakamaException:
            return NakamaAsyncResult.new(result)
        return NakamaAsyncResult.new()


    func link_facebook_async(
        p_session: NakamaSession
        , p_account: ApiAccountFacebook
        , p_sync = null
    ) -> NakamaAsyncResult:
        var try_refresh = await _refresh_session(p_session)
        if try_refresh != null:
            if try_refresh.is_exception():
                return NakamaAsyncResult.new(try_refresh.get_exception())
            await p_session.refresh(try_refresh)
        var urlpath: String = "/v2/account/link/facebook"
        var query_params = ""
        if p_sync != null:
            query_params += "sync=%s&" % str(bool(p_sync)).to_lower()
        var uri = "%s%s%s" % [_base_uri, urlpath, "?" + query_params if query_params else ""]
        var method = "POST"
        var headers = {}
        var header = "Bearer %s" % p_session.token
        headers["Authorization"] = header

        var content: PackedByteArray
        content = JSON.stringify(p_account.serialize()).to_utf8_buffer()

        var result = await _http_adapter.send_async(method, uri, headers, content)
        if result is NakamaException:
            return NakamaAsyncResult.new(result)
        return NakamaAsyncResult.new()


    func link_facebook_instant_game_async(
        p_session: NakamaSession
        , p_body: ApiAccountFacebookInstantGame
    ) -> NakamaAsyncResult:
        var try_refresh = await _refresh_session(p_session)
        if try_refresh != null:
            if try_refresh.is_exception():
                return NakamaAsyncResult.new(try_refresh.get_exception())
            await p_session.refresh(try_refresh)
        var urlpath: String = "/v2/account/link/facebookinstantgame"
        var query_params = ""
        var uri = "%s%s%s" % [_base_uri, urlpath, "?" + query_params if query_params else ""]
        var method = "POST"
        var headers = {}
        var header = "Bearer %s" % p_session.token
        headers["Authorization"] = header

        var content: PackedByteArray
        content = JSON.stringify(p_body.serialize()).to_utf8_buffer()

        var result = await _http_adapter.send_async(method, uri, headers, content)
        if result is NakamaException:
            return NakamaAsyncResult.new(result)
        return NakamaAsyncResult.new()


    func link_game_center_async(
        p_session: NakamaSession
        , p_body: ApiAccountGameCenter
    ) -> NakamaAsyncResult:
        var try_refresh = await _refresh_session(p_session)
        if try_refresh != null:
            if try_refresh.is_exception():
                return NakamaAsyncResult.new(try_refresh.get_exception())
            await p_session.refresh(try_refresh)
        var urlpath: String = "/v2/account/link/gamecenter"
        var query_params = ""
        var uri = "%s%s%s" % [_base_uri, urlpath, "?" + query_params if query_params else ""]
        var method = "POST"
        var headers = {}
        var header = "Bearer %s" % p_session.token
        headers["Authorization"] = header

        var content: PackedByteArray
        content = JSON.stringify(p_body.serialize()).to_utf8_buffer()

        var result = await _http_adapter.send_async(method, uri, headers, content)
        if result is NakamaException:
            return NakamaAsyncResult.new(result)
        return NakamaAsyncResult.new()


    func link_google_async(
        p_session: NakamaSession
        , p_body: ApiAccountGoogle
    ) -> NakamaAsyncResult:
        var try_refresh = await _refresh_session(p_session)
        if try_refresh != null:
            if try_refresh.is_exception():
                return NakamaAsyncResult.new(try_refresh.get_exception())
            await p_session.refresh(try_refresh)
        var urlpath: String = "/v2/account/link/google"
        var query_params = ""
        var uri = "%s%s%s" % [_base_uri, urlpath, "?" + query_params if query_params else ""]
        var method = "POST"
        var headers = {}
        var header = "Bearer %s" % p_session.token
        headers["Authorization"] = header

        var content: PackedByteArray
        content = JSON.stringify(p_body.serialize()).to_utf8_buffer()

        var result = await _http_adapter.send_async(method, uri, headers, content)
        if result is NakamaException:
            return NakamaAsyncResult.new(result)
        return NakamaAsyncResult.new()


    func link_steam_async(
        p_session: NakamaSession
        , p_body: ApiLinkSteamRequest
    ) -> NakamaAsyncResult:
        var try_refresh = await _refresh_session(p_session)
        if try_refresh != null:
            if try_refresh.is_exception():
                return NakamaAsyncResult.new(try_refresh.get_exception())
            await p_session.refresh(try_refresh)
        var urlpath: String = "/v2/account/link/steam"
        var query_params = ""
        var uri = "%s%s%s" % [_base_uri, urlpath, "?" + query_params if query_params else ""]
        var method = "POST"
        var headers = {}
        var header = "Bearer %s" % p_session.token
        headers["Authorization"] = header

        var content: PackedByteArray
        content = JSON.stringify(p_body.serialize()).to_utf8_buffer()

        var result = await _http_adapter.send_async(method, uri, headers, content)
        if result is NakamaException:
            return NakamaAsyncResult.new(result)
        return NakamaAsyncResult.new()


    func session_refresh_async(
        p_basic_auth_username: String
        , p_basic_auth_password: String
        , p_body: ApiSessionRefreshRequest
    ) -> ApiSession:
        var urlpath: String = "/v2/account/session/refresh"
        var query_params = ""
        var uri = "%s%s%s" % [_base_uri, urlpath, "?" + query_params if query_params else ""]
        var method = "POST"
        var headers = {}
        var credentials = Marshalls.utf8_to_base64(p_basic_auth_username + ":" + p_basic_auth_password)
        var header = "Basic %s" % credentials
        headers["Authorization"] = header

        var content: PackedByteArray
        content = JSON.stringify(p_body.serialize()).to_utf8_buffer()

        var result = await _http_adapter.send_async(method, uri, headers, content)
        if result is NakamaException:
            return ApiSession.new(result)
        var out: ApiSession = NakamaSerializer.deserialize(_namespace, "ApiSession", result)
        return out


    func unlink_apple_async(
        p_session: NakamaSession
        , p_body: ApiAccountApple
    ) -> NakamaAsyncResult:
        var try_refresh = await _refresh_session(p_session)
        if try_refresh != null:
            if try_refresh.is_exception():
                return NakamaAsyncResult.new(try_refresh.get_exception())
            await p_session.refresh(try_refresh)
        var urlpath: String = "/v2/account/unlink/apple"
        var query_params = ""
        var uri = "%s%s%s" % [_base_uri, urlpath, "?" + query_params if query_params else ""]
        var method = "POST"
        var headers = {}
        var header = "Bearer %s" % p_session.token
        headers["Authorization"] = header

        var content: PackedByteArray
        content = JSON.stringify(p_body.serialize()).to_utf8_buffer()

        var result = await _http_adapter.send_async(method, uri, headers, content)
        if result is NakamaException:
            return NakamaAsyncResult.new(result)
        return NakamaAsyncResult.new()


    func unlink_custom_async(
        p_session: NakamaSession
        , p_body: ApiAccountCustom
    ) -> NakamaAsyncResult:
        var try_refresh = await _refresh_session(p_session)
        if try_refresh != null:
            if try_refresh.is_exception():
                return NakamaAsyncResult.new(try_refresh.get_exception())
            await p_session.refresh(try_refresh)
        var urlpath: String = "/v2/account/unlink/custom"
        var query_params = ""
        var uri = "%s%s%s" % [_base_uri, urlpath, "?" + query_params if query_params else ""]
        var method = "POST"
        var headers = {}
        var header = "Bearer %s" % p_session.token
        headers["Authorization"] = header

        var content: PackedByteArray
        content = JSON.stringify(p_body.serialize()).to_utf8_buffer()

        var result = await _http_adapter.send_async(method, uri, headers, content)
        if result is NakamaException:
            return NakamaAsyncResult.new(result)
        return NakamaAsyncResult.new()


    func unlink_device_async(
        p_session: NakamaSession
        , p_body: ApiAccountDevice
    ) -> NakamaAsyncResult:
        var try_refresh = await _refresh_session(p_session)
        if try_refresh != null:
            if try_refresh.is_exception():
                return NakamaAsyncResult.new(try_refresh.get_exception())
            await p_session.refresh(try_refresh)
        var urlpath: String = "/v2/account/unlink/device"
        var query_params = ""
        var uri = "%s%s%s" % [_base_uri, urlpath, "?" + query_params if query_params else ""]
        var method = "POST"
        var headers = {}
        var header = "Bearer %s" % p_session.token
        headers["Authorization"] = header

        var content: PackedByteArray
        content = JSON.stringify(p_body.serialize()).to_utf8_buffer()

        var result = await _http_adapter.send_async(method, uri, headers, content)
        if result is NakamaException:
            return NakamaAsyncResult.new(result)
        return NakamaAsyncResult.new()


    func unlink_email_async(
        p_session: NakamaSession
        , p_body: ApiAccountEmail
    ) -> NakamaAsyncResult:
        var try_refresh = await _refresh_session(p_session)
        if try_refresh != null:
            if try_refresh.is_exception():
                return NakamaAsyncResult.new(try_refresh.get_exception())
            await p_session.refresh(try_refresh)
        var urlpath: String = "/v2/account/unlink/email"
        var query_params = ""
        var uri = "%s%s%s" % [_base_uri, urlpath, "?" + query_params if query_params else ""]
        var method = "POST"
        var headers = {}
        var header = "Bearer %s" % p_session.token
        headers["Authorization"] = header

        var content: PackedByteArray
        content = JSON.stringify(p_body.serialize()).to_utf8_buffer()

        var result = await _http_adapter.send_async(method, uri, headers, content)
        if result is NakamaException:
            return NakamaAsyncResult.new(result)
        return NakamaAsyncResult.new()


    func unlink_facebook_async(
        p_session: NakamaSession
        , p_body: ApiAccountFacebook
    ) -> NakamaAsyncResult:
        var try_refresh = await _refresh_session(p_session)
        if try_refresh != null:
            if try_refresh.is_exception():
                return NakamaAsyncResult.new(try_refresh.get_exception())
            await p_session.refresh(try_refresh)
        var urlpath: String = "/v2/account/unlink/facebook"
        var query_params = ""
        var uri = "%s%s%s" % [_base_uri, urlpath, "?" + query_params if query_params else ""]
        var method = "POST"
        var headers = {}
        var header = "Bearer %s" % p_session.token
        headers["Authorization"] = header

        var content: PackedByteArray
        content = JSON.stringify(p_body.serialize()).to_utf8_buffer()

        var result = await _http_adapter.send_async(method, uri, headers, content)
        if result is NakamaException:
            return NakamaAsyncResult.new(result)
        return NakamaAsyncResult.new()


    func unlink_facebook_instant_game_async(
        p_session: NakamaSession
        , p_body: ApiAccountFacebookInstantGame
    ) -> NakamaAsyncResult:
        var try_refresh = await _refresh_session(p_session)
        if try_refresh != null:
            if try_refresh.is_exception():
                return NakamaAsyncResult.new(try_refresh.get_exception())
            await p_session.refresh(try_refresh)
        var urlpath: String = "/v2/account/unlink/facebookinstantgame"
        var query_params = ""
        var uri = "%s%s%s" % [_base_uri, urlpath, "?" + query_params if query_params else ""]
        var method = "POST"
        var headers = {}
        var header = "Bearer %s" % p_session.token
        headers["Authorization"] = header

        var content: PackedByteArray
        content = JSON.stringify(p_body.serialize()).to_utf8_buffer()

        var result = await _http_adapter.send_async(method, uri, headers, content)
        if result is NakamaException:
            return NakamaAsyncResult.new(result)
        return NakamaAsyncResult.new()


    func unlink_game_center_async(
        p_session: NakamaSession
        , p_body: ApiAccountGameCenter
    ) -> NakamaAsyncResult:
        var try_refresh = await _refresh_session(p_session)
        if try_refresh != null:
            if try_refresh.is_exception():
                return NakamaAsyncResult.new(try_refresh.get_exception())
            await p_session.refresh(try_refresh)
        var urlpath: String = "/v2/account/unlink/gamecenter"
        var query_params = ""
        var uri = "%s%s%s" % [_base_uri, urlpath, "?" + query_params if query_params else ""]
        var method = "POST"
        var headers = {}
        var header = "Bearer %s" % p_session.token
        headers["Authorization"] = header

        var content: PackedByteArray
        content = JSON.stringify(p_body.serialize()).to_utf8_buffer()

        var result = await _http_adapter.send_async(method, uri, headers, content)
        if result is NakamaException:
            return NakamaAsyncResult.new(result)
        return NakamaAsyncResult.new()


    func unlink_google_async(
        p_session: NakamaSession
        , p_body: ApiAccountGoogle
    ) -> NakamaAsyncResult:
        var try_refresh = await _refresh_session(p_session)
        if try_refresh != null:
            if try_refresh.is_exception():
                return NakamaAsyncResult.new(try_refresh.get_exception())
            await p_session.refresh(try_refresh)
        var urlpath: String = "/v2/account/unlink/google"
        var query_params = ""
        var uri = "%s%s%s" % [_base_uri, urlpath, "?" + query_params if query_params else ""]
        var method = "POST"
        var headers = {}
        var header = "Bearer %s" % p_session.token
        headers["Authorization"] = header

        var content: PackedByteArray
        content = JSON.stringify(p_body.serialize()).to_utf8_buffer()

        var result = await _http_adapter.send_async(method, uri, headers, content)
        if result is NakamaException:
            return NakamaAsyncResult.new(result)
        return NakamaAsyncResult.new()


    func unlink_steam_async(
        p_session: NakamaSession
        , p_body: ApiAccountSteam
    ) -> NakamaAsyncResult:
        var try_refresh = await _refresh_session(p_session)
        if try_refresh != null:
            if try_refresh.is_exception():
                return NakamaAsyncResult.new(try_refresh.get_exception())
            await p_session.refresh(try_refresh)
        var urlpath: String = "/v2/account/unlink/steam"
        var query_params = ""
        var uri = "%s%s%s" % [_base_uri, urlpath, "?" + query_params if query_params else ""]
        var method = "POST"
        var headers = {}
        var header = "Bearer %s" % p_session.token
        headers["Authorization"] = header

        var content: PackedByteArray
        content = JSON.stringify(p_body.serialize()).to_utf8_buffer()

        var result = await _http_adapter.send_async(method, uri, headers, content)
        if result is NakamaException:
            return NakamaAsyncResult.new(result)
        return NakamaAsyncResult.new()


    func list_channel_messages_async(
        p_session: NakamaSession
        , p_channel_id: String
        , p_limit = null
        , p_forward = null
        , p_cursor = null
    ) -> ApiChannelMessageList:
        var try_refresh = await _refresh_session(p_session)
        if try_refresh != null:
            if try_refresh.is_exception():
                return ApiChannelMessageList.new(try_refresh.get_exception())
            await p_session.refresh(try_refresh)
        var urlpath: String = "/v2/channel/{channelId}"
        urlpath = urlpath.replace("{channelId}", NakamaSerializer.escape_http(p_channel_id))
        var query_params = ""
        if p_limit != null:
            query_params += "limit=%d&" % p_limit
        if p_forward != null:
            query_params += "forward=%s&" % str(bool(p_forward)).to_lower()
        if p_cursor != null:
            query_params += "cursor=%s&" % NakamaSerializer.escape_http(p_cursor)
        var uri = "%s%s%s" % [_base_uri, urlpath, "?" + query_params if query_params else ""]
        var method = "GET"
        var headers = {}
        var header = "Bearer %s" % p_session.token
        headers["Authorization"] = header

        var content: PackedByteArray

        var result = await _http_adapter.send_async(method, uri, headers, content)
        if result is NakamaException:
            return ApiChannelMessageList.new(result)
        var out: ApiChannelMessageList = NakamaSerializer.deserialize(_namespace, "ApiChannelMessageList", result)
        return out


    func event_async(
        p_session: NakamaSession
        , p_body: ApiEvent
    ) -> NakamaAsyncResult:
        var try_refresh = await _refresh_session(p_session)
        if try_refresh != null:
            if try_refresh.is_exception():
                return NakamaAsyncResult.new(try_refresh.get_exception())
            await p_session.refresh(try_refresh)
        var urlpath: String = "/v2/event"
        var query_params = ""
        var uri = "%s%s%s" % [_base_uri, urlpath, "?" + query_params if query_params else ""]
        var method = "POST"
        var headers = {}
        var header = "Bearer %s" % p_session.token
        headers["Authorization"] = header

        var content: PackedByteArray
        content = JSON.stringify(p_body.serialize()).to_utf8_buffer()

        var result = await _http_adapter.send_async(method, uri, headers, content)
        if result is NakamaException:
            return NakamaAsyncResult.new(result)
        return NakamaAsyncResult.new()


    func delete_friends_async(
        p_session: NakamaSession
        , p_ids = null
        , p_usernames = null
    ) -> NakamaAsyncResult:
        var try_refresh = await _refresh_session(p_session)
        if try_refresh != null:
            if try_refresh.is_exception():
                return NakamaAsyncResult.new(try_refresh.get_exception())
            await p_session.refresh(try_refresh)
        var urlpath: String = "/v2/friend"
        var query_params = ""
        if p_ids != null:
            for elem in p_ids:
                query_params += "ids=%s&" % elem
        if p_usernames != null:
            for elem in p_usernames:
                query_params += "usernames=%s&" % elem
        var uri = "%s%s%s" % [_base_uri, urlpath, "?" + query_params if query_params else ""]
        var method = "DELETE"
        var headers = {}
        var header = "Bearer %s" % p_session.token
        headers["Authorization"] = header

        var content: PackedByteArray

        var result = await _http_adapter.send_async(method, uri, headers, content)
        if result is NakamaException:
            return NakamaAsyncResult.new(result)
        return NakamaAsyncResult.new()


    func list_friends_async(
        p_session: NakamaSession
        , p_limit = null
        , p_state = null
        , p_cursor = null
    ) -> ApiFriendList:
        var try_refresh = await _refresh_session(p_session)
        if try_refresh != null:
            if try_refresh.is_exception():
                return ApiFriendList.new(try_refresh.get_exception())
            await p_session.refresh(try_refresh)
        var urlpath: String = "/v2/friend"
        var query_params = ""
        if p_limit != null:
            query_params += "limit=%d&" % p_limit
        if p_state != null:
            query_params += "state=%d&" % p_state
        if p_cursor != null:
            query_params += "cursor=%s&" % NakamaSerializer.escape_http(p_cursor)
        var uri = "%s%s%s" % [_base_uri, urlpath, "?" + query_params if query_params else ""]
        var method = "GET"
        var headers = {}
        var header = "Bearer %s" % p_session.token
        headers["Authorization"] = header

        var content: PackedByteArray

        var result = await _http_adapter.send_async(method, uri, headers, content)
        if result is NakamaException:
            return ApiFriendList.new(result)
        var out: ApiFriendList = NakamaSerializer.deserialize(_namespace, "ApiFriendList", result)
        return out


    func add_friends_async(
        p_session: NakamaSession
        , p_ids = null
        , p_usernames = null
    ) -> NakamaAsyncResult:
        var try_refresh = await _refresh_session(p_session)
        if try_refresh != null:
            if try_refresh.is_exception():
                return NakamaAsyncResult.new(try_refresh.get_exception())
            await p_session.refresh(try_refresh)
        var urlpath: String = "/v2/friend"
        var query_params = ""
        if p_ids != null:
            for elem in p_ids:
                query_params += "ids=%s&" % elem
        if p_usernames != null:
            for elem in p_usernames:
                query_params += "usernames=%s&" % elem
        var uri = "%s%s%s" % [_base_uri, urlpath, "?" + query_params if query_params else ""]
        var method = "POST"
        var headers = {}
        var header = "Bearer %s" % p_session.token
        headers["Authorization"] = header

        var content: PackedByteArray

        var result = await _http_adapter.send_async(method, uri, headers, content)
        if result is NakamaException:
            return NakamaAsyncResult.new(result)
        return NakamaAsyncResult.new()


    func block_friends_async(
        p_session: NakamaSession
        , p_ids = null
        , p_usernames = null
    ) -> NakamaAsyncResult:
        var try_refresh = await _refresh_session(p_session)
        if try_refresh != null:
            if try_refresh.is_exception():
                return NakamaAsyncResult.new(try_refresh.get_exception())
            await p_session.refresh(try_refresh)
        var urlpath: String = "/v2/friend/block"
        var query_params = ""
        if p_ids != null:
            for elem in p_ids:
                query_params += "ids=%s&" % elem
        if p_usernames != null:
            for elem in p_usernames:
                query_params += "usernames=%s&" % elem
        var uri = "%s%s%s" % [_base_uri, urlpath, "?" + query_params if query_params else ""]
        var method = "POST"
        var headers = {}
        var header = "Bearer %s" % p_session.token
        headers["Authorization"] = header

        var content: PackedByteArray

        var result = await _http_adapter.send_async(method, uri, headers, content)
        if result is NakamaException:
            return NakamaAsyncResult.new(result)
        return NakamaAsyncResult.new()


    func import_facebook_friends_async(
        p_session: NakamaSession
        , p_account: ApiAccountFacebook
        , p_reset = null
    ) -> NakamaAsyncResult:
        var try_refresh = await _refresh_session(p_session)
        if try_refresh != null:
            if try_refresh.is_exception():
                return NakamaAsyncResult.new(try_refresh.get_exception())
            await p_session.refresh(try_refresh)
        var urlpath: String = "/v2/friend/facebook"
        var query_params = ""
        if p_reset != null:
            query_params += "reset=%s&" % str(bool(p_reset)).to_lower()
        var uri = "%s%s%s" % [_base_uri, urlpath, "?" + query_params if query_params else ""]
        var method = "POST"
        var headers = {}
        var header = "Bearer %s" % p_session.token
        headers["Authorization"] = header

        var content: PackedByteArray
        content = JSON.stringify(p_account.serialize()).to_utf8_buffer()

        var result = await _http_adapter.send_async(method, uri, headers, content)
        if result is NakamaException:
            return NakamaAsyncResult.new(result)
        return NakamaAsyncResult.new()


    func import_steam_friends_async(
        p_session: NakamaSession
        , p_account: ApiAccountSteam
        , p_reset = null
    ) -> NakamaAsyncResult:
        var try_refresh = await _refresh_session(p_session)
        if try_refresh != null:
            if try_refresh.is_exception():
                return NakamaAsyncResult.new(try_refresh.get_exception())
            await p_session.refresh(try_refresh)
        var urlpath: String = "/v2/friend/steam"
        var query_params = ""
        if p_reset != null:
            query_params += "reset=%s&" % str(bool(p_reset)).to_lower()
        var uri = "%s%s%s" % [_base_uri, urlpath, "?" + query_params if query_params else ""]
        var method = "POST"
        var headers = {}
        var header = "Bearer %s" % p_session.token
        headers["Authorization"] = header

        var content: PackedByteArray
        content = JSON.stringify(p_account.serialize()).to_utf8_buffer()

        var result = await _http_adapter.send_async(method, uri, headers, content)
        if result is NakamaException:
            return NakamaAsyncResult.new(result)
        return NakamaAsyncResult.new()


    func list_groups_async(
        p_session: NakamaSession
        , p_name = null
        , p_cursor = null
        , p_limit = null
        , p_lang_tag = null
        , p_members = null
        , p_open = null
    ) -> ApiGroupList:
        var try_refresh = await _refresh_session(p_session)
        if try_refresh != null:
            if try_refresh.is_exception():
                return ApiGroupList.new(try_refresh.get_exception())
            await p_session.refresh(try_refresh)
        var urlpath: String = "/v2/group"
        var query_params = ""
        if p_name != null:
            query_params += "name=%s&" % NakamaSerializer.escape_http(p_name)
        if p_cursor != null:
            query_params += "cursor=%s&" % NakamaSerializer.escape_http(p_cursor)
        if p_limit != null:
            query_params += "limit=%d&" % p_limit
        if p_lang_tag != null:
            query_params += "lang_tag=%s&" % NakamaSerializer.escape_http(p_lang_tag)
        if p_members != null:
            query_params += "members=%d&" % p_members
        if p_open != null:
            query_params += "open=%s&" % str(bool(p_open)).to_lower()
        var uri = "%s%s%s" % [_base_uri, urlpath, "?" + query_params if query_params else ""]
        var method = "GET"
        var headers = {}
        var header = "Bearer %s" % p_session.token
        headers["Authorization"] = header

        var content: PackedByteArray

        var result = await _http_adapter.send_async(method, uri, headers, content)
        if result is NakamaException:
            return ApiGroupList.new(result)
        var out: ApiGroupList = NakamaSerializer.deserialize(_namespace, "ApiGroupList", result)
        return out


    func create_group_async(
        p_session: NakamaSession
        , p_body: ApiCreateGroupRequest
    ) -> ApiGroup:
        var try_refresh = await _refresh_session(p_session)
        if try_refresh != null:
            if try_refresh.is_exception():
                return ApiGroup.new(try_refresh.get_exception())
            await p_session.refresh(try_refresh)
        var urlpath: String = "/v2/group"
        var query_params = ""
        var uri = "%s%s%s" % [_base_uri, urlpath, "?" + query_params if query_params else ""]
        var method = "POST"
        var headers = {}
        var header = "Bearer %s" % p_session.token
        headers["Authorization"] = header

        var content: PackedByteArray
        content = JSON.stringify(p_body.serialize()).to_utf8_buffer()

        var result = await _http_adapter.send_async(method, uri, headers, content)
        if result is NakamaException:
            return ApiGroup.new(result)
        var out: ApiGroup = NakamaSerializer.deserialize(_namespace, "ApiGroup", result)
        return out


    func delete_group_async(
        p_session: NakamaSession
        , p_group_id: String
    ) -> NakamaAsyncResult:
        var try_refresh = await _refresh_session(p_session)
        if try_refresh != null:
            if try_refresh.is_exception():
                return NakamaAsyncResult.new(try_refresh.get_exception())
            await p_session.refresh(try_refresh)
        var urlpath: String = "/v2/group/{groupId}"
        urlpath = urlpath.replace("{groupId}", NakamaSerializer.escape_http(p_group_id))
        var query_params = ""
        var uri = "%s%s%s" % [_base_uri, urlpath, "?" + query_params if query_params else ""]
        var method = "DELETE"
        var headers = {}
        var header = "Bearer %s" % p_session.token
        headers["Authorization"] = header

        var content: PackedByteArray

        var result = await _http_adapter.send_async(method, uri, headers, content)
        if result is NakamaException:
            return NakamaAsyncResult.new(result)
        return NakamaAsyncResult.new()


    func update_group_async(
        p_session: NakamaSession
        , p_group_id: String
        , p_body: ApiUpdateGroupRequest
    ) -> NakamaAsyncResult:
        var try_refresh = await _refresh_session(p_session)
        if try_refresh != null:
            if try_refresh.is_exception():
                return NakamaAsyncResult.new(try_refresh.get_exception())
            await p_session.refresh(try_refresh)
        var urlpath: String = "/v2/group/{groupId}"
        urlpath = urlpath.replace("{groupId}", NakamaSerializer.escape_http(p_group_id))
        var query_params = ""
        var uri = "%s%s%s" % [_base_uri, urlpath, "?" + query_params if query_params else ""]
        var method = "PUT"
        var headers = {}
        var header = "Bearer %s" % p_session.token
        headers["Authorization"] = header

        var content: PackedByteArray
        content = JSON.stringify(p_body.serialize()).to_utf8_buffer()

        var result = await _http_adapter.send_async(method, uri, headers, content)
        if result is NakamaException:
            return NakamaAsyncResult.new(result)
        return NakamaAsyncResult.new()


    func add_group_users_async(
        p_session: NakamaSession
        , p_group_id: String
        , p_user_ids = null
    ) -> NakamaAsyncResult:
        var try_refresh = await _refresh_session(p_session)
        if try_refresh != null:
            if try_refresh.is_exception():
                return NakamaAsyncResult.new(try_refresh.get_exception())
            await p_session.refresh(try_refresh)
        var urlpath: String = "/v2/group/{groupId}/add"
        urlpath = urlpath.replace("{groupId}", NakamaSerializer.escape_http(p_group_id))
        var query_params = ""
        if p_user_ids != null:
            for elem in p_user_ids:
                query_params += "user_ids=%s&" % elem
        var uri = "%s%s%s" % [_base_uri, urlpath, "?" + query_params if query_params else ""]
        var method = "POST"
        var headers = {}
        var header = "Bearer %s" % p_session.token
        headers["Authorization"] = header

        var content: PackedByteArray

        var result = await _http_adapter.send_async(method, uri, headers, content)
        if result is NakamaException:
            return NakamaAsyncResult.new(result)
        return NakamaAsyncResult.new()


    func ban_group_users_async(
        p_session: NakamaSession
        , p_group_id: String
        , p_user_ids = null
    ) -> NakamaAsyncResult:
        var try_refresh = await _refresh_session(p_session)
        if try_refresh != null:
            if try_refresh.is_exception():
                return NakamaAsyncResult.new(try_refresh.get_exception())
            await p_session.refresh(try_refresh)
        var urlpath: String = "/v2/group/{groupId}/ban"
        urlpath = urlpath.replace("{groupId}", NakamaSerializer.escape_http(p_group_id))
        var query_params = ""
        if p_user_ids != null:
            for elem in p_user_ids:
                query_params += "user_ids=%s&" % elem
        var uri = "%s%s%s" % [_base_uri, urlpath, "?" + query_params if query_params else ""]
        var method = "POST"
        var headers = {}
        var header = "Bearer %s" % p_session.token
        headers["Authorization"] = header

        var content: PackedByteArray

        var result = await _http_adapter.send_async(method, uri, headers, content)
        if result is NakamaException:
            return NakamaAsyncResult.new(result)
        return NakamaAsyncResult.new()


    func demote_group_users_async(
        p_session: NakamaSession
        , p_group_id: String
        , p_user_ids = null
    ) -> NakamaAsyncResult:
        var try_refresh = await _refresh_session(p_session)
        if try_refresh != null:
            if try_refresh.is_exception():
                return NakamaAsyncResult.new(try_refresh.get_exception())
            await p_session.refresh(try_refresh)
        var urlpath: String = "/v2/group/{groupId}/demote"
        urlpath = urlpath.replace("{groupId}", NakamaSerializer.escape_http(p_group_id))
        var query_params = ""
        if p_user_ids != null:
            for elem in p_user_ids:
                query_params += "user_ids=%s&" % elem
        var uri = "%s%s%s" % [_base_uri, urlpath, "?" + query_params if query_params else ""]
        var method = "POST"
        var headers = {}
        var header = "Bearer %s" % p_session.token
        headers["Authorization"] = header

        var content: PackedByteArray

        var result = await _http_adapter.send_async(method, uri, headers, content)
        if result is NakamaException:
            return NakamaAsyncResult.new(result)
        return NakamaAsyncResult.new()


    func join_group_async(
        p_session: NakamaSession
        , p_group_id: String
    ) -> NakamaAsyncResult:
        var try_refresh = await _refresh_session(p_session)
        if try_refresh != null:
            if try_refresh.is_exception():
                return NakamaAsyncResult.new(try_refresh.get_exception())
            await p_session.refresh(try_refresh)
        var urlpath: String = "/v2/group/{groupId}/join"
        urlpath = urlpath.replace("{groupId}", NakamaSerializer.escape_http(p_group_id))
        var query_params = ""
        var uri = "%s%s%s" % [_base_uri, urlpath, "?" + query_params if query_params else ""]
        var method = "POST"
        var headers = {}
        var header = "Bearer %s" % p_session.token
        headers["Authorization"] = header

        var content: PackedByteArray

        var result = await _http_adapter.send_async(method, uri, headers, content)
        if result is NakamaException:
            return NakamaAsyncResult.new(result)
        return NakamaAsyncResult.new()


    func kick_group_users_async(
        p_session: NakamaSession
        , p_group_id: String
        , p_user_ids = null
    ) -> NakamaAsyncResult:
        var try_refresh = await _refresh_session(p_session)
        if try_refresh != null:
            if try_refresh.is_exception():
                return NakamaAsyncResult.new(try_refresh.get_exception())
            await p_session.refresh(try_refresh)
        var urlpath: String = "/v2/group/{groupId}/kick"
        urlpath = urlpath.replace("{groupId}", NakamaSerializer.escape_http(p_group_id))
        var query_params = ""
        if p_user_ids != null:
            for elem in p_user_ids:
                query_params += "user_ids=%s&" % elem
        var uri = "%s%s%s" % [_base_uri, urlpath, "?" + query_params if query_params else ""]
        var method = "POST"
        var headers = {}
        var header = "Bearer %s" % p_session.token
        headers["Authorization"] = header

        var content: PackedByteArray

        var result = await _http_adapter.send_async(method, uri, headers, content)
        if result is NakamaException:
            return NakamaAsyncResult.new(result)
        return NakamaAsyncResult.new()


    func leave_group_async(
        p_session: NakamaSession
        , p_group_id: String
    ) -> NakamaAsyncResult:
        var try_refresh = await _refresh_session(p_session)
        if try_refresh != null:
            if try_refresh.is_exception():
                return NakamaAsyncResult.new(try_refresh.get_exception())
            await p_session.refresh(try_refresh)
        var urlpath: String = "/v2/group/{groupId}/leave"
        urlpath = urlpath.replace("{groupId}", NakamaSerializer.escape_http(p_group_id))
        var query_params = ""
        var uri = "%s%s%s" % [_base_uri, urlpath, "?" + query_params if query_params else ""]
        var method = "POST"
        var headers = {}
        var header = "Bearer %s" % p_session.token
        headers["Authorization"] = header

        var content: PackedByteArray

        var result = await _http_adapter.send_async(method, uri, headers, content)
        if result is NakamaException:
            return NakamaAsyncResult.new(result)
        return NakamaAsyncResult.new()


    func promote_group_users_async(
        p_session: NakamaSession
        , p_group_id: String
        , p_user_ids = null
    ) -> NakamaAsyncResult:
        var try_refresh = await _refresh_session(p_session)
        if try_refresh != null:
            if try_refresh.is_exception():
                return NakamaAsyncResult.new(try_refresh.get_exception())
            await p_session.refresh(try_refresh)
        var urlpath: String = "/v2/group/{groupId}/promote"
        urlpath = urlpath.replace("{groupId}", NakamaSerializer.escape_http(p_group_id))
        var query_params = ""
        if p_user_ids != null:
            for elem in p_user_ids:
                query_params += "user_ids=%s&" % elem
        var uri = "%s%s%s" % [_base_uri, urlpath, "?" + query_params if query_params else ""]
        var method = "POST"
        var headers = {}
        var header = "Bearer %s" % p_session.token
        headers["Authorization"] = header

        var content: PackedByteArray

        var result = await _http_adapter.send_async(method, uri, headers, content)
        if result is NakamaException:
            return NakamaAsyncResult.new(result)
        return NakamaAsyncResult.new()


    func list_group_users_async(
        p_session: NakamaSession
        , p_group_id: String
        , p_limit = null
        , p_state = null
        , p_cursor = null
    ) -> ApiGroupUserList:
        var try_refresh = await _refresh_session(p_session)
        if try_refresh != null:
            if try_refresh.is_exception():
                return ApiGroupUserList.new(try_refresh.get_exception())
            await p_session.refresh(try_refresh)
        var urlpath: String = "/v2/group/{groupId}/user"
        urlpath = urlpath.replace("{groupId}", NakamaSerializer.escape_http(p_group_id))
        var query_params = ""
        if p_limit != null:
            query_params += "limit=%d&" % p_limit
        if p_state != null:
            query_params += "state=%d&" % p_state
        if p_cursor != null:
            query_params += "cursor=%s&" % NakamaSerializer.escape_http(p_cursor)
        var uri = "%s%s%s" % [_base_uri, urlpath, "?" + query_params if query_params else ""]
        var method = "GET"
        var headers = {}
        var header = "Bearer %s" % p_session.token
        headers["Authorization"] = header

        var content: PackedByteArray

        var result = await _http_adapter.send_async(method, uri, headers, content)
        if result is NakamaException:
            return ApiGroupUserList.new(result)
        var out: ApiGroupUserList = NakamaSerializer.deserialize(_namespace, "ApiGroupUserList", result)
        return out


    func validate_purchase_apple_async(
        p_session: NakamaSession
        , p_body: ApiValidatePurchaseAppleRequest
    ) -> ApiValidatePurchaseResponse:
        var try_refresh = await _refresh_session(p_session)
        if try_refresh != null:
            if try_refresh.is_exception():
                return ApiValidatePurchaseResponse.new(try_refresh.get_exception())
            await p_session.refresh(try_refresh)
        var urlpath: String = "/v2/iap/purchase/apple"
        var query_params = ""
        var uri = "%s%s%s" % [_base_uri, urlpath, "?" + query_params if query_params else ""]
        var method = "POST"
        var headers = {}
        var header = "Bearer %s" % p_session.token
        headers["Authorization"] = header

        var content: PackedByteArray
        content = JSON.stringify(p_body.serialize()).to_utf8_buffer()

        var result = await _http_adapter.send_async(method, uri, headers, content)
        if result is NakamaException:
            return ApiValidatePurchaseResponse.new(result)
        var out: ApiValidatePurchaseResponse = NakamaSerializer.deserialize(_namespace, "ApiValidatePurchaseResponse", result)
        return out


    func validate_purchase_google_async(
        p_session: NakamaSession
        , p_body: ApiValidatePurchaseGoogleRequest
    ) -> ApiValidatePurchaseResponse:
        var try_refresh = await _refresh_session(p_session)
        if try_refresh != null:
            if try_refresh.is_exception():
                return ApiValidatePurchaseResponse.new(try_refresh.get_exception())
            await p_session.refresh(try_refresh)
        var urlpath: String = "/v2/iap/purchase/google"
        var query_params = ""
        var uri = "%s%s%s" % [_base_uri, urlpath, "?" + query_params if query_params else ""]
        var method = "POST"
        var headers = {}
        var header = "Bearer %s" % p_session.token
        headers["Authorization"] = header

        var content: PackedByteArray
        content = JSON.stringify(p_body.serialize()).to_utf8_buffer()

        var result = await _http_adapter.send_async(method, uri, headers, content)
        if result is NakamaException:
            return ApiValidatePurchaseResponse.new(result)
        var out: ApiValidatePurchaseResponse = NakamaSerializer.deserialize(_namespace, "ApiValidatePurchaseResponse", result)
        return out


    func validate_purchase_huawei_async(
        p_session: NakamaSession
        , p_body: ApiValidatePurchaseHuaweiRequest
    ) -> ApiValidatePurchaseResponse:
        var try_refresh = await _refresh_session(p_session)
        if try_refresh != null:
            if try_refresh.is_exception():
                return ApiValidatePurchaseResponse.new(try_refresh.get_exception())
            await p_session.refresh(try_refresh)
        var urlpath: String = "/v2/iap/purchase/huawei"
        var query_params = ""
        var uri = "%s%s%s" % [_base_uri, urlpath, "?" + query_params if query_params else ""]
        var method = "POST"
        var headers = {}
        var header = "Bearer %s" % p_session.token
        headers["Authorization"] = header

        var content: PackedByteArray
        content = JSON.stringify(p_body.serialize()).to_utf8_buffer()

        var result = await _http_adapter.send_async(method, uri, headers, content)
        if result is NakamaException:
            return ApiValidatePurchaseResponse.new(result)
        var out: ApiValidatePurchaseResponse = NakamaSerializer.deserialize(_namespace, "ApiValidatePurchaseResponse", result)
        return out


    func list_subscriptions_async(
        p_session: NakamaSession
        , p_body: ApiListSubscriptionsRequest
    ) -> ApiSubscriptionList:
        var try_refresh = await _refresh_session(p_session)
        if try_refresh != null:
            if try_refresh.is_exception():
                return ApiSubscriptionList.new(try_refresh.get_exception())
            await p_session.refresh(try_refresh)
        var urlpath: String = "/v2/iap/subscription"
        var query_params = ""
        var uri = "%s%s%s" % [_base_uri, urlpath, "?" + query_params if query_params else ""]
        var method = "POST"
        var headers = {}
        var header = "Bearer %s" % p_session.token
        headers["Authorization"] = header

        var content: PackedByteArray
        content = JSON.stringify(p_body.serialize()).to_utf8_buffer()

        var result = await _http_adapter.send_async(method, uri, headers, content)
        if result is NakamaException:
            return ApiSubscriptionList.new(result)
        var out: ApiSubscriptionList = NakamaSerializer.deserialize(_namespace, "ApiSubscriptionList", result)
        return out


    func validate_subscription_apple_async(
        p_session: NakamaSession
        , p_body: ApiValidateSubscriptionAppleRequest
    ) -> ApiValidateSubscriptionResponse:
        var try_refresh = await _refresh_session(p_session)
        if try_refresh != null:
            if try_refresh.is_exception():
                return ApiValidateSubscriptionResponse.new(try_refresh.get_exception())
            await p_session.refresh(try_refresh)
        var urlpath: String = "/v2/iap/subscription/apple"
        var query_params = ""
        var uri = "%s%s%s" % [_base_uri, urlpath, "?" + query_params if query_params else ""]
        var method = "POST"
        var headers = {}
        var header = "Bearer %s" % p_session.token
        headers["Authorization"] = header

        var content: PackedByteArray
        content = JSON.stringify(p_body.serialize()).to_utf8_buffer()

        var result = await _http_adapter.send_async(method, uri, headers, content)
        if result is NakamaException:
            return ApiValidateSubscriptionResponse.new(result)
        var out: ApiValidateSubscriptionResponse = NakamaSerializer.deserialize(_namespace, "ApiValidateSubscriptionResponse", result)
        return out


    func validate_subscription_google_async(
        p_session: NakamaSession
        , p_body: ApiValidateSubscriptionGoogleRequest
    ) -> ApiValidateSubscriptionResponse:
        var try_refresh = await _refresh_session(p_session)
        if try_refresh != null:
            if try_refresh.is_exception():
                return ApiValidateSubscriptionResponse.new(try_refresh.get_exception())
            await p_session.refresh(try_refresh)
        var urlpath: String = "/v2/iap/subscription/google"
        var query_params = ""
        var uri = "%s%s%s" % [_base_uri, urlpath, "?" + query_params if query_params else ""]
        var method = "POST"
        var headers = {}
        var header = "Bearer %s" % p_session.token
        headers["Authorization"] = header

        var content: PackedByteArray
        content = JSON.stringify(p_body.serialize()).to_utf8_buffer()

        var result = await _http_adapter.send_async(method, uri, headers, content)
        if result is NakamaException:
            return ApiValidateSubscriptionResponse.new(result)
        var out: ApiValidateSubscriptionResponse = NakamaSerializer.deserialize(_namespace, "ApiValidateSubscriptionResponse", result)
        return out


    func get_subscription_async(
        p_session: NakamaSession
        , p_product_id: String
    ) -> ApiValidatedSubscription:
        var try_refresh = await _refresh_session(p_session)
        if try_refresh != null:
            if try_refresh.is_exception():
                return ApiValidatedSubscription.new(try_refresh.get_exception())
            await p_session.refresh(try_refresh)
        var urlpath: String = "/v2/iap/subscription/{productId}"
        urlpath = urlpath.replace("{productId}", NakamaSerializer.escape_http(p_product_id))
        var query_params = ""
        var uri = "%s%s%s" % [_base_uri, urlpath, "?" + query_params if query_params else ""]
        var method = "GET"
        var headers = {}
        var header = "Bearer %s" % p_session.token
        headers["Authorization"] = header

        var content: PackedByteArray

        var result = await _http_adapter.send_async(method, uri, headers, content)
        if result is NakamaException:
            return ApiValidatedSubscription.new(result)
        var out: ApiValidatedSubscription = NakamaSerializer.deserialize(_namespace, "ApiValidatedSubscription", result)
        return out


    func delete_leaderboard_record_async(
        p_session: NakamaSession
        , p_leaderboard_id: String
    ) -> NakamaAsyncResult:
        var try_refresh = await _refresh_session(p_session)
        if try_refresh != null:
            if try_refresh.is_exception():
                return NakamaAsyncResult.new(try_refresh.get_exception())
            await p_session.refresh(try_refresh)
        var urlpath: String = "/v2/leaderboard/{leaderboardId}"
        urlpath = urlpath.replace("{leaderboardId}", NakamaSerializer.escape_http(p_leaderboard_id))
        var query_params = ""
        var uri = "%s%s%s" % [_base_uri, urlpath, "?" + query_params if query_params else ""]
        var method = "DELETE"
        var headers = {}
        var header = "Bearer %s" % p_session.token
        headers["Authorization"] = header

        var content: PackedByteArray

        var result = await _http_adapter.send_async(method, uri, headers, content)
        if result is NakamaException:
            return NakamaAsyncResult.new(result)
        return NakamaAsyncResult.new()


    func list_leaderboard_records_async(
        p_session: NakamaSession
        , p_leaderboard_id: String
        , p_owner_ids = null
        , p_limit = null
        , p_cursor = null
        , p_expiry = null
    ) -> ApiLeaderboardRecordList:
        var try_refresh = await _refresh_session(p_session)
        if try_refresh != null:
            if try_refresh.is_exception():
                return ApiLeaderboardRecordList.new(try_refresh.get_exception())
            await p_session.refresh(try_refresh)
        var urlpath: String = "/v2/leaderboard/{leaderboardId}"
        urlpath = urlpath.replace("{leaderboardId}", NakamaSerializer.escape_http(p_leaderboard_id))
        var query_params = ""
        if p_owner_ids != null:
            for elem in p_owner_ids:
                query_params += "owner_ids=%s&" % elem
        if p_limit != null:
            query_params += "limit=%d&" % p_limit
        if p_cursor != null:
            query_params += "cursor=%s&" % NakamaSerializer.escape_http(p_cursor)
        if p_expiry != null:
            query_params += "expiry=%s&" % NakamaSerializer.escape_http(p_expiry)
        var uri = "%s%s%s" % [_base_uri, urlpath, "?" + query_params if query_params else ""]
        var method = "GET"
        var headers = {}
        var header = "Bearer %s" % p_session.token
        headers["Authorization"] = header

        var content: PackedByteArray

        var result = await _http_adapter.send_async(method, uri, headers, content)
        if result is NakamaException:
            return ApiLeaderboardRecordList.new(result)
        var out: ApiLeaderboardRecordList = NakamaSerializer.deserialize(_namespace, "ApiLeaderboardRecordList", result)
        return out


    func write_leaderboard_record_async(
        p_session: NakamaSession
        , p_leaderboard_id: String
        , p_record: WriteLeaderboardRecordRequestLeaderboardRecordWrite
    ) -> ApiLeaderboardRecord:
        var try_refresh = await _refresh_session(p_session)
        if try_refresh != null:
            if try_refresh.is_exception():
                return ApiLeaderboardRecord.new(try_refresh.get_exception())
            await p_session.refresh(try_refresh)
        var urlpath: String = "/v2/leaderboard/{leaderboardId}"
        urlpath = urlpath.replace("{leaderboardId}", NakamaSerializer.escape_http(p_leaderboard_id))
        var query_params = ""
        var uri = "%s%s%s" % [_base_uri, urlpath, "?" + query_params if query_params else ""]
        var method = "POST"
        var headers = {}
        var header = "Bearer %s" % p_session.token
        headers["Authorization"] = header

        var content: PackedByteArray
        content = JSON.stringify(p_record.serialize()).to_utf8_buffer()

        var result = await _http_adapter.send_async(method, uri, headers, content)
        if result is NakamaException:
            return ApiLeaderboardRecord.new(result)
        var out: ApiLeaderboardRecord = NakamaSerializer.deserialize(_namespace, "ApiLeaderboardRecord", result)
        return out


    func list_leaderboard_records_around_owner_async(
        p_session: NakamaSession
        , p_leaderboard_id: String
        , p_owner_id: String
        , p_limit = null
        , p_expiry = null
        , p_cursor = null
    ) -> ApiLeaderboardRecordList:
        var try_refresh = await _refresh_session(p_session)
        if try_refresh != null:
            if try_refresh.is_exception():
                return ApiLeaderboardRecordList.new(try_refresh.get_exception())
            await p_session.refresh(try_refresh)
        var urlpath: String = "/v2/leaderboard/{leaderboardId}/owner/{ownerId}"
        urlpath = urlpath.replace("{leaderboardId}", NakamaSerializer.escape_http(p_leaderboard_id))
        urlpath = urlpath.replace("{ownerId}", NakamaSerializer.escape_http(p_owner_id))
        var query_params = ""
        if p_limit != null:
            query_params += "limit=%d&" % p_limit
        if p_expiry != null:
            query_params += "expiry=%s&" % NakamaSerializer.escape_http(p_expiry)
        if p_cursor != null:
            query_params += "cursor=%s&" % NakamaSerializer.escape_http(p_cursor)
        var uri = "%s%s%s" % [_base_uri, urlpath, "?" + query_params if query_params else ""]
        var method = "GET"
        var headers = {}
        var header = "Bearer %s" % p_session.token
        headers["Authorization"] = header

        var content: PackedByteArray

        var result = await _http_adapter.send_async(method, uri, headers, content)
        if result is NakamaException:
            return ApiLeaderboardRecordList.new(result)
        var out: ApiLeaderboardRecordList = NakamaSerializer.deserialize(_namespace, "ApiLeaderboardRecordList", result)
        return out


    func list_matches_async(
        p_session: NakamaSession
        , p_limit = null
        , p_authoritative = null
        , p_label = null
        , p_min_size = null
        , p_max_size = null
        , p_query = null
    ) -> ApiMatchList:
        var try_refresh = await _refresh_session(p_session)
        if try_refresh != null:
            if try_refresh.is_exception():
                return ApiMatchList.new(try_refresh.get_exception())
            await p_session.refresh(try_refresh)
        var urlpath: String = "/v2/match"
        var query_params = ""
        if p_limit != null:
            query_params += "limit=%d&" % p_limit
        if p_authoritative != null:
            query_params += "authoritative=%s&" % str(bool(p_authoritative)).to_lower()
        if p_label != null:
            query_params += "label=%s&" % NakamaSerializer.escape_http(p_label)
        if p_min_size != null:
            query_params += "min_size=%d&" % p_min_size
        if p_max_size != null:
            query_params += "max_size=%d&" % p_max_size
        if p_query != null:
            query_params += "query=%s&" % NakamaSerializer.escape_http(p_query)
        var uri = "%s%s%s" % [_base_uri, urlpath, "?" + query_params if query_params else ""]
        var method = "GET"
        var headers = {}
        var header = "Bearer %s" % p_session.token
        headers["Authorization"] = header

        var content: PackedByteArray

        var result = await _http_adapter.send_async(method, uri, headers, content)
        if result is NakamaException:
            return ApiMatchList.new(result)
        var out: ApiMatchList = NakamaSerializer.deserialize(_namespace, "ApiMatchList", result)
        return out


    func delete_notifications_async(
        p_session: NakamaSession
        , p_ids = null
    ) -> NakamaAsyncResult:
        var try_refresh = await _refresh_session(p_session)
        if try_refresh != null:
            if try_refresh.is_exception():
                return NakamaAsyncResult.new(try_refresh.get_exception())
            await p_session.refresh(try_refresh)
        var urlpath: String = "/v2/notification"
        var query_params = ""
        if p_ids != null:
            for elem in p_ids:
                query_params += "ids=%s&" % elem
        var uri = "%s%s%s" % [_base_uri, urlpath, "?" + query_params if query_params else ""]
        var method = "DELETE"
        var headers = {}
        var header = "Bearer %s" % p_session.token
        headers["Authorization"] = header

        var content: PackedByteArray

        var result = await _http_adapter.send_async(method, uri, headers, content)
        if result is NakamaException:
            return NakamaAsyncResult.new(result)
        return NakamaAsyncResult.new()


    func list_notifications_async(
        p_session: NakamaSession
        , p_limit = null
        , p_cacheable_cursor = null
    ) -> ApiNotificationList:
        var try_refresh = await _refresh_session(p_session)
        if try_refresh != null:
            if try_refresh.is_exception():
                return ApiNotificationList.new(try_refresh.get_exception())
            await p_session.refresh(try_refresh)
        var urlpath: String = "/v2/notification"
        var query_params = ""
        if p_limit != null:
            query_params += "limit=%d&" % p_limit
        if p_cacheable_cursor != null:
            query_params += "cacheable_cursor=%s&" % NakamaSerializer.escape_http(p_cacheable_cursor)
        var uri = "%s%s%s" % [_base_uri, urlpath, "?" + query_params if query_params else ""]
        var method = "GET"
        var headers = {}
        var header = "Bearer %s" % p_session.token
        headers["Authorization"] = header

        var content: PackedByteArray

        var result = await _http_adapter.send_async(method, uri, headers, content)
        if result is NakamaException:
            return ApiNotificationList.new(result)
        var out: ApiNotificationList = NakamaSerializer.deserialize(_namespace, "ApiNotificationList", result)
        return out


    func rpc_func2_async(
        p_bearer_token: String
        , p_id: String
        , p_payload = null
        , p_http_key = null
    ) -> ApiRpc:
        var urlpath: String = "/v2/rpc/{id}"
        urlpath = urlpath.replace("{id}", NakamaSerializer.escape_http(p_id))
        var query_params = ""
        if p_payload != null:
            query_params += "payload=%s&" % NakamaSerializer.escape_http(p_payload)
        if p_http_key != null:
            query_params += "http_key=%s&" % NakamaSerializer.escape_http(p_http_key)
        var uri = "%s%s%s" % [_base_uri, urlpath, "?" + query_params if query_params else ""]
        var method = "GET"
        var headers = {}
        if (p_bearer_token):
            var header = "Bearer %s" % p_bearer_token
            headers["Authorization"] = header

        var content: PackedByteArray

        var result = await _http_adapter.send_async(method, uri, headers, content)
        if result is NakamaException:
            return ApiRpc.new(result)
        var out: ApiRpc = NakamaSerializer.deserialize(_namespace, "ApiRpc", result)
        return out


    func rpc_func_async(
        p_bearer_token: String
        , p_id: String
        , p_payload: String
        , p_http_key = null
    ) -> ApiRpc:
        var urlpath: String = "/v2/rpc/{id}"
        urlpath = urlpath.replace("{id}", NakamaSerializer.escape_http(p_id))
        var query_params = ""
        if p_http_key != null:
            query_params += "http_key=%s&" % NakamaSerializer.escape_http(p_http_key)
        var uri = "%s%s%s" % [_base_uri, urlpath, "?" + query_params if query_params else ""]
        var method = "POST"
        var headers = {}
        if (p_bearer_token):
            var header = "Bearer %s" % p_bearer_token
            headers["Authorization"] = header

        var content: PackedByteArray
        content = JSON.stringify(p_payload).to_utf8_buffer()

        var result = await _http_adapter.send_async(method, uri, headers, content)
        if result is NakamaException:
            return ApiRpc.new(result)
        var out: ApiRpc = NakamaSerializer.deserialize(_namespace, "ApiRpc", result)
        return out


    func session_logout_async(
        p_session: NakamaSession
        , p_body: ApiSessionLogoutRequest
    ) -> NakamaAsyncResult:
        var try_refresh = await _refresh_session(p_session)
        if try_refresh != null:
            if try_refresh.is_exception():
                return NakamaAsyncResult.new(try_refresh.get_exception())
            await p_session.refresh(try_refresh)
        var urlpath: String = "/v2/session/logout"
        var query_params = ""
        var uri = "%s%s%s" % [_base_uri, urlpath, "?" + query_params if query_params else ""]
        var method = "POST"
        var headers = {}
        var header = "Bearer %s" % p_session.token
        headers["Authorization"] = header

        var content: PackedByteArray
        content = JSON.stringify(p_body.serialize()).to_utf8_buffer()

        var result = await _http_adapter.send_async(method, uri, headers, content)
        if result is NakamaException:
            return NakamaAsyncResult.new(result)
        return NakamaAsyncResult.new()


    func read_storage_objects_async(
        p_session: NakamaSession
        , p_body: ApiReadStorageObjectsRequest
    ) -> ApiStorageObjects:
        var try_refresh = await _refresh_session(p_session)
        if try_refresh != null:
            if try_refresh.is_exception():
                return ApiStorageObjects.new(try_refresh.get_exception())
            await p_session.refresh(try_refresh)
        var urlpath: String = "/v2/storage"
        var query_params = ""
        var uri = "%s%s%s" % [_base_uri, urlpath, "?" + query_params if query_params else ""]
        var method = "POST"
        var headers = {}
        var header = "Bearer %s" % p_session.token
        headers["Authorization"] = header

        var content: PackedByteArray
        content = JSON.stringify(p_body.serialize()).to_utf8_buffer()

        var result = await _http_adapter.send_async(method, uri, headers, content)
        if result is NakamaException:
            return ApiStorageObjects.new(result)
        var out: ApiStorageObjects = NakamaSerializer.deserialize(_namespace, "ApiStorageObjects", result)
        return out


    func write_storage_objects_async(
        p_session: NakamaSession
        , p_body: ApiWriteStorageObjectsRequest
    ) -> ApiStorageObjectAcks:
        var try_refresh = await _refresh_session(p_session)
        if try_refresh != null:
            if try_refresh.is_exception():
                return ApiStorageObjectAcks.new(try_refresh.get_exception())
            await p_session.refresh(try_refresh)
        var urlpath: String = "/v2/storage"
        var query_params = ""
        var uri = "%s%s%s" % [_base_uri, urlpath, "?" + query_params if query_params else ""]
        var method = "PUT"
        var headers = {}
        var header = "Bearer %s" % p_session.token
        headers["Authorization"] = header

        var content: PackedByteArray
        content = JSON.stringify(p_body.serialize()).to_utf8_buffer()

        var result = await _http_adapter.send_async(method, uri, headers, content)
        if result is NakamaException:
            return ApiStorageObjectAcks.new(result)
        var out: ApiStorageObjectAcks = NakamaSerializer.deserialize(_namespace, "ApiStorageObjectAcks", result)
        return out


    func delete_storage_objects_async(
        p_session: NakamaSession
        , p_body: ApiDeleteStorageObjectsRequest
    ) -> NakamaAsyncResult:
        var try_refresh = await _refresh_session(p_session)
        if try_refresh != null:
            if try_refresh.is_exception():
                return NakamaAsyncResult.new(try_refresh.get_exception())
            await p_session.refresh(try_refresh)
        var urlpath: String = "/v2/storage/delete"
        var query_params = ""
        var uri = "%s%s%s" % [_base_uri, urlpath, "?" + query_params if query_params else ""]
        var method = "PUT"
        var headers = {}
        var header = "Bearer %s" % p_session.token
        headers["Authorization"] = header

        var content: PackedByteArray
        content = JSON.stringify(p_body.serialize()).to_utf8_buffer()

        var result = await _http_adapter.send_async(method, uri, headers, content)
        if result is NakamaException:
            return NakamaAsyncResult.new(result)
        return NakamaAsyncResult.new()


    func list_storage_objects_async(
        p_session: NakamaSession
        , p_collection: String
        , p_user_id = null
        , p_limit = null
        , p_cursor = null
    ) -> ApiStorageObjectList:
        var try_refresh = await _refresh_session(p_session)
        if try_refresh != null:
            if try_refresh.is_exception():
                return ApiStorageObjectList.new(try_refresh.get_exception())
            await p_session.refresh(try_refresh)
        var urlpath: String = "/v2/storage/{collection}"
        urlpath = urlpath.replace("{collection}", NakamaSerializer.escape_http(p_collection))
        var query_params = ""
        if p_user_id != null:
            query_params += "user_id=%s&" % NakamaSerializer.escape_http(p_user_id)
        if p_limit != null:
            query_params += "limit=%d&" % p_limit
        if p_cursor != null:
            query_params += "cursor=%s&" % NakamaSerializer.escape_http(p_cursor)
        var uri = "%s%s%s" % [_base_uri, urlpath, "?" + query_params if query_params else ""]
        var method = "GET"
        var headers = {}
        var header = "Bearer %s" % p_session.token
        headers["Authorization"] = header

        var content: PackedByteArray

        var result = await _http_adapter.send_async(method, uri, headers, content)
        if result is NakamaException:
            return ApiStorageObjectList.new(result)
        var out: ApiStorageObjectList = NakamaSerializer.deserialize(_namespace, "ApiStorageObjectList", result)
        return out


    func list_storage_objects2_async(
        p_session: NakamaSession
        , p_collection: String
        , p_user_id: String
        , p_limit = null
        , p_cursor = null
    ) -> ApiStorageObjectList:
        var try_refresh = await _refresh_session(p_session)
        if try_refresh != null:
            if try_refresh.is_exception():
                return ApiStorageObjectList.new(try_refresh.get_exception())
            await p_session.refresh(try_refresh)
        var urlpath: String = "/v2/storage/{collection}/{userId}"
        urlpath = urlpath.replace("{collection}", NakamaSerializer.escape_http(p_collection))
        urlpath = urlpath.replace("{userId}", NakamaSerializer.escape_http(p_user_id))
        var query_params = ""
        if p_limit != null:
            query_params += "limit=%d&" % p_limit
        if p_cursor != null:
            query_params += "cursor=%s&" % NakamaSerializer.escape_http(p_cursor)
        var uri = "%s%s%s" % [_base_uri, urlpath, "?" + query_params if query_params else ""]
        var method = "GET"
        var headers = {}
        var header = "Bearer %s" % p_session.token
        headers["Authorization"] = header

        var content: PackedByteArray

        var result = await _http_adapter.send_async(method, uri, headers, content)
        if result is NakamaException:
            return ApiStorageObjectList.new(result)
        var out: ApiStorageObjectList = NakamaSerializer.deserialize(_namespace, "ApiStorageObjectList", result)
        return out


    func list_tournaments_async(
        p_session: NakamaSession
        , p_category_start = null
        , p_category_end = null
        , p_start_time = null
        , p_end_time = null
        , p_limit = null
        , p_cursor = null
    ) -> ApiTournamentList:
        var try_refresh = await _refresh_session(p_session)
        if try_refresh != null:
            if try_refresh.is_exception():
                return ApiTournamentList.new(try_refresh.get_exception())
            await p_session.refresh(try_refresh)
        var urlpath: String = "/v2/tournament"
        var query_params = ""
        if p_category_start != null:
            query_params += "category_start=%d&" % p_category_start
        if p_category_end != null:
            query_params += "category_end=%d&" % p_category_end
        if p_start_time != null:
            query_params += "start_time=%d&" % p_start_time
        if p_end_time != null:
            query_params += "end_time=%d&" % p_end_time
        if p_limit != null:
            query_params += "limit=%d&" % p_limit
        if p_cursor != null:
            query_params += "cursor=%s&" % NakamaSerializer.escape_http(p_cursor)
        var uri = "%s%s%s" % [_base_uri, urlpath, "?" + query_params if query_params else ""]
        var method = "GET"
        var headers = {}
        var header = "Bearer %s" % p_session.token
        headers["Authorization"] = header

        var content: PackedByteArray

        var result = await _http_adapter.send_async(method, uri, headers, content)
        if result is NakamaException:
            return ApiTournamentList.new(result)
        var out: ApiTournamentList = NakamaSerializer.deserialize(_namespace, "ApiTournamentList", result)
        return out


    func list_tournament_records_async(
        p_session: NakamaSession
        , p_tournament_id: String
        , p_owner_ids = null
        , p_limit = null
        , p_cursor = null
        , p_expiry = null
    ) -> ApiTournamentRecordList:
        var try_refresh = await _refresh_session(p_session)
        if try_refresh != null:
            if try_refresh.is_exception():
                return ApiTournamentRecordList.new(try_refresh.get_exception())
            await p_session.refresh(try_refresh)
        var urlpath: String = "/v2/tournament/{tournamentId}"
        urlpath = urlpath.replace("{tournamentId}", NakamaSerializer.escape_http(p_tournament_id))
        var query_params = ""
        if p_owner_ids != null:
            for elem in p_owner_ids:
                query_params += "owner_ids=%s&" % elem
        if p_limit != null:
            query_params += "limit=%d&" % p_limit
        if p_cursor != null:
            query_params += "cursor=%s&" % NakamaSerializer.escape_http(p_cursor)
        if p_expiry != null:
            query_params += "expiry=%s&" % NakamaSerializer.escape_http(p_expiry)
        var uri = "%s%s%s" % [_base_uri, urlpath, "?" + query_params if query_params else ""]
        var method = "GET"
        var headers = {}
        var header = "Bearer %s" % p_session.token
        headers["Authorization"] = header

        var content: PackedByteArray

        var result = await _http_adapter.send_async(method, uri, headers, content)
        if result is NakamaException:
            return ApiTournamentRecordList.new(result)
        var out: ApiTournamentRecordList = NakamaSerializer.deserialize(_namespace, "ApiTournamentRecordList", result)
        return out


    func write_tournament_record2_async(
        p_session: NakamaSession
        , p_tournament_id: String
        , p_record: WriteTournamentRecordRequestTournamentRecordWrite
    ) -> ApiLeaderboardRecord:
        var try_refresh = await _refresh_session(p_session)
        if try_refresh != null:
            if try_refresh.is_exception():
                return ApiLeaderboardRecord.new(try_refresh.get_exception())
            await p_session.refresh(try_refresh)
        var urlpath: String = "/v2/tournament/{tournamentId}"
        urlpath = urlpath.replace("{tournamentId}", NakamaSerializer.escape_http(p_tournament_id))
        var query_params = ""
        var uri = "%s%s%s" % [_base_uri, urlpath, "?" + query_params if query_params else ""]
        var method = "POST"
        var headers = {}
        var header = "Bearer %s" % p_session.token
        headers["Authorization"] = header

        var content: PackedByteArray
        content = JSON.stringify(p_record.serialize()).to_utf8_buffer()

        var result = await _http_adapter.send_async(method, uri, headers, content)
        if result is NakamaException:
            return ApiLeaderboardRecord.new(result)
        var out: ApiLeaderboardRecord = NakamaSerializer.deserialize(_namespace, "ApiLeaderboardRecord", result)
        return out


    func write_tournament_record_async(
        p_session: NakamaSession
        , p_tournament_id: String
        , p_record: WriteTournamentRecordRequestTournamentRecordWrite
    ) -> ApiLeaderboardRecord:
        var try_refresh = await _refresh_session(p_session)
        if try_refresh != null:
            if try_refresh.is_exception():
                return ApiLeaderboardRecord.new(try_refresh.get_exception())
            await p_session.refresh(try_refresh)
        var urlpath: String = "/v2/tournament/{tournamentId}"
        urlpath = urlpath.replace("{tournamentId}", NakamaSerializer.escape_http(p_tournament_id))
        var query_params = ""
        var uri = "%s%s%s" % [_base_uri, urlpath, "?" + query_params if query_params else ""]
        var method = "PUT"
        var headers = {}
        var header = "Bearer %s" % p_session.token
        headers["Authorization"] = header

        var content: PackedByteArray
        content = JSON.stringify(p_record.serialize()).to_utf8_buffer()

        var result = await _http_adapter.send_async(method, uri, headers, content)
        if result is NakamaException:
            return ApiLeaderboardRecord.new(result)
        var out: ApiLeaderboardRecord = NakamaSerializer.deserialize(_namespace, "ApiLeaderboardRecord", result)
        return out


    func join_tournament_async(
        p_session: NakamaSession
        , p_tournament_id: String
    ) -> NakamaAsyncResult:
        var try_refresh = await _refresh_session(p_session)
        if try_refresh != null:
            if try_refresh.is_exception():
                return NakamaAsyncResult.new(try_refresh.get_exception())
            await p_session.refresh(try_refresh)
        var urlpath: String = "/v2/tournament/{tournamentId}/join"
        urlpath = urlpath.replace("{tournamentId}", NakamaSerializer.escape_http(p_tournament_id))
        var query_params = ""
        var uri = "%s%s%s" % [_base_uri, urlpath, "?" + query_params if query_params else ""]
        var method = "POST"
        var headers = {}
        var header = "Bearer %s" % p_session.token
        headers["Authorization"] = header

        var content: PackedByteArray

        var result = await _http_adapter.send_async(method, uri, headers, content)
        if result is NakamaException:
            return NakamaAsyncResult.new(result)
        return NakamaAsyncResult.new()


    func list_tournament_records_around_owner_async(
        p_session: NakamaSession
        , p_tournament_id: String
        , p_owner_id: String
        , p_limit = null
        , p_expiry = null
        , p_cursor = null
    ) -> ApiTournamentRecordList:
        var try_refresh = await _refresh_session(p_session)
        if try_refresh != null:
            if try_refresh.is_exception():
                return ApiTournamentRecordList.new(try_refresh.get_exception())
            await p_session.refresh(try_refresh)
        var urlpath: String = "/v2/tournament/{tournamentId}/owner/{ownerId}"
        urlpath = urlpath.replace("{tournamentId}", NakamaSerializer.escape_http(p_tournament_id))
        urlpath = urlpath.replace("{ownerId}", NakamaSerializer.escape_http(p_owner_id))
        var query_params = ""
        if p_limit != null:
            query_params += "limit=%d&" % p_limit
        if p_expiry != null:
            query_params += "expiry=%s&" % NakamaSerializer.escape_http(p_expiry)
        if p_cursor != null:
            query_params += "cursor=%s&" % NakamaSerializer.escape_http(p_cursor)
        var uri = "%s%s%s" % [_base_uri, urlpath, "?" + query_params if query_params else ""]
        var method = "GET"
        var headers = {}
        var header = "Bearer %s" % p_session.token
        headers["Authorization"] = header

        var content: PackedByteArray

        var result = await _http_adapter.send_async(method, uri, headers, content)
        if result is NakamaException:
            return ApiTournamentRecordList.new(result)
        var out: ApiTournamentRecordList = NakamaSerializer.deserialize(_namespace, "ApiTournamentRecordList", result)
        return out


    func get_users_async(
        p_session: NakamaSession
        , p_ids = null
        , p_usernames = null
        , p_facebook_ids = null
    ) -> ApiUsers:
        var try_refresh = await _refresh_session(p_session)
        if try_refresh != null:
            if try_refresh.is_exception():
                return ApiUsers.new(try_refresh.get_exception())
            await p_session.refresh(try_refresh)
        var urlpath: String = "/v2/user"
        var query_params = ""
        if p_ids != null:
            for elem in p_ids:
                query_params += "ids=%s&" % elem
        if p_usernames != null:
            for elem in p_usernames:
                query_params += "usernames=%s&" % elem
        if p_facebook_ids != null:
            for elem in p_facebook_ids:
                query_params += "facebook_ids=%s&" % elem
        var uri = "%s%s%s" % [_base_uri, urlpath, "?" + query_params if query_params else ""]
        var method = "GET"
        var headers = {}
        var header = "Bearer %s" % p_session.token
        headers["Authorization"] = header

        var content: PackedByteArray

        var result = await _http_adapter.send_async(method, uri, headers, content)
        if result is NakamaException:
            return ApiUsers.new(result)
        var out: ApiUsers = NakamaSerializer.deserialize(_namespace, "ApiUsers", result)
        return out


    func list_user_groups_async(
        p_session: NakamaSession
        , p_user_id: String
        , p_limit = null
        , p_state = null
        , p_cursor = null
    ) -> ApiUserGroupList:
        var try_refresh = await _refresh_session(p_session)
        if try_refresh != null:
            if try_refresh.is_exception():
                return ApiUserGroupList.new(try_refresh.get_exception())
            await p_session.refresh(try_refresh)
        var urlpath: String = "/v2/user/{userId}/group"
        urlpath = urlpath.replace("{userId}", NakamaSerializer.escape_http(p_user_id))
        var query_params = ""
        if p_limit != null:
            query_params += "limit=%d&" % p_limit
        if p_state != null:
            query_params += "state=%d&" % p_state
        if p_cursor != null:
            query_params += "cursor=%s&" % NakamaSerializer.escape_http(p_cursor)
        var uri = "%s%s%s" % [_base_uri, urlpath, "?" + query_params if query_params else ""]
        var method = "GET"
        var headers = {}
        var header = "Bearer %s" % p_session.token
        headers["Authorization"] = header

        var content: PackedByteArray

        var result = await _http_adapter.send_async(method, uri, headers, content)
        if result is NakamaException:
            return ApiUserGroupList.new(result)
        var out: ApiUserGroupList = NakamaSerializer.deserialize(_namespace, "ApiUserGroupList", result)
        return out
