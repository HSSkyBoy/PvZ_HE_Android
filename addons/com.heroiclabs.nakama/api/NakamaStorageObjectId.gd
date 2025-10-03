extends RefCounted
class_name NakamaStorageObjectId


var collection: String


var key: String


var user_id: String


var version: String

func _init(p_collection, p_key, p_user_id = "", p_version = ""):
    collection = p_collection
    key = p_key
    user_id = p_user_id
    version = p_version

func as_delete():
    return NakamaAPI.ApiDeleteStorageObjectId.create(NakamaAPI, {
        "collection": collection, 
        "key": key, 
        "version": version
    })

func as_read():
    return NakamaAPI.ApiReadStorageObjectId.create(NakamaAPI, {
        "collection": collection, 
        "key": key, 
        "user_id": user_id
    })
