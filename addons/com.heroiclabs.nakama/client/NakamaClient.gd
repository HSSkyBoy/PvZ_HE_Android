extends RefCounted


class_name NakamaClient

const ChannelType = NakamaRTMessage.ChannelJoin.ChannelType


var _host
var host: String:
    set(v):
        pass
    get:
        return _host


var _port
var port: int:
    set(v):
        pass
    get:
        return _port


var _scheme
var scheme: String:
    set(v):
        pass
    get:
        return _scheme


var _server_key: String = "defaultkey"
var server_key:
    set(v):
        pass
    get:
        return _server_key


var timeout: int

var logger: NakamaLogger = null

var _api_client: NakamaAPI.ApiClient

var auto_refresh: bool = true:
    set(v):
        set_auto_refresh(v)
    get:
        return get_auto_refresh()

var auto_refresh_seconds: int = true:
    set(v):
        set_auto_refresh_seconds(v)
    get:
        return get_auto_refresh_seconds()

var auto_retry: bool = true:
    set(v):
        set_auto_retry(v)
    get:
        return get_auto_retry()

var auto_retry_count:
    set(v):
        set_auto_retry_count(v)
    get:
        return get_auto_retry_count()

var auto_retry_backoff_base:
    set(v):
        set_auto_retry_backoff_base(v)
    get:
        return get_auto_retry_backoff_base()

var last_cancel_token:
    set(v):
        pass
    get:
        return get_last_cancel_token()

func get_auto_refresh():
    return _api_client.auto_refresh

func set_auto_refresh(p_value):
    _api_client.auto_refresh = p_value

func get_auto_refresh_seconds():
    return _api_client.auto_refresh_time

func set_auto_refresh_seconds(p_value):
    _api_client.auto_refresh_time = p_value

func get_last_cancel_token():
    return _api_client.last_cancel_token

func get_auto_retry():
    return _api_client.auto_retry

func set_auto_retry(p_value):
    _api_client.auto_retry = p_value

func get_auto_retry_count():
    return _api_client.auto_retry_count

func set_auto_retry_count(p_value):
    _api_client.auto_retry_count = p_value

func get_auto_retry_backoff_base():
    return _api_client.auto_retry_backoff_base

func set_auto_retry_backoff_base(p_value):
    _api_client.auto_retry_backoff_base = p_value

func cancel_request(p_token):
    _api_client.cancel_request(p_token)

func _init(p_adapter: NakamaHTTPAdapter, 
        p_server_key: String, 
        p_scheme: String, 
        p_host: String, 
        p_port: int, 
        p_timeout: int):

    _server_key = p_server_key
    _scheme = p_scheme
    _host = p_host
    _port = p_port
    timeout = p_timeout
    logger = p_adapter.logger
    _api_client = NakamaAPI.ApiClient.new(_scheme + "://" + _host + ":" + str(_port), p_adapter, NakamaAPI, _server_key, p_timeout)





static func restore_session(auth_token: String):
    return NakamaSession.new(auth_token, false)

func _to_string():
    return "Client(Host=\'%s\', Port=%s, Scheme=\'%s\', ServerKey=\'%s\', Timeout=%s)" % [
        host, port, scheme, server_key, timeout
    ]

func _parse_auth(p_session) -> NakamaSession:
    if p_session.is_exception():
        return NakamaSession.new(null, false, null, p_session.get_exception())
    return NakamaSession.new(p_session.token, p_session.created, p_session.refresh_token)






func add_friends_async(p_session: NakamaSession, p_ids = null, p_usernames = null) -> NakamaAsyncResult:
    return await _api_client.add_friends_async(p_session, p_ids, p_usernames)






func add_group_users_async(p_session: NakamaSession, p_group_id: String, p_ids: PackedStringArray) -> NakamaAsyncResult:
    return await _api_client.add_group_users_async(p_session, p_group_id, p_ids);






func authenticate_apple_async(p_token: String, p_username = null, p_create: bool = true, p_vars = null) -> NakamaSession:
    return _parse_auth( await _api_client.authenticate_apple_async(server_key, "", 
        NakamaAPI.ApiAccountApple.create(NakamaAPI, {
            "token": p_token, 
            "vars": p_vars
        }), p_create, p_username))







func authenticate_custom_async(p_id: String, p_username = null, p_create: bool = true, p_vars = null) -> NakamaSession:
    return _parse_auth( await _api_client.authenticate_custom_async(server_key, "", 
        NakamaAPI.ApiAccountCustom.create(NakamaAPI, {
            "id": p_id, 
            "vars": p_vars
        }), p_create, p_username))







func authenticate_device_async(p_id: String, p_username = null, p_create: bool = true, p_vars = null) -> NakamaSession:
    return _parse_auth( await _api_client.authenticate_device_async(server_key, "", 
        NakamaAPI.ApiAccountDevice.create(NakamaAPI, {
            "id": p_id, 
            "vars": p_vars
        }), p_create, p_username))








func authenticate_email_async(p_email: String, p_password: String, p_username = null, p_create: bool = true, p_vars = null) -> NakamaSession:
    return _parse_auth( await _api_client.authenticate_email_async(server_key, "", 
        NakamaAPI.ApiAccountEmail.create(NakamaAPI, {
            "email": p_email, 
            "password": p_password, 
            "vars": p_vars
        }), p_create, p_username))








func authenticate_facebook_async(p_token: String, p_username = null, p_create: bool = true, p_import: bool = true, p_vars = null) -> NakamaSession:
    return _parse_auth( await _api_client.authenticate_facebook_async(server_key, "", 
        NakamaAPI.ApiAccountFacebook.create(NakamaAPI, {
            "token": p_token, 
            "vars": p_vars
        }), p_create, p_username, p_import))








func authenticate_facebook_instant_game_async(p_signed_player_info: String, p_username = null, p_create: bool = true, p_vars = null) -> NakamaSession:
        return _parse_auth( await _api_client.authenticate_facebook_instant_game_async(server_key, "", 
                NakamaAPI.ApiAccountFacebookInstantGame.create(NakamaAPI, {
                        "signed_player_info": p_signed_player_info, 
                        "vars": p_vars
                }), p_create, p_username))












func authenticate_game_center_async(p_bundle_id: String, p_player_id: String, p_public_key_url: String, 
        p_salt: String, p_signature: String, p_timestamp_seconds: String, p_username = null, p_create: bool = true, p_vars = null) -> NakamaSession:
    return _parse_auth( await _api_client.authenticate_game_center_async(server_key, "", 
        NakamaAPI.ApiAccountGameCenter.create(NakamaAPI, {
            "bundle_id": p_bundle_id, 
            "player_id": p_player_id, 
            "public_key_url": p_public_key_url, 
            "salt": p_salt, 
            "signature": p_signature, 
            "timestamp_seconds": p_timestamp_seconds, 
            "vars": p_vars
        }), p_create, p_username))







func authenticate_google_async(p_token: String, p_username = null, p_create: bool = true, p_vars = null) -> NakamaSession:
    return _parse_auth( await _api_client.authenticate_google_async(server_key, "", 
        NakamaAPI.ApiAccountGoogle.create(NakamaAPI, {
            "token": p_token, 
            "vars": p_vars
        }), p_create, p_username))







func authenticate_steam_async(p_token: String, p_username = null, p_create: bool = true, p_vars = null, p_sync: bool = false) -> NakamaSession:
    return _parse_auth( await _api_client.authenticate_steam_async(server_key, "", 
        NakamaAPI.ApiAccountSteam.create(NakamaAPI, {
            "token": p_token, 
            "vars": p_vars
        }), p_create, p_username, p_sync))






func block_friends_async(p_session: NakamaSession, p_ids: PackedStringArray, p_usernames = null) -> NakamaAsyncResult:
    return await _api_client.block_friends_async(p_session, p_ids, p_usernames);










func create_group_async(p_session: NakamaSession, p_name: String, p_description: String = "", 
        p_avatar_url = null, p_lang_tag = null, p_open: bool = true, p_max_count: int = 100):
    return await _api_client.create_group_async(p_session, 
        NakamaAPI.ApiCreateGroupRequest.create(NakamaAPI, {
            "avatar_url": p_avatar_url, 
            "description": p_description, 
            "lang_tag": p_lang_tag, 
            "max_count": p_max_count, 
            "name": p_name, 
            "open": p_open
        }))




func delete_account_async(p_session: NakamaSession) -> NakamaAsyncResult:
    return await _api_client.delete_account_async(p_session)






func delete_friends_async(p_session: NakamaSession, p_ids: PackedStringArray, p_usernames = null) -> NakamaAsyncResult:
    return await _api_client.delete_friends_async(p_session, p_ids, p_usernames)





func delete_group_async(p_session: NakamaSession, p_group_id: String) -> NakamaAsyncResult:
    return await _api_client.delete_group_async(p_session, p_group_id)





func delete_leaderboard_record_async(p_session: NakamaSession, p_leaderboard_id: String) -> NakamaAsyncResult:
    return await _api_client.delete_leaderboard_record_async(p_session, p_leaderboard_id)





func delete_notifications_async(p_session: NakamaSession, p_ids: PackedStringArray) -> NakamaAsyncResult:
    return await _api_client.delete_notifications_async(p_session, p_ids)





func delete_storage_objects_async(p_session: NakamaSession, p_ids: Array) -> NakamaAsyncResult:
    var ids: Array = []
    for id in p_ids:
        if not id is NakamaStorageObjectId:
            continue
        var obj_id: NakamaStorageObjectId = id
        ids.append(obj_id.as_delete().serialize())
    return await _api_client.delete_storage_objects_async(p_session, 
        NakamaAPI.ApiDeleteStorageObjectsRequest.create(NakamaAPI, {
            "object_ids": ids
        }))






func demote_group_users_async(p_session: NakamaSession, p_group_id: String, p_user_ids: Array):
    return await _api_client.demote_group_users_async(p_session, p_group_id, p_user_ids)






func event_async(p_session: NakamaSession, p_name: String, p_properties: Dictionary = {}) -> NakamaAsyncResult:
    return await _api_client.event_async(p_session, NakamaAPI.ApiEvent.create(
        NakamaAPI, 
        {
            "name": p_name, 
            "properties": p_properties, 
            "external": true, 
        }
    ))




func get_account_async(p_session: NakamaSession):
    return await _api_client.get_account_async(p_session)





func get_subscription_async(p_session: NakamaSession, p_product_id: String):
    return await _api_client.get_subscription_async(p_session, p_product_id)







func get_users_async(p_session: NakamaSession, p_ids: PackedStringArray, p_usernames = null, p_facebook_ids = null):
    return await _api_client.get_users_async(p_session, p_ids, p_usernames, p_facebook_ids)








func import_facebook_friends_async(p_session: NakamaSession, p_token: String, p_reset = null) -> NakamaAsyncResult:
    return await _api_client.import_facebook_friends_async(p_session, 
        NakamaAPI.ApiAccountFacebook.create(NakamaAPI, {
            "token": p_token
        }), p_reset)








func import_steam_friends_async(p_session: NakamaSession, p_token: String, p_reset = null):
    return await _api_client.import_steam_friends_async(p_session, 
        NakamaAPI.ApiAccountSteam.create(NakamaAPI, {
            "token": p_token
        }), p_reset)





func join_group_async(p_session: NakamaSession, p_group_id: String) -> NakamaAsyncResult:
    return await _api_client.join_group_async(p_session, p_group_id)





func join_tournament_async(p_session: NakamaSession, p_tournament_id: String) -> NakamaAsyncResult:
    return await _api_client.join_tournament_async(p_session, p_tournament_id)






func kick_group_users_async(p_session: NakamaSession, p_group_id: String, p_ids: PackedStringArray) -> NakamaAsyncResult:
    return await _api_client.kick_group_users_async(p_session, p_group_id, p_ids)





func leave_group_async(p_session: NakamaSession, p_group_id: String) -> NakamaAsyncResult:
    return await _api_client.leave_group_async(p_session, p_group_id)





func link_apple_async(p_session: NakamaSession, p_token: String) -> NakamaAsyncResult:
    return await _api_client.link_apple_async(p_session, NakamaAPI.ApiAccountApple.create(NakamaAPI, {
        "token": p_token
    }))





func link_custom_async(p_session: NakamaSession, p_id: String) -> NakamaAsyncResult:
    return await _api_client.link_custom_async(p_session, NakamaAPI.ApiAccountCustom.create(NakamaAPI, {
        "id": p_id
    }))





func link_device_async(p_session: NakamaSession, p_id: String) -> NakamaAsyncResult:
    return await _api_client.link_device_async(p_session, NakamaAPI.ApiAccountDevice.create(NakamaAPI, {
        "id": p_id
    }))






func link_email_async(p_session: NakamaSession, p_email: String, p_password: String) -> NakamaAsyncResult:
    return await _api_client.link_email_async(p_session, NakamaAPI.ApiAccountEmail.create(NakamaAPI, {
        "email": p_email, 
        "password": p_password
    }))






func link_facebook_async(p_session: NakamaSession, p_token: String) -> NakamaAsyncResult:
    return await _api_client.link_facebook_async(p_session, NakamaAPI.ApiAccountFacebook.create(NakamaAPI, {
        "token": p_token
    }))






func link_facebook_instant_game_async(p_session: NakamaSession, p_signed_player_info: String) -> NakamaAsyncResult:
    return await _api_client.link_facebook_instant_game_async(
        p_session, 
        NakamaAPI.ApiAccountFacebookInstantGame.create(
            NakamaAPI, {
                "signed_player_info": p_signed_player_info
            })
        )










func link_game_center_async(p_session: NakamaSession, 
        p_bundle_id: String, p_player_id: String, p_public_key_url: String, p_salt: String, p_signature: String, p_timestamp_seconds) -> NakamaAsyncResult:
    return await _api_client.link_game_center_async(p_session, 
        NakamaAPI.ApiAccountGameCenter.create(NakamaAPI, {
            "bundle_id": p_bundle_id, 
            "player_id": p_player_id, 
            "public_key_url": p_public_key_url, 
            "salt": p_salt, 
            "signature": p_signature, 
            "timestamp_seconds": p_timestamp_seconds, 
        }))





func link_google_async(p_session: NakamaSession, p_token: String) -> NakamaAsyncResult:
    return await _api_client.link_google_async(p_session, NakamaAPI.ApiAccountGoogle.create(NakamaAPI, {
        "token": p_token
    }))





func link_steam_async(p_session: NakamaSession, p_token: String, p_sync: bool = false) -> NakamaAsyncResult:
    return await _api_client.link_steam_async(p_session, NakamaAPI.ApiLinkSteamRequest.create(
        NakamaAPI, 
        {
            "account": NakamaAPI.ApiAccountSteam.create(NakamaAPI, {
                "token": p_token
            }).serialize(), 
            "sync": p_sync
        }

    ))








func list_channel_messages_async(p_session: NakamaSession, p_channel_id: String, limit: int = 1, 
        forward: bool = true, cursor = null):
    return await _api_client.list_channel_messages_async(p_session, p_channel_id, limit, forward, cursor)







func list_friends_async(p_session: NakamaSession, p_state = null, p_limit = null, p_cursor = null):
    return await _api_client.list_friends_async(p_session, p_limit, p_state, p_cursor)








func list_group_users_async(p_session: NakamaSession, p_group_id: String, p_state = null, p_limit = null, p_cursor = null):
    return await _api_client.list_group_users_async(p_session, p_group_id, p_limit, p_state, p_cursor)










func list_groups_async(p_session: NakamaSession, p_name = null, p_limit: int = 10, p_cursor = null, p_lang_tag = null, p_members = null, p_open = null):
    return await _api_client.list_groups_async(p_session, p_name, p_cursor, p_limit, p_lang_tag, p_members, p_open)









func list_leaderboard_records_async(p_session: NakamaSession, 
        p_leaderboard_id: String, p_owner_ids = null, p_expiry = null, p_limit: int = 10, p_cursor = null):
    return await _api_client.list_leaderboard_records_async(p_session, 
        p_leaderboard_id, p_owner_ids, p_limit, p_cursor, p_expiry)









func list_leaderboard_records_around_owner_async(p_session: NakamaSession, 
        p_leaderboar_id: String, p_owner_id: String, p_expiry = null, p_limit: int = 10, p_cursor = null):
    return await _api_client.list_leaderboard_records_around_owner_async(p_session, 
        p_leaderboar_id, p_owner_id, p_limit, p_expiry, p_cursor)










func list_matches_async(p_session: NakamaSession, p_min: int, p_max: int, p_limit: int, p_authoritative: bool, 
        p_label: String, p_query: String):
    return await _api_client.list_matches_async(p_session, p_limit, p_authoritative, p_label if p_label else null, p_min, p_max, p_query if p_query else null)






func list_notifications_async(p_session: NakamaSession, p_limit: int = 10, p_cacheable_cursor = null):
    return await _api_client.list_notifications_async(p_session, p_limit, p_cacheable_cursor)








func list_storage_objects_async(p_session: NakamaSession, p_collection: String, p_user_id: String = "", p_limit: int = 10, p_cursor = null):
    return await _api_client.list_storage_objects_async(p_session, p_collection, p_user_id, p_limit, p_cursor)






func list_subscriptions_async(p_session: NakamaSession, p_limit: int = 10, p_cursor = null):
    return await _api_client.list_subscriptions_async(p_session, NakamaAPI.ApiListSubscriptionsRequest.create(
        NakamaAPI, 
        {
            "cursor": p_cursor, 
            "limit": p_limit, 
        }
    ))









func list_tournament_records_around_owner_async(p_session: NakamaSession, 
        p_tournament_id: String, p_owner_id: String, p_limit: int = 10, p_cursor = null, p_expiry = null):
    return await _api_client.list_tournament_records_around_owner_async(p_session, p_tournament_id, p_owner_id, p_limit, p_expiry, p_cursor)









func list_tournament_records_async(p_session: NakamaSession, p_tournament_id: String, 
        p_owner_ids = null, p_limit: int = 10, p_cursor = null, p_expiry = null):
    return await _api_client.list_tournament_records_async(p_session, p_tournament_id, p_owner_ids, p_limit, p_cursor, p_expiry)










func list_tournaments_async(p_session: NakamaSession, p_category_start: int, p_category_end: int, 
        p_start_time: int, p_end_time: int, p_limit: int = 10, p_cursor = null):
    return await _api_client.list_tournaments_async(p_session, 
        p_category_start, p_category_end, p_start_time, p_end_time, p_limit, p_cursor)








func list_user_groups_async(p_session: NakamaSession, p_user_id: String, p_state = null, p_limit = null, p_cursor = null):
    return await _api_client.list_user_groups_async(p_session, p_user_id, p_limit, p_state, p_cursor)








func list_users_storage_objects_async(p_session: NakamaSession, 
        p_collection: String, p_user_id: String, p_limit: int, p_cursor: String):
    return await _api_client.list_storage_objects2_async(p_session, p_collection, p_user_id, p_limit, p_cursor)






func promote_group_users_async(p_session: NakamaSession, p_group_id: String, p_ids: PackedStringArray) -> NakamaAsyncResult:
    return await _api_client.promote_group_users_async(p_session, p_group_id, p_ids)





func read_storage_objects_async(p_session: NakamaSession, p_ids: Array):
    var ids = []
    for id in p_ids:
        if not id is NakamaStorageObjectId:
            continue
        var obj_id: NakamaStorageObjectId = id
        ids.append(obj_id.as_read().serialize())
    return await _api_client.read_storage_objects_async(p_session, 
        NakamaAPI.ApiReadStorageObjectsRequest.create(NakamaAPI, {
            "object_ids": ids
        }))






func rpc_async(p_session: NakamaSession, p_id: String, p_payload = null):
    if p_payload == null:
        return await _api_client.rpc_func2_async(p_session.token, p_id)
    return await _api_client.rpc_func_async(p_session.token, p_id, p_payload)







func rpc_async_with_key(p_http_key: String, p_id: String, p_payload = null):
    if p_payload == null:
        return await _api_client.rpc_func2_async("", p_id, null, p_http_key)
    return await _api_client.rpc_func_async("", p_id, p_payload, p_http_key)




func session_logout_async(p_session: NakamaSession) -> NakamaAsyncResult:
    return await _api_client.session_logout_async(p_session, 
        NakamaAPI.ApiSessionLogoutRequest.create(NakamaAPI, {
            "refresh_token": p_session.refresh_token, 
            "token": p_session.token
        }))






func session_refresh_async(p_sesison: NakamaSession, p_vars = null) -> NakamaSession:
    return _parse_auth( await _api_client.session_refresh_async(server_key, "", 
        NakamaAPI.ApiSessionRefreshRequest.create(NakamaAPI, {
            "token": p_sesison.refresh_token, 
            "vars": p_vars
        })))





func unlink_apple_async(p_session: NakamaSession, p_token: String) -> NakamaAsyncResult:
    return await _api_client.unlink_apple_async(p_session, NakamaAPI.ApiAccountApple.create(NakamaAPI, {
        "token": p_token
    }))





func unlink_custom_async(p_session: NakamaSession, p_id: String) -> NakamaAsyncResult:
    return await _api_client.unlink_custom_async(p_session, NakamaAPI.ApiAccountCustom.create(NakamaAPI, {
        "id": p_id
    }))





func unlink_device_async(p_session: NakamaSession, p_id: String) -> NakamaAsyncResult:
    return await _api_client.unlink_device_async(p_session, NakamaAPI.ApiAccountDevice.create(NakamaAPI, {
        "id": p_id
    }))






func unlink_email_async(p_session: NakamaSession, p_email: String, p_password: String) -> NakamaAsyncResult:
    return await _api_client.unlink_email_async(p_session, NakamaAPI.ApiAccountEmail.create(NakamaAPI, {
        "email": p_email, 
        "password": p_password
    }))





func unlink_facebook_async(p_session: NakamaSession, p_token: String) -> NakamaAsyncResult:
    return await _api_client.unlink_facebook_async(p_session, NakamaAPI.ApiAccountFacebook.create(NakamaAPI, {
        "token": p_token
    }))





func unlink_facebook_instant_game_async(p_session: NakamaSession, p_signed_player_info: String) -> NakamaAsyncResult:
    return await _api_client.unlink_facebook_instant_game_async(
        p_session, 
        NakamaAPI.ApiAccountFacebookInstantGame.create(NakamaAPI, {
            "signed_player_info": p_signed_player_info
        })
    )










func unlink_game_center_async(p_session: NakamaSession, 
        p_bundle_id: String, p_player_id: String, p_public_key_url: String, p_salt: String, p_signature: String, p_timestamp_seconds) -> NakamaAsyncResult:
    return await _api_client.unlink_game_center_async(p_session, 
        NakamaAPI.ApiAccountGameCenter.create(NakamaAPI, {
            "bundle_id": p_bundle_id, 
            "player_id": p_player_id, 
            "public_key_url": p_public_key_url, 
            "salt": p_salt, 
            "signature": p_signature, 
            "timestamp_seconds": p_timestamp_seconds, 
        }))





func unlink_google_async(p_session: NakamaSession, p_token: String) -> NakamaAsyncResult:
    return await _api_client.unlink_google_async(p_session, NakamaAPI.ApiAccountGoogle.create(NakamaAPI, {
        "token": p_token
    }))





func unlink_steam_async(p_session: NakamaSession, p_token: String) -> NakamaAsyncResult:
    return await _api_client.unlink_steam_async(p_session, NakamaAPI.ApiAccountSteam.create(NakamaAPI, {
        "token": p_token
    }))










func update_account_async(p_session: NakamaSession, p_username = null, p_display_name = null, 
        p_avatar_url = null, p_lang_tag = null, p_location = null, p_timezone = null) -> NakamaAsyncResult:
    return await _api_client.update_account_async(p_session, 
        NakamaAPI.ApiUpdateAccountRequest.create(NakamaAPI, {
            "avatar_url": p_avatar_url, 
            "display_name": p_display_name, 
            "lang_tag": p_lang_tag, 
            "location": p_location, 
            "timezone": p_timezone, 
            "username": p_username
        }))











func update_group_async(p_session: NakamaSession, 
        p_group_id: String, p_name = null, p_description = null, p_avatar_url = null, p_lang_tag = null, p_open = null) -> NakamaAsyncResult:
    return await _api_client.update_group_async(p_session, p_group_id, 
        NakamaAPI.ApiUpdateGroupRequest.create(NakamaAPI, {
            "name": p_name, 
            "open": p_open, 
            "avatar_url": p_avatar_url, 
            "description": p_description, 
            "lang_tag": p_lang_tag
        }))





func validate_purchase_apple_async(p_session: NakamaSession, p_receipt: String):
    return await _api_client.validate_purchase_apple_async(p_session, 
        NakamaAPI.ApiValidatePurchaseAppleRequest.create(NakamaAPI, {
            "receipt": p_receipt
        }))





func validate_purchase_google_async(p_session: NakamaSession, p_receipt: String):
    return await _api_client.validate_purchase_google_async(p_session, 
        NakamaAPI.ApiValidatePurchaseGoogleRequest.create(NakamaAPI, {
            "purchase": p_receipt
        }))






func validate_purchase_huawei_async(p_session: NakamaSession, p_receipt: String, p_signature: String):
    return await _api_client.validate_purchase_huawei_async(p_session, 
        NakamaAPI.ApiValidatePurchaseHuaweiRequest.create(NakamaAPI, {
            "purchase": p_receipt, 
            "signature": p_signature
        }))






func validate_subscription_apple_async(p_session: NakamaSession, p_receipt: String, p_persist: bool = true):
    return await _api_client.validate_subscription_apple_async(p_session, 
        NakamaAPI.ApiValidateSubscriptionAppleRequest.create(NakamaAPI, {
            "receipt": p_receipt, 
            "persist": p_persist, 
        }))






func validate_subscription_google_async(p_session: NakamaSession, p_receipt: String, p_persist: bool = true):
    return await _api_client.validate_subscription_google_async(p_session, 
        NakamaAPI.ApiValidateSubscriptionGoogleRequest.create(NakamaAPI, {
            "receipt": p_receipt, 
            "persist": p_persist, 
        }))








func write_leaderboard_record_async(p_session: NakamaSession, 
        p_leaderboard_id: String, p_score: int, p_subscore: int = 0, p_metadata = null):
    return await _api_client.write_leaderboard_record_async(p_session, p_leaderboard_id, 
        NakamaAPI.WriteLeaderboardRecordRequestLeaderboardRecordWrite.create(NakamaAPI, {
            "metadata": p_metadata, 
            "score": str(p_score), 
            "subscore": str(p_subscore)
        }))





func write_storage_objects_async(p_session: NakamaSession, p_objects: Array):
    var writes: Array = []
    for obj in p_objects:
        if not obj is NakamaWriteStorageObject:
            continue
        var write_obj: NakamaWriteStorageObject = obj
        writes.append(write_obj.as_write().serialize())
    return await _api_client.write_storage_objects_async(p_session, 
        NakamaAPI.ApiWriteStorageObjectsRequest.create(NakamaAPI, {
            "objects": writes
        }))








func write_tournament_record_async(p_session: NakamaSession, 
        p_tournament_id: String, p_score: int, p_subscore: int = 0, p_metadata = null):
    return await _api_client.write_tournament_record_async(p_session, p_tournament_id, 
        NakamaAPI.WriteTournamentRecordRequestTournamentRecordWrite.create(NakamaAPI, {
            "metadata": p_metadata, 
            "score": str(p_score), 
            "subscore": str(p_subscore)
        }))








func write_tournament_record2_async(p_session: NakamaSession, 
        p_tournament_id: String, p_score: int, p_subscore: int = 0, p_metadata = null):
    return await _api_client.write_tournament_record2_async(p_session, p_tournament_id, 
        NakamaAPI.WriteTournamentRecordRequestTournamentRecordWrite.create(NakamaAPI, {
            "metadata": p_metadata, 
            "score": str(p_score), 
            "subscore": str(p_subscore)
        }))
